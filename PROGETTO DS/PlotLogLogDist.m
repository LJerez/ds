function PlotLogLogDegree(AdjG)
d = full(sum(AdjG~=0, 2)); 

% 2. Trova i gradi unici e le loro frequenze
[links, ~, idx] = unique(d(d>0)); 
nodes = accumarray(idx, 1);

% 3. Crea e stampa la tabella con Link, Numero Nodi e Percentuale
disp(table(links, nodes, (nodes/sum(nodes))*100, ...
    'VariableNames', {'Num_Links', 'Num_Nodes', 'Percent'}));
fprintf('Totale nodi: %d\n', sum(nodes));
    % --- Calcolo grado nodi ---
    degree_values = sum(AdjG ~= 0, 2);
    % Conteggio dei nodi per ciascun grado
    [unique_degrees, ~, idx] = unique(degree_values);
    counts = accumarray(idx, 1);
    % Rimuovi eventuali gradi zero
    valid = unique_degrees > 0;
    unique_degrees = unique_degrees(valid);
    counts = counts(valid);
    % --- Plot log-log ---
    figure;
    loglog(unique_degrees, counts, 'o', 'MarkerSize', 6, 'MarkerFaceColor', 'b', 'LineWidth', 1.5);
    xlabel('Number of links (Degree)');
    ylabel('Number of nodes (Frequency)');
    title('Degree distribution (log-log)');
    grid on;
%saveas(gcf, fullfile('figures', 'plot_diamantini.png')); % salva come PNG
end
