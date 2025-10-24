clc; clear; close all;
%IMPORTING DATASET ~
banche = readtable ("Export 23_10_2025 09_40.xlsx",Sheet=2);
%VARIABLE CREATION
nomicolonne = banche.Properties.VariableNames;
quanteBanche=0;
primadata = banche.LastDealStatusDate(1);
ultimadata = banche.LastDealStatusDate(1);
%FUNZIONE CHE CONTA IL NUMERO DI OPERAZIONI UNICHE
% for i=1:height(banche)
% 
%     if isempty(banche.DealNumber{i}) == false
%         quanteBanche=quanteBanche+1;
%     end
% 
% end
% quanteBanche


for i=1:height(banche)
    datafusione = banche.LastDealStatusDate(i);
    if isnat(datafusione) == 0
        if datafusione < primadata
            primadata = datafusione;
        elseif datafusione > ultimadata
            ultimadata = datafusione;
        end
    end

end
primadata
ultimadata