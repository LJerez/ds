clc;clearvars;close all
%% add path
addpath('C:\Users\jinho\OneDrive\Desktop\Datascience\2019_03_03_BCT')

%% param
year=[2024];

%% example 
IN_Strength = cell(size(year));
%% load
for i = 1:length(year)
    filename = ['GCC_Bank',num2str(year(i)),'.mat'];
    load(filename);
    G = digraph(AdjG')
    %  compute instrength
    [ins,outs, stren] = strengths_dir(AdjG);
% X FAR PARTIRE IL BOWTIE
%[SCC, IN, OUT, tubes, tendrils] = BowtieFunc(AdjG, Nodi);
%PER CENTRALITA E PLOT PAGE RANK
%[PR, PRsorted, idx] = PlotPageRank(G, Nodi);
%DEGREE EVALUATION
%PlotDegreeDistribution(ins, outs);
%PLOT LOG LOG DIST
%PlotLogLogDist(AdjG);
CC=clustering_coef_wd(AdjG);
CC(~isfinite(CC)) = 0;
C_totale = mean(CC)
degreeClusteringScatterPlot(stren, CC);
end
