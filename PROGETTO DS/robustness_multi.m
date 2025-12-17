function [x_axis, y_axis] = robustness_multi(G, strategy, metric_type)
% ROBUSTNESS_MULTI Analizza la robustezza di un grafo con diverse strategie
%
% INPUT:
%   G           - grafo MATLAB (graph o digraph)
%   strategy    - 'targeted', 'targeted_IN_only', 'targeted_OUT_only', 'random'
%   metric_type - 'pagerank' (attualmente unico supportato)
%
% OUTPUT:
%   x_axis      - frazione di nodi rimossi
%   y_axis      - dimensione relativa della Giant Component
% 
% N = numnodes(G);
% giant_component_sizes = [];
% removed_count = 0;
% giant_component_sizes(end+1) = numnodes(G);
% 
% fprintf('Starting simulation (%s) with %d nodes...\n', strategy, N);
% 
% % Spearman correlation iniziale (solo per info)
% A0 = adjacency(G, 'weighted');
% PR0 = centrality(G, 'pagerank', 'Importance', G.Edges.Weight);
% 
% switch strategy
%     case 'targeted_IN_only'
%         ins = sum(A0, 1)';  % in-degree
%         [rho_in, p_in] = corr(ins(:), PR0(:), 'type', 'Spearman');
%         fprintf('Spearman correlation (in-degree vs PageRank): rho = %.4f, p = %.4f\n', rho_in, p_in);
%     case 'targeted_OUT_only'
%         outs = sum(A0, 2);  % out-degree
%         [rho_out, p_out] = corr(outs(:), PR0(:), 'type', 'Spearman');
%         fprintf('Spearman correlation (out-degree vs PageRank): rho = %.4f, p = %.4f\n', rho_out, p_out);
% end
% 
% % =============================
% %   MAIN SIMULATION LOOP
% % =============================
% while numnodes(G) > 1
%     % Compute metrics dynamically
%     A = adjacency(G, 'weighted');
%     PR = centrality(G, 'pagerank', 'Importance', G.Edges.Weight);
%     PR = PR(:);
% 
%     switch strategy
%         case 'random'
%             target_idx = randi(numnodes(G));
%         case 'targeted'
%             [~, target_idx] = max(PR);
%         case 'targeted_IN_only'
%             ins = sum(A, 1)'; % in-degree
%             in_nodes = find(ins > 0);
%             if isempty(in_nodes)
%                 [~, target_idx] = max(PR);
%             else
%                 [~, idx] = max(PR(in_nodes));
%                 target_idx = in_nodes(idx);
%             end
%         case 'targeted_OUT_only'
%             outs = sum(A, 2); % out-degree
%             out_nodes = find(outs > 0);
%             if isempty(out_nodes)
%                 [~, target_idx] = max(PR);
%             else
%                 [~, idx] = max(PR(out_nodes));
%                 target_idx = out_nodes(idx);
%             end
%         otherwise
%             error('Strategy not recognized');
%     end
% 
%     % Remove node
%     G = rmnode(G, target_idx);
%     removed_count = removed_count + 1;
% 
%     % Measure fragmentation
%     if numnodes(G) > 0
%         bins = conncomp(G, 'Type', 'weak');
%         lcc_size = max(histcounts(bins));
%         giant_component_sizes(end+1) = lcc_size;
%     else
%         giant_component_sizes(end+1) = 0;
%     end
% 
%     if numnodes(G) < 2
%         break;
%     end
% end
% 
% x_axis = (0:length(giant_component_sizes)-1) / N;
% y_axis = giant_component_sizes / N;
% ROBUSTNESS Analizza la robustezza di un grafo con diverse strategie
%
% INPUT:
%   G           - grafo MATLAB (graph o digraph)
%   strategy    - 'targeted', 'targeted_IN_only', 'targeted_OUT_only', 'random'
%   metric_type - 'pagerank' o 'degree'
%
% OUTPUT:
%   x_axis      - frazione di nodi rimossi
%   y_axis      - dimensione relativa della Giant Component

N = numnodes(G);
giant_component_sizes = [];
removed_count = 0;
giant_component_sizes(end+1) = numnodes(G);

fprintf('Starting simulation (%s, %s) with %d nodes...\n', strategy, metric_type, N);

% Spearman correlation iniziale (solo per PageRank IN/OUT)
if strcmp(metric_type, 'pagerank')
    A0 = adjacency(G, 'weighted');
    PR0 = centrality(G, 'pagerank', 'Importance', G.Edges.Weight);
    switch strategy
        case 'targeted_IN_only'
            ins = sum(A0, 1)';  
            [rho_in, p_in] = corr(ins(:), PR0(:), 'type', 'Spearman');
            fprintf('Spearman correlation (in-degree vs PageRank): rho = %.4f, p = %.4f\n', rho_in, p_in);
        case 'targeted_OUT_only'
            outs = sum(A0, 2);  
            [rho_out, p_out] = corr(outs(:), PR0(:), 'type', 'Spearman');
            fprintf('Spearman correlation (out-degree vs PageRank): rho = %.4f, p = %.4f\n', rho_out, p_out);
    end
end

% =============================
%   MAIN SIMULATION LOOP
% =============================
while numnodes(G) > 1
    % Compute dynamic metrics
    switch metric_type
        case 'pagerank'
            PR = centrality(G, 'pagerank', 'Importance', G.Edges.Weight);
            PR = PR(:);
        case 'degree'
            PR = indegree(G) + outdegree(G);
        otherwise
            error('Metric type not recognized');
    end

    % Select target node
    switch strategy
        case 'random'
            target_idx = randi(numnodes(G));
        case 'targeted'
            [~, target_idx] = max(PR);
        case 'targeted_IN_only'
            ins = sum(adjacency(G, 'weighted'), 1)'; 
            in_nodes = find(ins > 0);
            if isempty(in_nodes)
                [~, target_idx] = max(PR);
            else
                [~, idx] = max(PR(in_nodes));
                target_idx = in_nodes(idx);
            end
        case 'targeted_OUT_only'
            outs = sum(adjacency(G, 'weighted'), 2); 
            out_nodes = find(outs > 0);
            if isempty(out_nodes)
                [~, target_idx] = max(PR);
            else
                [~, idx] = max(PR(out_nodes));
                target_idx = out_nodes(idx);
            end
        otherwise
            error('Strategy not recognized');
    end

    % Remove node
    G = rmnode(G, target_idx);
    removed_count = removed_count + 1;

    % Measure fragmentation
    if numnodes(G) > 0
        bins = conncomp(G, 'Type', 'weak');
        lcc_size = max(histcounts(bins));
        giant_component_sizes(end+1) = lcc_size;
    else
        giant_component_sizes(end+1) = 0;
    end

    if numnodes(G) < 2
        break;
    end
end

% =============================
%   RETURN CURVE DATA
% =============================
x_axis = (0:length(giant_component_sizes)-1) / N;
y_axis = giant_component_sizes / N;


end
