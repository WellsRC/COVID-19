clear;
clc

load('States.mat','S');

T = readtable('04-12-2020.csv');

Tests=zeros(length(S),1);
Cases=zeros(length(S),1);
Deaths=zeros(length(S),1);

N = T.Province_State;

TT=T.People_Tested;
CC=T.Confirmed;
DD=T.Deaths;
for jj=1:length(S)
indx=strcmp({S{jj}},N);
Tests(jj)=TT(indx);
Cases(jj)=CC(indx);
Deaths(jj)=DD(indx);
end

for ii=1:64
T = readtable([ datestr(datenum('04-12-2020')+ii,'mm-dd-yyyy') '.csv']);
N = T.Province_State;
TempT=zeros(length(S),1);
TempC=zeros(length(S),1);
TempD=zeros(length(S),1);
TT=T.People_Tested;
CC=T.Confirmed;
DD=T.Deaths;
for jj=1:length(S)
indx=strcmp({S{jj}},N);
TempT(jj)=TT(indx);
TempC(jj)=CC(indx);
TempD(jj)=DD(indx);
end
Tests=[Tests TempT];
Cases=[Cases TempC];
Deaths=[Deaths TempD];
end