
function [x_axis, y_axis, all_curves] = randAttack(AdjG, num_iterations,G)
% RANDATTACK Random failure robustness analysis via Monte Carlo
%
% INPUT:
%   AdjG            - adjacency matrix
%   num_iterations  - number of Monte Carlo runs (e.g. 100)
%   doPlot          - true/false to generate plot
%
% OUTPUT:
%   x_axis      - fraction of nodes removed
%   y_axis      - mean relative giant component size
%   all_curves  - raw curves for each iteration
    doPlot=true;

    % Parameters
    N = size(AdjG, 1);
all_curves = zeros(num_iterations, N); % Store results of each run

fprintf('Starting Monte Carlo simulation (%d iterations)...\n', num_iterations);

% --- 2. MONTE CARLO LOOP ---
for iter = 1:num_iterations

    % Re-create the graph fresh for every iteration

    % Track size for this specific run
    % We pre-allocate for speed. Index 1 = 0 removed. Index N = N-1 removed.
    run_curve = zeros(1, N); 

    % Initial size (0 nodes removed)
    run_curve(1) = numnodes(G);

    % Removal Loop
for step = 2:N

    if numnodes(G) == 0
        run_curve(step:end) = 0;
        break;
    end

    target_idx = randi(numnodes(G));  
    G = rmnode(G, target_idx);
        % --- C. MEASURE FRAGMENTATION ---
        if numnodes(G) > 0
            % Measure Largest Weakly Connected Component
            bins = conncomp(G, 'Type', 'weak');
            largest_comp_size = max(histcounts(bins));
            run_curve(step) = largest_comp_size;
        else
            run_curve(step) = 0;
        end
    end

    % Store this run's curve in the main matrix
    all_curves(iter, :) = run_curve;

    % Optional: Print progress
    if mod(iter, 10) == 0
        fprintf('Completed iteration %d/%d\n', iter, num_iterations);
    end
end

% --- 3. AGGREGATE RESULTS ---
% Calculate the MEAN curve across all 50 runs
avg_curve = mean(all_curves, 1);
% Normalized Y-axis (Relative Size S)
y_axis = avg_curve / N; 
% Normalized X-axis (Fraction f removed)
x_axis = (0:N-1) / N;
figure; hold on;

for i = 1:num_iterations
    plot(x_axis, all_curves(i, :) / N, 'Color', [0 0 0]); 
end

xlabel('Fraction of Nodes Removed (f)');
ylabel('Relative Size of Giant Component (S)');
title(sprintf('Robustness Analysis: Random Failure (%d runs)', num_iterations));
grid off;
xlim([0 1]);
ylim([0 1]);

% Threshold line (rimane)
yline(0.5, '--k', '50% threshold');


end
