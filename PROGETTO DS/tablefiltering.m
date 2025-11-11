function [outtab] = tablefiltering(btab)
    btab = btab(:, {'Var1','CompanyNameLatinAlphabet','SUB_Name','SUB_Direct_'});
btab.Properties.VariableNames{'CompanyNameLatinAlphabet'} = 'FirmName';
btab.Properties.VariableNames{'SUB_Direct_'} = 'SubDir';
notnumval={};
for i = 2:height(btab)
    giatrovato=0;
    % Estrai il valore numerico da Var1
    if ~isempty(btab.SubDir{i}) && (btab.SubDir{i}(1)=='>' || btab.SubDir{i}(1)=='±' || btab.SubDir{i}(1)=='<')
        btab.SubDir{i}=btab.SubDir{i}(2:end);
    end
    conve = str2double(btab.SubDir{i});
    % vogliamo sapere i valori non comuni
    if isnan(conve)
        if isempty(notnumval)
            notnumval{end+1}=btab.SubDir{i};
        else
            for j=1:length(notnumval)
                if  isequal(btab.SubDir{i},notnumval{j})
                    giatrovato=1;
                end
            end
            if giatrovato==0
                notnumval{end+1}=btab.SubDir{i};
            end
        end
        
    end
end
disp(notnumval)

A = btab.Var1;
if iscell(A), A = str2double(A); end
A_filled = fillmissing(A,'previous');
if isnan(A_filled(1)), firstValid = find(~isnan(A_filled),1,'first'); A_filled(1:firstValid-1) = A_filled(firstValid); end
btab.Var1 = A_filled;

names = btab.FirmName;
if iscell(names)
    emptyIdx = cellfun(@(x) isempty(x) || all(isspace(x)), names);
    for i = 2:numel(names)
        if emptyIdx(i), names{i} = names{i-1}; end
    end
elseif isstring(names)
    emptyIdx = names == "" | ismissing(names);
    for i = 2:numel(names)
        if emptyIdx(i), names(i) = names(i-1); end
    end
end
btab.FirmName = names;


    outtab = btab;
end