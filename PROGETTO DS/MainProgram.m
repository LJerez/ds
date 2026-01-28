clc;clearvars;close all
%% add path
addpath('C:\Users\jinho\OneDrive\Desktop\Datascience\2019_03_03_BCT')

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
% X FAR PARTIRE IL BOWTIE
%[SCC, IN, OUT, tubes, tendrils] = BowtieFunc(AdjG, Nodi,yearStr,yearFigDir);
%PER CENTRALITA E PLOT PAGE RANK
%[PR, PRsorted, idx] = PlotPageRank(G, Nodi);
%DEGREE EVALUATION
%PlotDegreeDistribution(ins, outs,yearStr,yearFigDir);
%PLOT LOG LOG DIST
%PlotLogLogDist(AdjG);
%  CC=clustering_coef_wd(AdjG);
% CC(~isfinite(CC)) = 0;
% C_totale = mean(CC)
% degreeClusteringScatterPlot(stren, CC);
%Assortativity
%assortativity(ins,outs,AdjG)
%%%%PAGERANK IN DEG VS OUT DEG
% strategies = {'targeted', 'targeted_IN_only', 'targeted_OUT_only', 'targeted'};
% metrics    = {'pagerank', 'pagerank', 'pagerank', 'degree'};
% colors     = {'r', 'b', 'g', 'm'};
% labels     = {'PageRank', 'PageRank IN-only', 'PageRank OUT-only', 'Degree'};
% figure; hold on; grid on;
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


%RANDOM NETWORK ATTACK
%randAttack(AdjG,100,G);
end
