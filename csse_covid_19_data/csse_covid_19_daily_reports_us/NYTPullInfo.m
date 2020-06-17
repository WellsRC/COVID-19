clear;
clc

load('States.mat','S');

T = readtable('NYTimes_Data_States.csv');
Date=unique(datenum(T.date));
DateFull=datenum(T.date);
Cases=zeros(length(S),length(Date));
Deaths=zeros(length(S),length(Date));

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
            Cases(jj,ii)=CT(ff);
            Deaths(jj,ii)=DT(ff);
        end
    end
end


xlswrite('Dataset_NYTimes.xlsx', Cases, 'Incidence_Cumulative', 'B2:ER57') 
xlswrite('Dataset_NYTimes.xlsx', Deaths, 'Death_Cumulative', 'B2:ER57') 