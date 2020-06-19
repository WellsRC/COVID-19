clear;
clc

% Load Covid Tracking prioject Data


T = readtable('COVIDTrackingProject.csv');
load('StatesA2.mat','S');
Date=(unique(T.date));
DateFull=(T.date);
CTests=zeros(length(S),length(Date)); % Calculated through positive increase and negative increase
CCases=zeros(length(S),length(Date)); % Cumulative count of positives
CDeaths=zeros(length(S),length(Date)); % Cumulative count of deaths

N = T.state;

CC=T.positive;
DD=T.death;
TT=T.positive+T.negative;
for jj=1:length(S)
indx=strcmp({S{jj}},N);
    for ii=1:length(Date)
        ff=find(Date(ii)==DateFull(indx));
        CT=CC(indx);
        DT=DD(indx);
        PT=TT(indx);
        if(~isempty(ff))
            CCases(jj,ii)=max(CT(ff),0);
            CDeaths(jj,ii)=max(DT(ff),0);
            CTests(jj,ii)=max(PT(ff),0);
        end
    end
end


%% Calcualte daily
Cases=zeros(size(CCases));
Deaths=zeros(size(CDeaths));

Tests=zeros(size(CTests));

Cases(:,1)=CCases(:,1);
Deaths(:,1)=CDeaths(:,1);
Tests(:,1)=CTests(:,1);

for ii=2:length(CDeaths(1,:))
    Cases(:,ii)=CCases(:,ii)-CCases(:,ii-1);
    Deaths(:,ii)=CDeaths(:,ii)-CDeaths(:,ii-1); 
    Tests(:,ii)=CTests(:,ii)-CTests(:,ii-1); 
end

% Correct for negative numbers

for ii=1:length(Cases(:,1))
   fneg=find(Cases(ii,:)<0);
   for jj=1:length(fneg)
       if(fneg(jj)<149)
           Cases(ii,fneg(jj))=round(Cases(ii,fneg(jj)-1)+(Cases(ii,fneg(jj)+1)-Cases(ii,fneg(jj)-1))/2);
       else
           Cases(ii,fneg(jj))=max(round(pchip([1:148],Cases(ii,[1:148]),149)),0); % use pchip for end point, if negative set to zero
       end
   end
   fneg=find(Deaths(ii,:)<0);
   for jj=1:length(fneg)
       if(fneg(jj)<149)
            Deaths(ii,fneg(jj))=round(Deaths(ii,fneg(jj)-1)+(Deaths(ii,fneg(jj)+1)-Deaths(ii,fneg(jj)-1))/2);
       else
            Deaths(ii,fneg(jj))=max(round(pchip([1:148],Deaths(ii,[1:148]),149)),0); % use pchip for end point, if negative set to zero
       end
   end
   
   fneg=find(Tests(ii,:)<0);
   for jj=1:length(fneg)
       if(fneg(jj)<149)
            Tests(ii,fneg(jj))=round(Tests(ii,fneg(jj)-1)+(Tests(ii,fneg(jj)+1)-Tests(ii,fneg(jj)-1))/2);
       else
            Tests(ii,fneg(jj))=max(round(pchip([1:148],Tests(ii,[1:148]),149)),0); % use pchip for end point, if negative set to zero
       end
   end
end


%% Write data
xlswrite('DataforModel_Test.xlsx', flip(Tests(:,[datenum('Janaury 22,2020'):datenum('June 18,2020')]-datenum('Janaury 21,2020'))')) 
xlswrite('DataforModel_Incidence.xlsx', flip(Cases(:,[datenum('Janaury 22,2020'):datenum('June 18,2020')]-datenum('Janaury 21,2020'))')) 
xlswrite('DataforModel_Death.xlsx', flip(Deaths(:,[datenum('Janaury 22,2020'):datenum('June 18,2020')]-datenum('Janaury 21,2020'))')) 
xlswrite('StatesinFitting.xlsx', [{S}]) 
