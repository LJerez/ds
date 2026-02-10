clc;clearvars;close all
%% add path
addpath('C:\Users\jinho\OneDrive\Desktop\Datascience\2019_03_03_BCT')
addpath('C:\Users\jinho\OneDrive\Desktop\Datascience')
%% param
year=[2024];
baseFigDir = fullfile(pwd, 'figures');
%% example 
IN_Strength = cell(size(year));
%% load
for i = 1:length(year)
    yearStr = num2str(year(i));  
    filename = ['GCC_Bank',yearStr,'.mat'];
    load(filename);
    yearFigDir = fullfile(baseFigDir, yearStr);
    % Create year-specific folder if it doesn't exist
    if ~exist(yearFigDir, 'dir')
        mkdir(yearFigDir);
    end
    G = digraph(AdjG');
    %  compute instrength
    [ins,outs, stren] = strengths_dir(AdjG);
% % 1. Calculate the Degree (unweighted)
% binaryAdj = AdjG ~= 0;
% inD = sum(binaryAdj, 1)'; 
% outD = sum(binaryAdj, 2);
% totalD = inD + outD;
% 
% % 2. Calculate Probability P(k)
% numNodes = size(AdjG, 1);
% [counts, degrees] = groupcounts(totalD);
% probabilities = counts / numNodes;
% 
% % 3. Create the Raw (Linear) Plot
% figure('Color', 'w');
% 
% % Option A: Stem plot (best for discrete distributions)
% stem(degrees, probabilities, 'filled', 'MarkerSize', 4, 'Color', [0 0.45 0.74]);
% 
% % Option B: Bar chart (uncomment if you prefer bars)
% % bar(degrees, probabilities, 'FaceColor', [0 0.45 0.74], 'EdgeColor', 'none');
% 
% grid on;
% xlabel('Degree (k)');
% ylabel('Probability P(k)');
% title('Degree Probability Distribution (Linear Scale)');
% 
% % Improve visual clarity
% set(gca, 'TickDir', 'out', 'Box', 'off');
% X FAR PARTIRE IL BOWTIE
%[SCC, IN, OUT, tubes, tendrils] = BowtieFunc(AdjG, Nodi,yearStr,yearFigDir);
%PER CENTRALITA E PLOT PAGE RANK
%[PR, PRsorted, idx] = PlotPageRank(G, Nodi,AdjG);
%DEGREE EVALUATION
%PlotDegreeDistribution(ins, outs,yearStr,yearFigDir);
%PLOT LOG LOG DIST
%PlotLogLogDist(AdjG);
 % CC=clustering_coef_wd(AdjG);
 % CC(~isfinite(CC)) = 0;
 % C_totale = mean(CC)
%  degreeClusteringScatterPlot(stren, CC);
% % %Assortativity%
%assort(AdjG)
%out-in DA QUA IN POI
% fprintf("out-in")
% r=assortativity_wei(AdjG,1);
% my_measure = @(A) assortativity_wei(A, 1); % create a handle to your specific function
% 
% % 2. Run the Z-score calculation (try 100 simulations first)
% [Z_val, mu, sigma] = calculate_assortativity_z(AdjG, r, my_measure, 100);
% 
% % 3. Interpret
% disp(['The Z-score is: ', num2str(Z_val)]);
% %%
% fprintf("in-out")
% 
% 
% r=assortativity_wei(AdjG,2);
% my_measure = @(A) assortativity_wei(A, 2); % create a handle to your specific function
% 
% % 2. Run the Z-score calculation (try 100 simulations first)
% [Z_val, mu, sigma] = calculate_assortativity_z(AdjG, r, my_measure, 100);
% 
% % 3. Interpret
% disp(['The Z-score is: ', num2str(Z_val)]);
% %%
% fprintf("out-out")
% 
% r=assortativity_wei(AdjG,3);
% my_measure = @(A) assortativity_wei(A, 3); % create a handle to your specific function
% 
% % 2. Run the Z-score calculation (try 100 simulations first)
% [Z_val, mu, sigma] = calculate_assortativity_z(AdjG, r, my_measure, 100);
% 
% % 3. Interpret
% disp(['The Z-score is: ', num2str(Z_val)]);
% %%
% fprintf("in-in")
% 
% 
% r=assortativity_wei(AdjG,4);
% my_measure = @(A) assortativity_wei(A, 4); % create a handle to your specific function
% 
% % 2. Run the Z-score calculation (try 100 simulations first)
% [Z_val, mu, sigma] = calculate_assortativity_z(AdjG, r, my_measure, 100);
% 
% % 3. Interpret
% disp(['The Z-score is: ', num2str(Z_val)]);
%assort(AdjG,ins,outs)
%%%%PAGERANK IN DEG VS OUT DEG
% strategies = {'targeted', 'targeted_IN_only', 'targeted_OUT_only', 'targeted'};
% metrics    = {'pagerank', 'pagerank', 'pagerank', 'degree'};
% colors     = {'r', 'b', 'g', 'm'};
% labels     = {'PageRank', 'PageRank IN-only', 'PageRank OUT-only', 'Degree'};
% figure; hold on; grid off;
% xlabel('Fraction of Nodes Removed (f)');
% ylabel('Relative Size of Giant Component (S)');
% title('Robustness Analysis: Multiple Targeting Strategies');
% for i = 1:length(strategies)
%     [x, y] = robustness_multi(G, strategies{i}, metrics{i});
%     plot(x, y, 'LineWidth', 2, 'Color', colors{i});
% end
% yline(0.5, '--k', '50% Threshold');
% legend(labels, 'Location', 'northeast');
% filename = ['comparison' + year];
% exportgraphics(gcf, fullfile(yearFigDir, [filename '.pdf']), 'ContentType', 'vector');
%newRob(G);
robustness(G,"targeted",'pagerank')
%RANDOM NETWORK ATTACK
%randAttack(AdjG,100,G);
end
