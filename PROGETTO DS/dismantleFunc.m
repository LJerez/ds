function [outputArg1,outputArg2] = dismantleFunc(AdjG,inputArg2)
%DISMANTLEFUNC Summary of this function goes here
clc; clearvars; close all;

% --- 1. LOAD YOUR DATA ---
% Assuming you have your adjacency matrix loaded as 'AdjMatrix'
% If you don't, create a dummy one for testing:
% AdjMatrix = rand(100); AdjMatrix(AdjMatrix < 0.95) = 0; % Sparse random directed weighted
% Ensure diagonal is zero (no self-loops)
% AdjMatrix(1:size(AdjMatrix,1)+1:end) = 0;

% IMPORTANT: Start with the Giant Weakly Connected Component
% (If you haven't filtered it yet, this block does it for you)
G_raw = digraph(AdjMatrix);
weak_bins = conncomp(G_raw, 'Type', 'weak');
[counts, ~] = histcounts(weak_bins);
[~, max_bin_idx] = max(counts);
nodes_to_keep = find(weak_bins == max_bin_idx);
AdjMatrix = AdjMatrix(nodes_to_keep, nodes_to_keep);

% --- 2. PARAMETERS ---
% Strategy: 'random' (Failure) or 'targeted' (Attack)
strategy = 'targeted'; 

% Metric for Targeting (Only if strategy is 'targeted'):
% 'degree' (Total links) or 'strength' (Total weight/value)
metric_type = 'degree'; 

N = size(AdjMatrix, 1);
remaining_nodes = 1:N; % Track original indices if needed

% Create the initial Graph Object (Weighted & Directed)
G = digraph(AdjMatrix);

% Initialize storage for results
giant_component_sizes = [];
removed_count = 0;

% Calculate initial LCC size (should be N or close to it)
giant_component_sizes(end+1) = numnodes(G); 

% --- 3. SIMULATION LOOP ---
fprintf('Starting simulation with %d nodes...\n', N);

while numnodes(G) > 1
    
    % A. IDENTIFY TARGET NODE
    if strcmp(strategy, 'random')
        % Pick a random node index from the current graph
        target_idx = randi(numnodes(G));
        
    elseif strcmp(strategy, 'targeted')
        % Calculate Centrality for current graph state
        if strcmp(metric_type, 'degree')
            % Sum of In-Degree + Out-Degree
            metric_val = indegree(G) + outdegree(G);
        elseif strcmp(metric_type, 'strength')
            % Sum of In-Strength + Out-Strength (Weighted)
            % Note: centrality function requires positive weights
            metric_val = centrality(G, 'instrength', 'Importance', G.Edges.Weight) + ...
                         centrality(G, 'outstrength', 'Importance', G.Edges.Weight);
        end
        
        % Find the node with the MAX metric (The Hub)
        [~, target_idx] = max(metric_val);
    end
    
    % B. REMOVE NODE
    % 'rmnode' is safer/faster than matrix manipulation for graph objects
    G = rmnode(G, target_idx);
    removed_count = removed_count + 1;
    
    % C. MEASURE FRAGMENTATION
    % We check the size of the Largest Weakly Connected Component
    if numnodes(G) > 0
        bins = conncomp(G, 'Type', 'weak'); 
        % Size of the largest bin
        lcc_size = max(histcounts(bins)); 
        giant_component_sizes(end+1) = lcc_size;
    else
        giant_component_sizes(end+1) = 0;
    end
    
    % Stop if network is fully destroyed (LCC < 2 nodes)
    if numnodes(G) < 2
        break; 
    end
    
    % Optional: Print progress every 10 steps to verify speed
    if mod(removed_count, 10) == 0
        fprintf('Removed %d nodes. Current LCC size: %d\n', removed_count, giant_component_sizes(end));
    end
end

% --- 4. PLOT RESULTS (Robustness Curve) ---
x_axis = (0:length(giant_component_sizes)-1) / N; % Fraction of nodes removed (0 to 1)
y_axis = giant_component_sizes / N;               % Relative size of Giant Component

figure;
plot(x_axis, y_axis, 'LineWidth', 2, 'Color', 'r');
xlabel('Fraction of Nodes Removed (f)');
ylabel('Relative Size of Giant Component (S)');
title(['Robustness Analysis: ', strategy, ' attack (', metric_type, ')']);
grid on;

% Add reference line for "collapse" (e.g., 50% connectivity)
yline(0.5, '--k', '50% Threshold');