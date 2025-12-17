function [outputArg1,outputArg2] = assortativity(ins,outs,AdjG)
n = length(ins);

A = sparse(AdjG);
[i,j] = find(A);   % archi esistenti

% --- Calcolo assortativity out-degree -> in-degree ---
num = sum(outs(i).*ins(j));
den = sum(0.5*(outs(i).^2 + ins(j).^2));
m = nnz(A);

r_out_in = (num/m - (sum(outs)*sum(ins)/m^2)) / (den/m - (sum(outs)*sum(ins)/m^2));

% converte in double se necessario
r_out_in = full(r_out_in);

fprintf('Assortativity (out-degree -> in-degree): %.4f\n', r_out_in);
% AdjG : adjacency matrix diretta (sparse consigliata)
% ins  : vettore in-degree
% outs : vettore out-degree
n = length(ins);

A = sparse(AdjG);
[i,j] = find(A);   % archi esistenti

% --- Calcolo assortativity in-degree -> out-degree ---
num = sum(ins(i).*outs(j));
den = sum(0.5*(ins(i).^2 + outs(j).^2));
m = nnz(A);

r_in_out = (num/m - (sum(ins)*sum(outs)/m^2)) / (den/m - (sum(ins)*sum(outs)/m^2));

% converte in double se necessario
r_in_out = full(r_in_out);

fprintf('Assortativity (in-degree -> out-degree): %.4f\n', r_in_out);

% % ins  : vettore in-degree
%IN IN ASSORT
n = length(ins);

A = sparse(AdjG);
[i,j] = find(A);   % archi esistenti

% --- Calcolo assortativity solo sull'in-degree ---
% grado del nodo sorgente e destinazione considerato in-degree
num = sum(ins(i).*ins(j));
den = sum(0.5*(ins(i).^2 + ins(j).^2));
m = nnz(A);

r_in = (num/m - (sum(ins)*sum(ins)/m^2)) / (den/m - (sum(ins)*sum(ins)/m^2));
r_in = full(r_in);   % converte in double
fprintf('Assortativity (in-degree): %.4f\n', r_in);

end