function outputkit = autofitseries(kit)
kit = findseriesfromspectrum(kit);
allseries = kit.allseries;
fprintf('found total of %d series from %3.1e\n',length(allseries), allseries{1}.pval);
numtotry = min(allseries{1}.ts.numseriestotry,length(allseries)); %may want to use time??
numtoshow = 1;
numfound = 0;
bestvotes = 0;
outputkit = kit;
for i = 2:numtotry
    for j = 1:i-1
        [finalfit numvotes newkit] = tryseriespair(allseries{j},allseries{i},kit);
 %       [finalfit numvotes] = tryseriespair(allseries{i},allseries{j},kit);
        if numvotes >= allseries{1}.ts.numconfirmsneeded
            outputkit = newkit;
            outputkit.finalfit = finalfit;  %turn on multiple conformer stuff.. but start again for each conformer.
            numfound = numfound+1;
            if numfound >= numtoshow
                return
            end
        end
        if numvotes > bestvotes
            bestvotes = numvotes;
            outputkit = newkit;
            outputkit.finalfit = finalfit;  %turn on multiple conformer stuff.. but start again for each conformer.
        end
    end
end

end

