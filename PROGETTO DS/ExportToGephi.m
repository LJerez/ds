function ExportToGephi(G, Nodi, PR)
    % 1. Create and Export the Edge List
    Edges = G.Edges;
    % Rename table variables for Gephi compatibility (Source, Target)
    EdgeTable = table(Edges.EndNodes(:,1), Edges.EndNodes(:,2), ...
        'VariableNames', {'Source', 'Target'});
    writetable(EdgeTable, 'Network_Edges.csv');

    % 2. Create and Export the Node List (with PageRank)
    % We match the Node ID with the Name and the PR score
    NodeTable = table((1:numel(PR))', Nodi.Name, PR, ...
        'VariableNames', {'Id', 'Label', 'PageRank'});
    writetable(NodeTable, 'Network_Nodes.csv');
    
    fprintf('Export complete!\n1. Network_Edges.csv\n2. Network_Nodes.csv\n');
end