function [PR, PRsorted, idx] = PlotPageRank(G, Nodi)
% PLOTPAGERANK - Calcola PageRank e produce un grafico del grafo con nodi
% colorati e scalati in base al PageRank
%
% Input:
%   G  - digraph o graph MATLAB
%
% Output:
%   PR        - vettore PageRank
%   PRsorted  - PageRank ordinati in modo decrescente
%   idx       - indici dei nodi ordinati per PageRank
PR = centrality(G, 'pagerank');
[PRsorted, idx] = sort(PR, 'descend');


% Mostra i top 5 nodi
topN = min(5, numel(PR));  % in caso di grafo piccolo
fprintf('Top %d nodes with PageRank:\n', topN);
for i = 1:topN
    fprintf('%d) %s - %.4f\n', i, Nodi.Name{idx(i)}, PRsorted(i));
end
% Calcolo betweenness (funziona con digraph e graph)
fprintf('\n=== Betweenness Centrality ===\n');
BC = centrality(G, 'betweenness');
[BC_sorted, idx] = sort(BC, 'descend');
fprintf('Top %d nodi per Betweenness:\n', topN);

for i = 1:topN
    fprintf('%d) %s - %.4f\n', i, Nodi.Name{idx(i)}, BC_sorted(i));
end
    % --- 1. PageRank ---
    PR = centrality(G, 'pagerank');
    [PRsorted, idx] = sort(PR, 'descend');

    % --- 2. Plot ---
    figure;
    p = plot(G, 'Layout', 'force');   % Cambia in 'circle' se vuoi più leggerezza

    % Dimensione proporzionale al PageRank
    scaleFactor = 100;
    p.MarkerSize = scaleFactor * PR;

    % Colore in base al PageRank
    p.NodeCData = PR;
    colormap(jet);
    colorbar;

    % Titolo
    title('Node centrality (PageRank)');
end
