function [outtab] = tablefiltering(btab)
disp(btab.Properties.VariableNames)
btab = btab(:, {'Owner','Subs','Wei'});
%CHANGING THE NAMES
btab.Properties.VariableNames{'Owner'} = 'FirmName';
btab.Properties.VariableNames{'Subs'} = 'SUB_Name';
btab.Properties.VariableNames{'Wei'} = 'SubDir';
% btab = btab(:, {'Var1','CompanyNameLatinAlphabet','SUB_Name','SUB_Direct_'});
% %CHANGING THE NAMES
% btab.Properties.VariableNames{'CompanyNameLatinAlphabet'} = 'FirmName';
% btab.Properties.VariableNames{'SUB_Direct_'} = 'SubDir';
% % notnumval={};
% % righevuote=0;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %REMOVING FROM THE TABLE the columns that are unused
% A = btab.Var1;
% disp(btab.Properties.VariableNames)
% 
% if iscell(A), A = str2double(A); end
% A_filled = fillmissing(A,'previous');
% if isnan(A_filled(1)), firstValid = find(~isnan(A_filled),1,'first'); A_filled(1:firstValid-1) = A_filled(firstValid); end
% btab.Var1 = A_filled;
% 
% names = btab.FirmName;
% if iscell(names)
%     emptyIdx = cellfun(@(x) isempty(x) || all(isspace(x)), names);
%     for i = 2:numel(names)
%         if emptyIdx(i), names{i} = names{i-1}; end
%     end
% elseif isstring(names)
%     emptyIdx = names == "" | ismissing(names);
%     for i = 2:numel(names)
%         if emptyIdx(i), names(i) = names(i-1); end
%     end
% end
%btab.FirmName = names;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %FOR CYCLE, it removes the less and more signs and keeps the value
% for i = 2:height(btab)
%     % Estrai il valore numerico da Var1
%     if ~isempty(btab.SubDir{i}) && (btab.SubDir{i}(1)=='>' || btab.SubDir{i}(1)=='±' || btab.SubDir{i}(1)=='<')
%         btab.SubDir{i}=btab.SubDir{i}(2:end);
%     end
% 
% end
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %removes all the rows that don't have a numeric value
% convers = str2double(btab.SubDir);
% mask = isnan(convers);
% btab(mask, :) = [];
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %SubDir from string to double
% Sostituisci la riga che dà errore con questa:
height(btab)
btab.SubDir = str2double(string(btab.SubDir));
height(btab)
%btab.SubDir=str2double(btab.SubDir);
outtab = btab;

end
%DA QUA IN POI NO
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%random stuff

    % conve = str2double(btab.SubDir{i});
    % % vogliamo sapere i valori non comuni
    % if isnan(conve)
    %     if isempty(notnumval)
    %         notnumval{end+1}=btab.SubDir{i};
    %     else
    %         for j=1:length(notnumval)
    %             if  isequal(btab.SubDir{i},notnumval{j})
    %                 giatrovato=1;
    %             end
    %         end
    %         if isempty(btab.SubDir{i})
    %             righevuote=righevuote+1;
    %            % btab(i, :) = [];
    %         end
    %         if giatrovato==0
    %             notnumval{end+1}=btab.SubDir{i};
    %         end
    %     end
        
    % end



% eliminam& ~cellfun(@isempty, btab.SubDir);