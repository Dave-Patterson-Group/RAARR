function newfit = quickspfitfromfit(thisfit)
newfit = quickspfit(thisfit.lines,thisfit.ABC,thisfit.useCD);
if isfield(thisfit,'pattern')
    newfit.pattern = thisfit.pattern;
end
if isfield(thisfit,'patternType')
    newfit.patternType = thisfit.patternType;
end
if isfield(thisfit,'trial')
    newfit.trial = thisfit.trial;
end
