function [SCC_nodes, IN_nodes, OUT_nodes, tubes, tendrils] = BowtieFunc(AdjG, Nodi,year,yearDir)
% BOWTIEFUNC - Calcola struttura Bow-Tie di un grafo orientato
M = digraph(AdjG', Nodi.Name);

% --- 1. Trova la SCC principale ---
S = conncomp(M,'Type','strong');
component_sizes = histcounts(S, 1:max(S)+1);
[~, SCC_id] = max(component_sizes);
SCC_nodes = find(S == SCC_id);

% --- 2. Trova IN-component ---
IN_nodes = [];
for i = 1:numnodes(M)
    if ~ismember(i, SCC_nodes)
        for s = SCC_nodes
            if shortestpath(M, i, s) < Inf
                IN_nodes(end+1) = i;
                break;
            end
        end
    end
end

% --- 3. Trova OUT-component ---
OUT_nodes = [];
for i = 1:numnodes(M)
    if ~ismember(i, SCC_nodes)
        for s = SCC_nodes
            if shortestpath(M, s, i) < Inf
                OUT_nodes(end+1) = i;
                break;
            end
        end
    end
end

% --- 4. Calcola tubes e tendrils ---
all_nodes = 1:numnodes(M);
candidates = setdiff(all_nodes, [SCC_nodes, IN_nodes, OUT_nodes]);

% BFS da IN
visited_from_IN = false(numnodes(M),1);
queue = IN_nodes;
visited_from_IN(queue) = true;
head = 1;
while head <= numel(queue)
    v = queue(head); head = head + 1;
    succ = successors(M,v);
    for w = succ'
        if ~visited_from_IN(w)
            visited_from_IN(w) = true;
            queue(end+1) = w;
        end
    end
end

% BFS verso OUT
visited_to_OUT = false(numnodes(M),1);
queue = OUT_nodes;
visited_to_OUT(queue) = true;
head = 1;
while head <= numel(queue)
    v = queue(head); head = head + 1;
    pred = predecessors(M,v);
    for w = pred'
        if ~visited_to_OUT(w)
            visited_to_OUT(w) = true;
            queue(end+1) = w;
        end
    end
end

% Classificazione candidates
tubes = [];
tendrils = [];
for n = candidates
    if visited_from_IN(n) && visited_to_OUT(n)
        tubes(end+1) = n;
    elseif visited_from_IN(n) || visited_to_OUT(n)
        tendrils(end+1) = n;
    end
end

other_nodes = setdiff(candidates, [tubes, tendrils]);

% --- Subgraph per visualizzazione ---
display_nodes = [SCC_nodes, IN_nodes, OUT_nodes, tubes, tendrils];
G_sub = subgraph(M, display_nodes);
colors = zeros(numnodes(G_sub),3);
idx_map = containers.Map(display_nodes, 1:numel(display_nodes));
for n = SCC_nodes, colors(idx_map(n),:) = [1 0 0]; end       % rosso
for n = IN_nodes,  colors(idx_map(n),:) = [0 0 1]; end       % blu
for n = OUT_nodes, colors(idx_map(n),:) = [0 1 0]; end       % verde
for n = tubes,     colors(idx_map(n),:) = [1 0.5 0]; end     % arancio
for n = tendrils,  colors(idx_map(n),:) = [0.6 0 0.6]; end   % viola
figure;
plot(G_sub, 'NodeColor', colors, 'Layout','force');
title('Bow-Tie Structure: IN (blu), SCC (rosso), OUT (verde), Tubes (arancio), Tendrils (viola)');
fileName = ['GCC' year '.png'];
exportgraphics(gcf, fullfile(yearDir, fileName), 'Resolution', 300);

% Nomi singoli nodi
% fprintf('\nNodi nella SCC:\n');     disp(Nodi.Name(SCC_nodes));
% fprintf('\nNodi nella IN:\n');      disp(Nodi.Name(IN_nodes));
% fprintf('\nNodi nella OUT:\n');     disp(Nodi.Name(OUT_nodes));
% fprintf('\nNodi nei Tubes:\n');     disp(Nodi.Name(tubes));
% fprintf('\nNodi nei Tendrils:\n');  disp(Nodi.Name(tendrils));
% OUTPUT
fprintf('SCC: %d, IN: %d, OUT: %d, Tubes: %d, Tendrils: %d, Other: %d\n', ...
   numel(SCC_nodes), numel(IN_nodes), numel(OUT_nodes), numel(tubes), numel(tendrils), numel(other_nodes));

end
