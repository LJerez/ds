clc; clear; close all;
addpath('C:\Users\jinho\OneDrive\Desktop\Datascience\ds\PROGETTO DS\datasets\')
% %IMPORTING DATASET 
% % ~ NOT OPERATOR
%banche = readtable ("data24TA.xlsx",Sheet=2);
% banche = readtable ("finalp.xlsx",Sheet=2);
% newtab = tablefiltering(banche);
% writetable(newtab,'test2.xlsx')
 banks=readtable("test.xlsx");

% define variables
FromBank = string(banks.FirmName);
ToBanks = string(banks.SUB_Name);
Quantity = banks.SubDir;
%directed graph creation 
G = digraph(FromBank,ToBanks,Quantity);
Adj = adjacency(G);
fig = figure;
K = plot(G);

%filename = fullfile('figures', 'myPlot.png');
%exportgraphics(fig, filename, 'Resolution', 300);

%Sparseness of the data
disp('Original Density')
sparseness=100*nnz(Adj)/(length(Adj)^2)
sparseness2=100*nnz(Adj)/((length(Adj)*(length(Adj)-1)))
%we must use weak links for the GCC because otherwise the model won't find
%enough links
[bin, binsize] = conncomp(G,"Type","weak");

[~, idx] = max(binsize);         % index of the largest component
nodes_in_GCC = find(bin == idx); % nodes belonging to it
G_giant = subgraph(G, nodes_in_GCC);
AdjG = adjacency(G_giant);
%plot(G_giant)
disp('GCC Density')
100*nnz(AdjG)/(length(AdjG)^2)
100*nnz(AdjG)/(length(AdjG)*(length(AdjG)-1))
Nodi = G_giant.Nodes;
nodi_totali = numnodes(G);
nodi_giant = numnodes(G_giant);
nodi_persi = nodi_totali - nodi_giant;

fprintf('Nodi nel grafo originale: %d\n', nodi_totali);
fprintf('Nodi nella componente gigante: %d\n', nodi_giant);
nodi_totali/nodi_giant
fprintf('Nodi rimossi: %d\n', nodi_persi);
save('GCC_Bank2024.mat','AdjG',"Nodi")

