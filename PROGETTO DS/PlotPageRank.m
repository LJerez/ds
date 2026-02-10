function [PR, PRsorted, idx] = PlotPageRank(G, Nodi, AdjG)
% d = 0.85; % Damping factor standard
% PR = pagerank_centrality(AdjG, d); 
% 
% % 2. Ordina i risultati (questa parte resta identica)
% [PRsorted, idx] = sort(PR, 'descend');
% 
% % 3. Mostra i top nodi
% topN = min(10, numel(PR));
% fprintf('Top %d nodes with Custom PageRank:\n', topN);
% for i = 1:topN
%     % Assicurati che "Nodi" sia la tabella/struttura corretta che contiene i nomi
%     fprintf('%d) %s - %.4f\n', i, Nodi.Name{idx(i)}, PRsorted(i));
% end
PR = centrality(G, 'pagerank', 'Importance', G.Edges.Weight);
[PRsorted, idx] = sort(PR, 'descend');


% Mostra i top 5 nodi
topN = min(10, numel(PR));  % in caso di grafo piccolo
fprintf('Top %d nodes with PageRank:\n', topN);
for i = 1:topN
    fprintf('%d) %s - %.4f\n', i, Nodi.Name{idx(i)}, PRsorted(i));
end
ExportToGephi(G,Nodi,PR)
% Ensure Betweenness is calculated if not already in workspace
if ~exist('BC', 'var')
    BC = centrality(G, 'betweenness'); 
end
% 
% % Create table
% NodesTable = table(Nodi.Name, Nodi.Name, PR, BC, ...
%     'VariableNames', {'Id', 'Label', 'PageRank', 'Betweenness'});
% 
% % Save to CSV
% writetable(NodesTable, 'gephi_nodes.csv');
% fprintf('Nodes exported to gephi_nodes.csv\n');
% 
% % --- 2. Create the EDGES table ---
% % Gephi requires 'Source' and 'Target' columns.
% 
% % Extract Source and Target from the Graph object
% Source = G.Edges.EndNodes(:, 1);
% Target = G.Edges.EndNodes(:, 2);
% 
% EdgesTable = table(Source, Target, 'VariableNames', {'Source', 'Target'});
% 
% % Check if the graph has Weights and add them if present
% if ismember('Weight', G.Edges.Properties.VariableNames)
%     EdgesTable.Weight = G.Edges.Weight;
% end
% 
% % Save to CSV
% writetable(EdgesTable, 'gephi_edges.csv');
% fprintf('Edges exported to gephi_edges.csv\n');
% figure('Name', 'PageRank Analysis', 'Color', 'w');
% 
%     % 1. Create the plot
%     p = plot(G, 'Layout', 'force');
%     title('Network Graph - Nodes Colored by PageRank');
% 
%     % 2. Styling (Transparency for "hairball" reduction)
%     p.EdgeColor = [0.6 0.6 0.6]; 
%     p.EdgeAlpha = 0.2;           
%     p.LineWidth = 0.5;           
%     p.ArrowSize = 3;             
%     p.MarkerSize = 2;            % Small default size for all nodes
%     p.NodeLabel = {};            % Clear all default labels
% 
%     % 3. Apply PageRank Colors
%     p.NodeCData = PR;            % Color based on PageRank
%     colormap jet;
%     colorbar;
% 
%     % 4. Highlight Top 5 Nodes (Size ONLY)
%     % We change the size, but keep the color derived from PageRank
%     topM = min(5, numel(PR));
%     top5_indices = idx(1:topM);
% 
%     % This command changes size without overwriting the CData color
%     highlight(p, top5_indices, 'MarkerSize', 10);
% 
%     % 5. Manual Text Placement (Top 5 Only)
%     X = p.XData;
%     Y = p.YData;
% 
%     for i = 1:topM
%         nodeIdx = top5_indices(i);
% 
%         txt = Nodi.Name{nodeIdx};
%         x_pos = X(nodeIdx);
%         y_pos = Y(nodeIdx);
% 
%         text(x_pos, y_pos, ['  ' txt], ...
%             'FontSize', 9, ... 
%             'FontWeight', 'bold', ...
%             'Color', 'k', ... 
%             'Interpreter', 'none'); 
%     end
% 
%     axis off;
% Calcolo betweenness (funziona con digraph e graph)
fprintf('\n=== Betweenness Centrality ===\n');
BC = centrality(G, 'betweenness');
[BC_sorted, idx] = sort(BC, 'descend');
fprintf('Top %d nodi per Betweenness:\n', topN);

for i = 1:topN
    fprintf('%d) %s - %.4f\n', i, Nodi.Name{idx(i)}, BC_sorted(i));
end
% Calcolo della Closeness Centrality
Closeness = centrality(G, 'incloseness');

% Ordinamento dei valori in ordine decrescente
[C_sorted, idx] = sort(Closeness, 'descend');

% Selezione dei top 10 nodi (o meno, se il grafo ha meno nodi)
topN = min(10, numel(Closeness)); 

fprintf('Top %d nodes with Closeness Centrality:\n', topN);

% Loop per la stampa dei risultati
for i = 1:topN
    % Nota: Si assume che la tabella/struct 'Nodi' esista nel workspace
    fprintf('%d) %s - %.4f\n', i, Nodi.Name{idx(i)}, C_sorted(i));
end
% % --- 2. Plot ---
% figure;
% p = plot(G, 'Layout', 'force');   % Cambia in 'circle' se vuoi più leggerezza
% 
% % Dimensione proporzionale al PageRank
% scaleFactor = 100;
% p.MarkerSize = scaleFactor * PR;
% 
% % Colore in base al PageRank
% p.NodeCData = PR;
% colormap(jet);
% colorbar;
% 
% % Titolo
% title('Node centrality (PageRank)');
% Calcolo del Degree (Totale: In-Degree + Out-Degree)
% Restituisce il numero totale di archi collegati al nodo (indipendentemente dalla direzione)
Deg = indegree(G); 

% Ordinamento in ordine decrescente
[DegSorted, idx] = sort(Deg, 'descend');

% Mostra i top 10 nodi (o meno se il grafo è piccolo)
topN = min(10, numel(Deg)); 

fprintf('Top %d nodes by Total Degree (Connections):\n', topN);

for i = 1:topN
    % idx(i) è l'indice del nodo originale
    % DegSorted(i) è il valore del grado (numero intero)
    fprintf('%d) %s - %d connections\n', i, Nodi.Name{idx(i)}, DegSorted(i));
end
end
