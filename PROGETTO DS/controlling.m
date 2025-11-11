function [contr,posname,directsub] = controlling(tabBanche,nomecontr)
%CONTROLLING Summary of this function goes here
%   Detailed explanation goes here
contr=false
posname=[]
directsub=[]
for i=1:(height(tabBanche)-1)
    if isequal(tabBanche.SUB_Name{i},nomecontr)
        contr=true;
        posname=tabBanche.CompanyNameLatinAlphabet{i};
        directsub = tabBanche.SUB_Direct_{i};
    end
end

end