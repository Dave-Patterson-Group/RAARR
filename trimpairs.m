function outpairs = trimpairs(pairlist,minf,maxf,smalldelk)
%displays the list, sorted by f.
if nargin < 4
    smalldelk = 0;
end
numpairs = length(pairlist);

nump = 0;
sfi = 1:numpairs;
outpairs = {};
for (i = 1:numpairs)
    thispair = pairlist{i};
    f = thispair.delf;
    if (f > minf) && (f < maxf)
        if (smalldelk == 0) || ...
           ((abs(thispair.delka) <= 1) && (abs(thispair.delkc) <= 1))
            
            outpairs{end+1} = thispair;
        end
    end
end
%comment out the next line to not sort.

