clc,clearvars, close all
datiraw= readtable("datasetBank.xlsx");
banche = string(datiraw.FirmName);
TurnOver = datiraw.TO;
tolgo = isnan(TurnOver);
banche(tolgo)=[];
TurnOver(tolgo)=[];

load("GCC_Bank.mat","Nodi")

[Lia,Locb] =ismember(banche,table2array(Nodi));
TurnOver2 = TurnOver(Locb);
NodiNew = Nodi

