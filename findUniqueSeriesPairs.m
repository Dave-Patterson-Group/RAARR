function newSeriesList = findUniqueSeriesPairs(seriesList)
newSeriesList = {};
dict = containers.Map(0,0);
numfound = 0;
for i = 1:length(seriesList)
    thisSeries = seriesList{i};
    if isKey(dict,thisSeries.hashInt) == 0
        dict(thisSeries.hashInt) = 1;
        newSeriesList{end+1} = thisSeries;
        numfound = numfound+1;
    end
end
newSeriesList = sortcellarraybyfield(newSeriesList,'pval');


