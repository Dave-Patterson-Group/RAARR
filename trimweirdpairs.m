function outpairs = trimweirdpairs(pairlist)
outpairs = {};
for (i = 1:length(pairlist))
    thispair = pairlist{i};
    
    if (abs(thispair.delj) <= 1) && (abs(thispair.delka) <= 1) || (abs(thispair.delkc) <= 1)
        outpairs{end+1} = thispair;
    end
end
%comment out the next line to not sort.

