%clc; clear; close all;
% %IMPORTING DATASET 
% % ~ NOT OPERATOR
%banche = readtable ("banchedata.xlsx",Sheet=2);
%newtab = tablefiltering(banche);
%writetable(newtab,'datasetBank.xlsx')
banks=readtable("datasetBank.xlsx");

% define variables
FromBank = string(banks.FirmName);
ToBanks = string(banks.SUB_Name);
Quantity = banks.SubDir;

G = digraph(FromBank,ToBanks,Quantity);
Adj = adjacency(G);

disp('Original Density')
100*nnz(Adj)/(length(Adj)^2)



[bin, binsize] = conncomp(G,"Type","weak");

[~, idx] = max(binsize);         % index of the largest component
nodes_in_GCC = find(bin == idx); % nodes belonging to it
G_giant = subgraph(G, nodes_in_GCC);
AdjG = adjacency(G_giant);

disp('GCC Density')
100*nnz(AdjG)/(length(AdjG)^2)

Nodi = G_giant.Nodes;
save('GCC_Bank.mat','AdjG',"Nodi")

