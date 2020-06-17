clear;
clc

T = readtable('COVIDTrackingProject.csv');
S=unique(T.state);
Date=unique(T.date);
DateFull=(T.date);
Tests=zeros(length(S),length(Date));
TestsViral=zeros(length(S),length(Date));
Cases=zeros(length(S),length(Date));
Deaths=zeros(length(S),length(Date));

N = T.state;

CC=T.positiveIncrease;
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
            Cases(jj,ii)=CT(ff);
            Deaths(jj,ii)=DT(ff);
            Tests(jj,ii)=PT(ff);
            TestsViral(jj,ii)=TVV(ff);
        end
    end
end
