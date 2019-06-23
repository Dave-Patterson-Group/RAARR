function newFit = evolveFit(thisFit,kit,scoretype,nrepeats)
%scoretype is the figure of merit. scoretype = 'pval' is just tightest fit
%scoretype = 'broadpval' adds a factor of 10 for each [strong?] line
%see addscore

if nargin < 3
    scoretype = 'pval';
end
if nargin < 4
    nrepeats = [2 1];
end

thisFit = addscore(thisFit,scoretype);
newFit = thisFit;
for i = 1:100
    if i >= length(nrepeats)
        ntouse = nrepeats(end);
    else
        ntouse = nrepeats(i);
    end
    newFitList = extendFitList(thisFit,ntouse);
    fprintf('i is %d, trying %d new fits\n',i,length(newFitList));
    newFitList = testListOnKit(newFitList,kit,scoretype);
    thisFit = newFitList{1};
    thisFit = evolveCD(thisFit,kit,scoretype);
    if thisFit.fitScore > newFit.fitScore
        newFit = thisFit;
        fprintf('after %d rounds, %s %s\n',i,newFit.shortstring,newFit.scorefitdescriptor);
    else
        break
    end
end

function fitList = extendFitList(thisFit,nrepeats)
    fitList{1} = tweakFit(thisFit,0,0);
    for j = 1:nrepeats
        for i = 1:1
            fitList{end+1} = tweakFit(thisFit,3,0);
        end
        for i = 1:1
            fitList{end+1} = tweakFit(thisFit,8,1);
        end

        for i = 1:1
            fitList{end+1} = tweakFit(thisFit,0,1);
        end
        1;
    end
    
function newFit = tweakFit(firstFit,numadd,numsubtract)
a = extractfieldsfromcellarray(firstFit.newassignments,{'inoldfit','pval'});
inoldfit = a.inoldfit;
pvals = a.pval;
indices = 1:length(pvals);
oldies = indices(inoldfit == 1);
newies = indices(inoldfit == 0);
oldpvals = 1 ./ pvals(oldies);
newpvals = 1 ./ pvals(newies);
1;
if (numadd == 0) && (numsubtract == 0)
    newFit = firstFit;
    return;
end
if numsubtract == 0
    keepers = oldies;
else
    keepers = oldies(pickn(oldpvals,-numsubtract));
end
if (numadd == 0) || (numadd > length(newpvals))
    adders = [];
else
    adders  = newies(pickn(newpvals,numadd));
end
nexti = [keepers adders];
newFit = firstFit;
newFit.lines = {};
for i = 1:length(nexti)
    newFit.lines{end+1} = firstFit.newassignments{nexti(i)};
end
1;

    


function fitList = testListOnKit(fitList,kit,scoretype)
    for i = 1:length(fitList)
        fitList{i} = quickspfitfromfit(fitList{i});
        fitList{i} = testfitonkit(fitList{i},kit,0);
        fitList{i} = addscore(fitList{i},scoretype);
    end
    
    fitList = sortcellarraybyfield(fitList,'fitScore','descend');
    

function newBestFit = evolveCD(thisFit,kit,scoretype)
    thisFit = addscore(thisFit,scoretype);
    newBestFit = thisFit;
    CDvals = [0 1];  %at least should be [0 1] %eventually other values?
    for i = 1:length(CDvals)
        newFit = thisFit;
        newFit.useCD = CDvals(i);
        newFit = quickspfitfromfit(newFit);
        newFit = testfitonkit(newFit,kit);
        newFit = addscore(newFit,scoretype);
        if newFit.fitScore >= newBestFit.fitScore
            newBestFit = newFit;
            if (thisFit.useCD == 0) && (newBestFit.useCD == 1)
                fprintf('successfully added floating CD\n');
            end
        end
    end