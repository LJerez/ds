%clc; clear; close all;
% %IMPORTING DATASET 
% % ~ NOT OPERATOR
%banche = readtable ("banchedata.xlsx",Sheet=2);
%newtab = tablefiltering(banche);
%writetable(newtab,'datasetBank.xlsx')
banks=readtable("datasetBank.xlsx");