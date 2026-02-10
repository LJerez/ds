function degreeClusteringScatterPlot(degrees, clusteringCoeffs)
    % Ensure input data is double precision
    degrees = double(degrees);
    clusteringCoeffs = double(clusteringCoeffs);
    fprintf('Number of nodes: %d\n', length(full(degrees)));
    fprintf('Average degree: %.2f\n', mean(full(degrees)));
    fprintf('Average clustering coefficient: %.4f\n', mean(full(clusteringCoeffs)));
    % Create the figure with a specific size
    fig = figure('Position', [100, 100, 800, 600]);
    
    % Create the scatter plot
    scatter(degrees, clusteringCoeffs, 50, 'filled', 'MarkerFaceAlpha', 0.7, ...
            'MarkerEdgeColor', 'k', 'LineWidth', 0.5);
    
    % Set log scales for both axes
    set(gca, 'XScale', 'log', 'YScale', 'log');
    
    % Customize the axes
    ax = gca;
    ax.FontSize = 12;
    ax.LineWidth = 1.5;
    ax.Box = 'on';
    grid on;
    
    % Set labels and title
    xlabel('Node Degree', 'FontSize', 14, 'FontWeight', 'bold');
    ylabel('Clustering Coefficient', 'FontSize', 14, 'FontWeight', 'bold');
    title('Node Degree vs Clustering Coefficient', 'FontSize', 16, 'FontWeight', 'bold');
    
    
    % Apply color to scatter points
    colordata = log10(degrees);
     
    % Adjust color limits to match data
    caxis([min(colordata), max(colordata)]);
    
    % Add a trend line
    tolgo=union(find(degrees==0),find(clusteringCoeffs==0));
    degrees(tolgo)=[];
    clusteringCoeffs(tolgo)=[];
    hold on;
    logx = log10(full(degrees));
    logy = log10(full(clusteringCoeffs));
    coeffs = polyfit(logx, logy, 1);
    x_trend = logspace(double(min(logx)), double(max(logx)), 100);
    y_trend = 10.^(coeffs(1) * log10(x_trend) + coeffs(2));
    loglog(x_trend, y_trend, 'r--', 'LineWidth', 2);
    
    % Add text for trend line equation
    equation = sprintf('y = %.2fx + %.2f', coeffs(1), coeffs(2));
    text(0.05, 0.95, equation, 'Units', 'normalized', 'FontSize', 12, ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', ...
         'BackgroundColor', 'w', 'EdgeColor', 'k', 'Margin', 3);
    
    % Adjust the layout
    set(fig, 'Color', 'w');  % Set white background
    
    
    hold off;
    saveas(gcf, 'nomefile.png')

    % Print some basic statistics
    fprintf('Number of nodes: %d\n', length(full(degrees)));
    fprintf('Average degree: %.2f\n', mean(full(degrees)));
    fprintf('Average clustering coefficient: %.4f\n', mean(full(clusteringCoeffs)));
end