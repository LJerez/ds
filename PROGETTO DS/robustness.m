function [x_axis, y_axis] = robustness(G, strategy, metric_type)
    % Capture initial size once and for all
    initial_N = numnodes(G);
    
    % Initialize storage
    giant_component_sizes = zeros(initial_N + 1, 1);
    
    % Initial State (0 nodes removed)
    if initial_N > 0
        bins = conncomp(G, 'Type', 'weak');
        [counts, ~] = groupcounts(bins');
        giant_component_sizes(1) = max(counts);
    else
        giant_component_sizes(1) = 0;
    end
    
    fprintf('Starting simulation with %d nodes...\n', initial_N);

    removed_count = 0;
    while numnodes(G) > 0
        % --- A. SELECT TARGET NODE ---
        if strcmp(strategy, 'random')
            target_idx = randi(numnodes(G));
        else 
            % Re-calculate centralities on the REMAINING graph
            switch metric_type
                case 'betweenness'
                    metric_val = centrality(G, 'betweenness');
                case 'pagerank'
                    if ismember('Weight', G.Edges.Properties.VariableNames)
                        metric_val = centrality(G, 'pagerank', 'Importance', G.Edges.Weight);
                    else
                        metric_val = centrality(G, 'pagerank');
                    end
                case 'degree'
                    metric_val = centrality(G, 'degree');
                otherwise
                    error('Unknown metric type.');
            end
            [~, target_idx] = max(metric_val);
        end

        % --- B. REMOVE NODE ---
        G = rmnode(G, target_idx);
        removed_count = removed_count + 1;

        % --- C. MEASURE FRAGMENTATION ---
        if numnodes(G) > 0
            bins = conncomp(G, 'Type', 'weak');
            [counts, ~] = groupcounts(bins');
            giant_component_sizes(removed_count + 1) = max(counts);
        else
            giant_component_sizes(removed_count + 1) = 0;
        end

        % Debug print
        if mod(removed_count, 50) == 0
            fprintf('Removed %d nodes. LCC Size: %d\n', removed_count, giant_component_sizes(removed_count + 1));
        end
    end

    % --- FINAL CALCULATION (Strictly Monotonic) ---
    % Use initial_N as a constant denominator
    x_axis = (0:removed_count) / initial_N;
    y_axis = giant_component_sizes(1:removed_count+1) / initial_N;

    % Visualization code...
    plot(x_axis, y_axis, 'LineWidth', 2, 'Color', 'r');
xlabel('Fraction of Nodes Removed (f)');
ylabel('Relative Size of Giant Component (S)');
title(['Robustness: ', strategy, ' attack (', metric_type, ')']);
grid on;
yline(0.5, '--k', '50% Threshold');
end
% 
% function [x_axis, y_axis] = robustness(G, strategy, metric_type)
% N = numnodes(G);
% 
% % Initialize storage
% giant_component_sizes = [];
% removed_count = 0;
% initial_N = numnodes(G);
% % Initial LCC size
% giant_component_sizes(end+1) = numnodes(G);
% 
% fprintf('Starting simulation with %d nodes...\n', N);
% 
% % =============================
% %   MAIN SIMULATION LOOP
% % =============================
% while numnodes(G) > 1
%     % --- A. SELECT TARGET NODE ---
%     % --- A. SELECT TARGET NODE ---
%     if strcmp(strategy, 'random')
%         target_idx = randi(numnodes(G));
%     else 
%         % TARGETED ATTACKS
%         % We choose the metric based on the 'metric_type' input
%         switch metric_type
%             case 'betweenness'
%                 % Calculate Betweenness Centrality
%                 metric_val = centrality(G, 'betweenness');
% 
%             case 'pagerank'
%                 % Calculate PageRank (using Weights if available)
%                 if ismember('Weight', G.Edges.Properties.VariableNames)
%                     metric_val = centrality(G, 'pagerank', 'Importance', G.Edges.Weight);
%                 else
%                     metric_val = centrality(G, 'pagerank');
%                 end
% 
%             case 'degree'
%                 % Calculate Degree Centrality
%                 metric_val = centrality(G, 'degree');
% 
%             otherwise
%                 error('Unknown metric type. Use: betweenness, pagerank, or degree.');
%         end
% 
%         % Find node with the highest metric value
%         [~, target_idx] = max(metric_val);
%     end
% 
%     % --- B. REMOVE NODE ---
%     G = rmnode(G, target_idx);
%     removed_count = removed_count + 1;
% 
%     % --- C. MEASURE FRAGMENTATION ---
%     if numnodes(G) > 0
%         bins = conncomp(G, 'Type', 'weak');
%         lcc_size = max(histcounts(bins));
%         giant_component_sizes(end+1) = lcc_size;
%     else
%         giant_component_sizes(end+1) = 0;
%     end
% 
%     % Stop when the graph is essentially dead
%     if numnodes(G) < 2
%         break;
%     end
% 
%     % Debug print
%     if mod(removed_count, 10) == 0
%         fprintf('Removed %d nodes. LCC: %d\n', removed_count, giant_component_sizes(end));
%     end
% end
% 
% % ROBUSTNESS PLOT
% x_axis = (0:length(giant_component_sizes)-1) / N;
% y_axis = giant_component_sizes / initial_N;
% 
% figure;
% plot(x_axis, y_axis, 'LineWidth', 2, 'Color', 'r');
% xlabel('Fraction of Nodes Removed (f)');
% ylabel('Relative Size of Giant Component (S)');
% title(['Robustness Analysis: ', strategy, ' attack (', metric_type, ')']);
% grid on;
% yline(0.5, '--k', '50% Threshold');
% 
% 
% % N = numnodes(G);
% % 
% % % Initialize storage
% % giant_component_sizes = [];
% % removed_count = 0;
% % 
% % % Initial LCC size
% % giant_component_sizes(end+1) = numnodes(G);
% % 
% % fprintf('Starting simulation with %d nodes...\n', N);
% % 
% % % =============================
% % %   MAIN SIMULATION LOOP
% % % =============================
% % while numnodes(G) > 1
% %     % --- A. SELECT TARGET NODE ---
% %     if strcmp(strategy, 'random')
% %         target_idx = randi(numnodes(G));
% %     else    % TARGETED (assume pagerank)
% %         metric_val = centrality(G, 'pagerank', 'Importance', G.Edges.Weight);
% %         [~, target_idx] = max(metric_val);
% %     end
% % 
% %     % --- B. REMOVE NODE ---
% %     G = rmnode(G, target_idx);
% %     removed_count = removed_count + 1;
% % 
% %     % --- C. MEASURE FRAGMENTATION ---
% %     if numnodes(G) > 0
% %         bins = conncomp(G, 'Type', 'weak');
% %         lcc_size = max(histcounts(bins));
% %         giant_component_sizes(end+1) = lcc_size;
% %     else
% %         giant_component_sizes(end+1) = 0;
% %     end
% % 
% %     % Stop when the graph is essentially dead
% %     if numnodes(G) < 2
% %         break;
% %     end
% % 
% %     % Debug print
% %     if mod(removed_count, 10) == 0
% %         fprintf('Removed %d nodes. LCC: %d\n', removed_count, giant_component_sizes(end));
% %     end
% % end
% % 
% % % ROBUSTNESS PLOT
% % x_axis = (0:length(giant_component_sizes)-1) / N;
% % y_axis = giant_component_sizes / N;
% % 
% % figure;
% % plot(x_axis, y_axis, 'LineWidth', 2, 'Color', 'r');
% % xlabel('Fraction of Nodes Removed (f)');
% % ylabel('Relative Size of Giant Component (S)');
% % title(['Robustness Analysis: ', strategy, ' attack (', metric_type, ')']);
% % grid on;
% % yline(0.5, '--k', '50% Threshold');
% 
% %NO CORRECT TARGETED
% % strategy = 'targeted';
% % metric_type = 'pagerank';
% % 
% % % --- Chiama la funzione robustness ---
% % [x, y] = robustness(G, strategy, metric_type);
% % 
% % [x1, y1] = robustness_multi(G, 'targeted', 'pagerank');
% % [x2, y2] = robustness_multi(G, 'targeted_IN_only', 'pagerank');
% % [x3, y3] = robustness_multi(G, 'targeted_OUT_only', 'pagerank');
% % 
% % % --- Plot nello stesso grafico ---
% % figure;
% % plot(x1, y1, 'r', 'LineWidth', 2); hold on;
% % plot(x2, y2, 'b', 'LineWidth', 2);
% % plot(x3, y3, 'g', 'LineWidth', 2);
% % xlabel('Fraction of Nodes Removed (f)');
% % ylabel('Relative Size of Giant Component (S)');
% % title('Robustness Analysis: PageRank vs IN/OUT-degree PageRank');
% % grid on;
% % yline(0.5, '--k', '50% Threshold');
% % legend('Targeted PageRank', 'Targeted IN-degree PageRank', 'Targeted OUT-degree PageRank');
% 
% 
% end
