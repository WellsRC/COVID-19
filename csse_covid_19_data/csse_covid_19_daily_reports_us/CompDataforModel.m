clear;
clc

T = readtable('COVIDTrackingProject.csv');
S=unique(T.state);
Date=unique(T.date);
DateFull=(T.date);
Tests=zeros(length(S),length(Date));
TestsViral=zeros(length(S),length(Date));
CCases=zeros(length(S),length(Date));
CDeaths=zeros(length(S),length(Date));

N = T.state;

CC=T.positive;
DD=T.death;
TT=T.positiveIncrease+T.negativeIncrease;
TV=T.totalTestsViral;
for jj=1:length(S)
indx=strcmp({S{jj}},N);
    for ii=1:length(Date)
        ff=find(Date(ii)==DateFull(indx));
        CT=CC(indx);
        DT=DD(indx);
        PT=TT(indx);
        TVV=TV(indx);
        if(~isempty(ff))
            CCases(jj,ii)=CT(ff);
            CDeaths(jj,ii)=DT(ff);
            Tests(jj,ii)=PT(ff);
        end
    end
end

Cases=zeros(size(CCases));
Deaths=zeros(size(CDeaths));

Cases(:,1)=CCases(:,1);
Deaths(:,1)=CDeaths(:,1);

for ii=2:length(CDeaths(1,:))
    Cases(:,ii)=CCases(:,ii)-CCases(:,ii-1);
    Deaths(:,ii)=CDeaths(:,ii)-CDeaths(:,ii-1); 
end

for ii=1:length(Cases(:,1))
   fneg=find(Cases(ii,:)<0);
   for jj=1:length(fneg)
       Cases(ii,fneg(jj))=round(Cases(ii,fneg(jj)-1)+(Cases(ii,fneg(jj)+1)-Cases(ii,fneg(jj)-1))/2);
   end
   fneg=find(Deaths(ii,:)<0);
   for jj=1:length(fneg)
       Deaths(ii,fneg(jj))=round(Deaths(ii,fneg(jj)-1)+(Deaths(ii,fneg(jj)+1)-Deaths(ii,fneg(jj)-1))/2);
   end
   
   fneg=find(Tests(ii,:)<0);
   for jj=1:length(fneg)
       Tests(ii,fneg(jj))=round(Tests(ii,fneg(jj)-1)+(Tests(ii,fneg(jj)+1)-Tests(ii,fneg(jj)-1))/2);
   end
end


Peak=zeros(length(Cases(:,1)),1);
for ii=1:length(Peak)
   Peak(ii)=find(Cases(ii,:)==max(Cases(ii,:)),1);
end

PeakTrunk=find(Peak<=100);
DeathTrunk=find(CDeaths(PeakTrunk,end)>20);

StateRem=PeakTrunk(DeathTrunk);


csvwrite('DataforModel_Test.csv', Tests) 
csvwrite('DataforModel_Incidence.csv', Cases) 
csvwrite('DataforModel_Death.csv', Deaths) 
xlswrite('StatesinFitting.xlsx', {S{StateRem}}) 