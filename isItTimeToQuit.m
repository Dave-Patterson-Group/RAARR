function yesorno = isItTimeToQuit(elapsedtime, bestp,searchtimes)
yesorno = 0;
for i = 1:length(searchtimes)
    thisPair = searchtimes{i};
    thisTime = thisPair(1);
    thisLimit = thisPair(2);
    if (elapsedtime > thisTime) && (bestp < thisLimit)
        yesorno = 1;
    end
end