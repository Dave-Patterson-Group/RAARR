function [matchpair,index] = pullpair(pairlist,line)
matchpair = 0;
index = 0;
for i = 1:length(pairlist)
    thispair = pairlist{i};
    if ((line.Jupper == thispair.startj) && ...
        (line.Kaupper == thispair.startka) && ...
        (line.Kcupper == thispair.startkc) && ...
        (line.Jlower == thispair.endj) && ...
        (line.Kalower == thispair.endka) && ...
        (line.Kclower == thispair.endkc))
        matchpair = thispair;
        index = i;
    end
    if ((line.Jupper == thispair.endj) && ...
        (line.Kaupper == thispair.endka) && ...
        (line.Kcupper == thispair.endkc) && ...
        (line.Jlower == thispair.startj) && ...
        (line.Kalower == thispair.startka) && ...
        (line.Kclower == thispair.startkc))
        matchpair = thispair;
        index = i;
    end
end
