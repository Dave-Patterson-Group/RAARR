function [seriesList,oldDict] = findNewSeriesPairs(seriesList,oldDict)

for i = 1:length(seriesList)
    thisSeries = seriesList{i};
    if isKey(oldDict,thisSeries.hashInt) == 1
        thisSeries.seenBefore = 1;
        seriesList{i} = thisSeries;
    else
        oldDict(thisSeries.hashInt) = 1;
    end
end


