function [seriesList,oldDict] = markKnownSeriesPairs(seriesList,oldDict)

for i = 1:length(seriesList)
    thisSeries = seriesList{i};
    if isKey(oldDict,thisSeries.hashInt) == 1
        thisSeries.seenBefore = 1;
        seriesList{i} = thisSeries;
    else
        thisSeries.seenBefore = 0;
        seriesList{i} = thisSeries;
        oldDict(thisSeries.hashInt) = 1;
    end
end


