function   r = assort(CIJ)
%ASSORTATIVITY      Assortativity coefficient
%
%   r = assortativity(CIJ,flag);
%
%   The assortativity coefficient is a correlation coefficient between the 
%   degrees of all nodes on two opposite ends of a link. A positive 
%   assortativity coefficient indicates that nodes tend to link to other 
%   nodes with the same or similar degree.
%
%   Inputs:     CIJ,        binary directed/undirected connection matrix
%               flag,       1 = directed graph; 0 = non-directed graph
%
%   Outputs:    r,          assortativity
%
%   Notes: The function accepts weighted networks, but all connection
%   weights are ignored. The main diagonal should be empty.
%
%   Reference:  Newman (2002) Phys Rev Lett 89:208701.
%
%
%   Olaf Sporns, Indiana University, 2007/2008
%   Vassilis Tsiaras, University of Crete, 2009
[id,od,deg] = degrees_dir(CIJ);
[i,j] = find(CIJ>0);
K = length(i);
for k=1:K
    degi(k) = deg(i(k));
    degj(k) = deg(j(k));
end;

% compute assortativity
r = (sum(degi.*degj)/K - (sum(0.5*(degi+degj))/K)^2)/(sum(0.5*(degi.^2+degj.^2))/K - (sum(0.5*(degi+degj))/K)^2);
% function [r_out_in, r_in_out, r_in_in, r_out_out] = assortativity(AdjG, ins, outs)
%     % ASSORTATIVITY - Calcola assortatività da vettori di grado
% 
%     % 1. Assicura che i vettori siano colonna
%     ins = ins(:);
%     outs = outs(:);
% 
%     % 2. Trova gli indici degli archi esistenti
%     % Usiamo sparse(AdjG) per sicurezza, ma find lavora bene anche su full
%     [u, v] = find(sparse(AdjG));
% 
%     % 3. Mappa i gradi sugli archi (sorgente -> destinazione)
%     % u = indice nodo partenza, v = indice nodo arrivo
% 
%     src_out = outs(u);  % Grado Out della sorgente
%     src_in  = ins(u);   % Grado In della sorgente
% 
%     tgt_out = outs(v);  % Grado Out della destinazione
%     tgt_in  = ins(v);   % Grado In della destinazione
% 
%     % A. Out -> In (Standard)
%     r_out_in = full(corr(src_out, tgt_in));
% 
%     % B. In -> Out
%     r_in_out = full(corr(src_in, tgt_out));
% 
%     % C. In -> In
%     r_in_in = full(corr(src_in, tgt_in));
% 
%     % D. Out -> Out
%     r_out_out = full(corr(src_out, tgt_out));
% 
%     % --- Stampa Risultati ---
%     fprintf('--- Assortativity (Pearson) ---\n');
%     fprintf('Out -> In (Standard): %.4f\n', r_out_in);
%     fprintf('In  -> Out          : %.4f\n', r_in_out);
%     fprintf('In  -> In           : %.4f\n', r_in_in);
%     fprintf('Out -> Out          : %.4f\n', r_out_out);
% end
% % function [outputArg1,outputArg2] = assortativity(ins,outs,AdjG)
% % n = length(ins);
% % 
% % A = sparse(AdjG);
% % [i,j] = find(A);   % archi esistenti
% % 
% % % --- Calcolo assortativity out-degree -> in-degree ---
% % num = sum(outs(i).*ins(j));
% % den = sum(0.5*(outs(i).^2 + ins(j).^2));
% % m = nnz(A);
% % 
% % r_out_in = (num/m - (sum(outs)*sum(ins)/m^2)) / (den/m - (sum(outs)*sum(ins)/m^2));
% % 
% % % converte in double se necessario
% % r_out_in = full(r_out_in);
% % 
% % fprintf('Assortativity (out-degree -> in-degree): %.4f\n', r_out_in);
% % % AdjG : adjacency matrix diretta (sparse consigliata)
% % % ins  : vettore in-degree
% % % outs : vettore out-degree
% % n = length(ins);
% % 
% % A = sparse(AdjG);
% % [i,j] = find(A);   % archi esistenti
% % 
% % % --- Calcolo assortativity in-degree -> out-degree ---
% % num = sum(ins(i).*outs(j));
% % den = sum(0.5*(ins(i).^2 + outs(j).^2));
% % m = nnz(A);
% % 
% % r_in_out = (num/m - (sum(ins)*sum(outs)/m^2)) / (den/m - (sum(ins)*sum(outs)/m^2));
% % 
% % % converte in double se necessario
% % r_in_out = full(r_in_out);
% % 
% % fprintf('Assortativity (in-degree -> out-degree): %.4f\n', r_in_out);
% % 
% % % % ins  : vettore in-degree
% % %IN IN ASSORT
% % n = length(ins);
% % 
% % A = sparse(AdjG);
% % [i,j] = find(A);   % archi esistenti
% % 
% % % --- Calcolo assortativity solo sull'in-degree ---
% % % grado del nodo sorgente e destinazione considerato in-degree
% % num = sum(ins(i).*ins(j));
% % den = sum(0.5*(ins(i).^2 + ins(j).^2));
% % m = nnz(A);
% % 
% % r_in = (num/m - (sum(ins)*sum(ins)/m^2)) / (den/m - (sum(ins)*sum(ins)/m^2));
% % r_in = full(r_in);   % converte in double
% % fprintf('Assortativity (in-degree): %.4f\n', r_in);
% % 
% % end