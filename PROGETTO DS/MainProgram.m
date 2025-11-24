clc;clearvars;close all
%% add path
addpath('C:\Users\jinho\OneDrive\Desktop\Datascience\2019_03_03_BCT')

%% param
year=[2024];

%% example 
IN_Strength = cell(size(year));
%% load
for i = 1:length(year)
    filename = ['GCC_Bank',num2str(year(i)),'.mat'];
    load(filename);
    G = digraph(AdjG')
    %  compute instrength
    [ins,outs, stren] = strengths_dir(AdjG);
    
PR = centrality(G, 'pagerank');
[PRsorted, idx] = sort(PR, 'descend');

% Mostra i top 5 nodi
topN = min(5, numel(PR));  % in caso di grafo piccolo
fprintf('Top %d nodi per PageRank:\n', topN);
for i = 1:topN
    fprintf('%d) %s - %.4f\n', i, Nodi.Name{idx(i)}, PRsorted(i));
end
% %%%%%%%%%%
% BC = centrality(G, 'betweenness');
% 
% % Ordina i valori in ordine decrescente
% [BCsorted, idx] = sort(BC, 'descend');

% Mostra i top 5 nodi
% topN = min(5, numel(BC));
% fprintf('Top %d nodi per Betweenness Centrality:\n', topN);
% for i = 1:topN
%     fprintf('%d) %s - %.4f\n', i, Nodi.Name{idx(i)}, BCsorted(i));
% end
% [outsSorted, idx] = sort(full(outs), 'descend');  % converti in normale array
% topN = min(40, numel(outsSorted));
% fprintf('Top %d nodi per Outdegree:\n', topN);
% for i = 1:topN
%     nodoName = Nodi.Name(idx(i));
%     if iscell(nodoName)
%         nodoName = nodoName{1};  % estrai stringa da cell
%     end
%     fprintf('%d) %s - %d archi in uscita\n', i, nodoName, outsSorted(i));
% end


end