function PlotDegreeDistribution(ins, outs)
% PLOTDEGREEDISTRIBUTIONS - Plotta distribuzioni log-log di in-degree e out-degree.
%
% Input:
%   ins  - vettore degli in-strength / in-degree
%   outs - vettore degli out-strength / out-degree

    %% --- DISTRIBUZIONE IN-DEGREE ---
    [deg_in, ~, idx_in] = unique(ins);
    counts_in = accumarray(idx_in, 1);

    figure;
    loglog(deg_in, counts_in, 'bo-', 'LineWidth', 1.5, 'MarkerSize', 6);
    xlabel('In-degree k [log]');
    ylabel('N. nodi con degree k [log]');
    title('Distribuzione log-log degli In-degree');
    grid on;
    % saveas(gcf, fullfile('figures', 'in.png'));

    %% --- DISTRIBUZIONE OUT-DEGREE ---
    [deg_out, ~, idx_out] = unique(outs);
    counts_out = accumarray(idx_out, 1);

    figure;
    loglog(deg_out, counts_out, 'ro-', 'LineWidth', 1.5, 'MarkerSize', 6);
    xlabel('Out-degree k [log]');
    ylabel('N. nodi con degree k [log]');
    title('Distribuzione log-log degli Out-degree');
    grid on;
    % saveas(gcf, fullfile('figures', 'out.png'));

end
