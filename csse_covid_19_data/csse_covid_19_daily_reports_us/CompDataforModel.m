clear;
clc

% Load Covid Tracking prioject Data
T = readtable('COVIDTrackingProject.csv');
load('StatesA.mat','S');
SA=S;
Date=unique(T.date);
Date=Date(1:end-1); % Need to truncate the date such that the two merged data sets are the same; COVID Tracking project starts Jan 22 and goes to June 16
DateFull=(T.date);
Tests=zeros(length(S),length(Date));

N = T.state;

TT=T.positiveIncrease+T.negativeIncrease;
for jj=1:length(S)
indx=strcmp({S{jj}},N);
    for ii=1:length(Date)
        ff=find(Date(ii)==DateFull(indx));
        PT=TT(indx);
        if(~isempty(ff))
            Tests(jj,ii)=PT(ff);
        end
    end
end

% Load NY Times Data

load('States.mat','S');

T = readtable('NYTimes_Data_States.csv');
Date=unique(datenum(T.date));
Date=Date(2:end); % need to remove the first time point as this data set start Jan 21 (the other starts Jan 22)
DateFull=datenum(T.date);
CCases=zeros(length(S),length(Date));
CDeaths=zeros(length(S),length(Date));

N = T.state;

CC=T.cases;
DD=T.deaths;
for jj=1:length(S)
indx=strcmp({S{jj}},N);
    for ii=1:length(Date)
        ff=find(Date(ii)==DateFull(indx));
        CT=CC(indx);
        DT=DD(indx);
        if(~isempty(ff))
            CCases(jj,ii)=CT(ff);
            CDeaths(jj,ii)=DT(ff);
        end
    end
end

%% Calcualte daily
Cases=zeros(size(CCases));
Deaths=zeros(size(CDeaths));

Cases(:,1)=CCases(:,1);
Deaths(:,1)=CDeaths(:,1);

for ii=2:length(CDeaths(1,:))
    Cases(:,ii)=CCases(:,ii)-CCases(:,ii-1);
    Deaths(:,ii)=CDeaths(:,ii)-CDeaths(:,ii-1); 
end

% Correct for negative numbers

for ii=1:length(Cases(:,1))
   fneg=find(Cases(ii,:)<0);
   for jj=1:length(fneg)
       if(fneg(jj)<146)
           Cases(ii,fneg(jj))=round(Cases(ii,fneg(jj)-1)+(Cases(ii,fneg(jj)+1)-Cases(ii,fneg(jj)-1))/2);
       else
           Cases(ii,fneg(jj))=max(round(pchip([1:145],Cases(ii,[1:145]),146)),0); % use pchip for end point, if negative set to zero
       end
   end
   fneg=find(Deaths(ii,:)<0);
   for jj=1:length(fneg)
       if(fneg(jj)<146)
            Deaths(ii,fneg(jj))=round(Deaths(ii,fneg(jj)-1)+(Deaths(ii,fneg(jj)+1)-Deaths(ii,fneg(jj)-1))/2);
       else
            Deaths(ii,fneg(jj))=max(round(pchip([1:145],Deaths(ii,[1:145]),146)),0); % use pchip for end point, if negative set to zero
       end
   end
   
   fneg=find(Tests(ii,:)<0);
   for jj=1:length(fneg)
       if(fneg(jj)<146)
            Tests(ii,fneg(jj))=round(Tests(ii,fneg(jj)-1)+(Tests(ii,fneg(jj)+1)-Tests(ii,fneg(jj)-1))/2);
       else
            Tests(ii,fneg(jj))=max(round(pchip([1:145],Tests(ii,[1:145]),146)),0); % use pchip for end point, if negative set to zero
       end
   end
end

%% Filter data

Peak=zeros(length(Cases(:,1)),1);
for ii=1:length(Peak)
   Peak(ii)=find(Cases(ii,:)==max(Cases(ii,:)),1);
end

PeakTrunk=find(Peak<=100);
DeathTrunk=find(CDeaths(PeakTrunk,end)>20);

StateRem=PeakTrunk(DeathTrunk);

%% Write data
csvwrite('DataforModel_Test.csv', Tests(StateRem,1:100)) 
csvwrite('DataforModel_Incidence.csv', Cases(StateRem,1:100)) 
csvwrite('DataforModel_Death.csv', Deaths(StateRem,1:100)) 
xlswrite('StatesinFitting.xlsx', [{S{StateRem}}' {SA{StateRem}}']) 