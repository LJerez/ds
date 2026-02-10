function newRob(G)
% ROBUSTNESS Assess network resilience by removing important links.
%   ROBUSTNESS(G) takes a MATLAB graph or digraph object G and performs
%   two targeted attacks:
%     1. Removing links based on PageRank centrality (Node proxy).
%     2. Removing links based on Betweenness centrality (Node proxy).
%
%   It plots the size of the Largest Connected Component (LCC) against
%   the fraction of links removed.

    % Check if G is a valid graph object
    if ~isa(G, 'graph') && ~isa(G, 'digraph')
        error('Input must be a MATLAB graph or digraph object.');
    end
    
    % --- 1. Calculate Centralities ---
    fprintf('Calculating network centralities...\n');
    
    % PageRank (Node Importance)
    pr_nodes = centrality(G, 'pagerank');
    
    % Betweenness (Node Importance)
    bt_nodes = centrality(G, 'betweenness');
    
    % --- 2. Map Node Metrics to Edge Scores ---
    % We define "Link Importance" as the product of the centralities 
    % of the two nodes the link connects.
    
    edges = G.Edges;
    num_edges = height(edges);
    src = edges.EndNodes(:, 1); % Source nodes
    tgt = edges.EndNodes(:, 2); % Target nodes
    
    % Get indices for source and target
    if isa(src, 'cell') % If nodes are named strings
        src_idx = findnode(G, src);
        tgt_idx = findnode(G, tgt);
    else
        src_idx = src;
        tgt_idx = tgt;
    end
    
    % Calculate Edge Scores
    edge_score_pr = pr_nodes(src_idx) .* pr_nodes(tgt_idx);
    edge_score_bt = bt_nodes(src_idx) .* bt_nodes(tgt_idx);
    
    % --- 3. Simulation: Attack the Network ---
    fprintf('Simulating PageRank attack...\n');
    [frac_pr, lcc_pr] = perform_attack(G, edge_score_pr);
    
    fprintf('Simulating Betweenness attack...\n');
    [frac_bt, lcc_bt] = perform_attack(G, edge_score_bt);
    
    % --- 4. Plot Results ---
    figure;
    hold on;
    grid on;
    
    % Plot PageRank Attack
    plot(frac_pr, lcc_pr, 'LineWidth', 2, 'DisplayName', 'PageRank Attack');
    
    % Plot Betweenness Attack
    plot(frac_bt, lcc_bt, 'LineWidth', 2, 'DisplayName', 'Betweenness Attack');
    
    % Formatting
    xlabel('Fraction of Links Removed (f)');
    ylabel('Size of Largest Cluster (S)');
    title('Network Robustness: Targeted Link Removal');
    legend('show');
    ylim([0 1.05]);
    
    hold off;
end

function [fractions, lcc_norm] = perform_attack(G, scores)
    % Helper function to iteratively remove edges and measure LCC
    
    % Sort edges by importance (High to Low)
    [~, sort_idx] = sort(scores, 'descend');
    
    % Parameters
    total_edges = numedges(G);
    n = numnodes(G);
    
    % Determine step size (remove 1% of edges at a time to be faster)
    step = max(1, floor(total_edges * 0.01)); 
    remove_steps = 0:step:total_edges;
    
    % Pre-allocate results
    lcc_norm = zeros(length(remove_steps), 1);
    fractions = zeros(length(remove_steps), 1);
    
    % Initial State
    current_G = G;
    
    % Loop through removal steps
    for i = 1:length(remove_steps)
        num_to_remove = remove_steps(i);
        
        if num_to_remove > 0
            % Identify edges to remove (top N most important)
            edges_to_remove = sort_idx(1:num_to_remove);
            
            % Create a temp graph with edges removed
            % (rmedge by index is faster than by name)
            temp_G = rmedge(G, edges_to_remove);
        else
            temp_G = G;
        end
        
        % Calculate Size of Largest Connected Component (LCC)
        [bins, binsizes] = conncomp(temp_G);
        max_comp_size = max(binsizes);
        
        % Store normalized results (Fraction of original network size)
        lcc_norm(i) = max_comp_size / n;
        fractions(i) = num_to_remove / total_edges;
    end
end