function allSeriesPairs = findSeriesPairsFromSpectrum(kit)

if kit.cheatCodes.forcef1 == 0
    linestouse = kit.tightnesssettings.variant3.lines;
else
    linestouse = kit.cheatCodes.forcef1;
end
if isfield(kit.cheatCodes,'forceka') && (length(kit.cheatCodes.forceka) > 0)
    katouse = kit.cheatCodes.forceka;
else
    katouse = kit.tightnesssettings.variant3.kaguesses;
end

allSeriesPairs = {};

for ka = katouse
    %first find f0 lines
    
    %newSeriesPairs = seriesPairsFromLine(kit,linestouse,ka);
    newSeriesPairs = seriesPairsFromLineDepthfirst(kit,linestouse,ka);
    allSeriesPairs = findUniqueSeriesPairs([allSeriesPairs newSeriesPairs]);
end

function seriesPairs = seriesPairsFromLineDepthfirst(kit,linestouse,ka)
    global ALLEVERTRIED
    seriesPairs = {};
    for ll = linestouse
        [newPairs,babyKit] = babySeriesFromLine(kit,ll,ka);
        seriesPairs = [seriesPairs newPairs];
    end
    seriesPairs = sortcellarraybyfield(seriesPairs,'pval');
    %now start curating a list of all the series ever tried.
    ALLEVERTRIED = containers.Map(0,0);
    
    seriesPairs = setPairListField(seriesPairs,'searchf0',0);
    
    [seriesPairs,alltried] = extendAllf1Series(seriesPairs,babyKit);
   % ALLEVERTRIED = addkeys(alltried,ALLEVERTRIED);
    
    seriesPairs = firstn(seriesPairs,babyKit.ts.maxtof0);
    showPairList(seriesPairs);
    
    seriesPairs = setPairListField(seriesPairs,'searchf0',1);
 %   [seriesPairs] = markKnownSeriesPairs(seriesPairs,alltried);
    
    [seriesPairs,alltried] = extendAllf1Series(seriesPairs,babyKit);
    ALLEVERTRIED = addkeys(alltried,ALLEVERTRIED);
    seriesPairs = firstn(seriesPairs,babyKit.ts.maxPatterns);
    1;
    
    
    function bigdict = addkeys(smalldict,bigdict)
        k = smalldict.keys();
        for i = 1:length(k)
            thiskey = k{i};
            bigdict(thiskey) = smalldict(thiskey);
        end
        
        
    
    
    function cellarray = setPairListField(cellarray,fieldname,fieldvalue)
        for i = 1:length(cellarray)
            thisp = cellarray{i};
            thisp = setfield(thisp,fieldname,fieldvalue);
            thisp.seenBefore = 0;
            thisp = updateSeriesPair(thisp);
            cellarray{i} = thisp;
        end
    
function seriesPairs = seriesPairsFromLine(kit,linestouse,ka)
    seriesPairs = {};
    for ll = linestouse
        [newPairs,babyKit] = babySeriesFromLine(kit,ll,ka);
        seriesPairs = [seriesPairs newPairs];
    end
    alltried = containers.Map(0,0);
    
    seriesPairs = setcellarrayfield(seriesPairs,'searchf0',0);
    seriesPairs = extendAllf1Series(seriesPairs,babyKit,alltried);
    seriesPairs = firstn(seriesPairs,babyKit.ts.maxtof0);
    showPairList(seriesPairs);
    
    seriesPairs = setcellarrayfield(seriesPairs,'searchf0',1);
    
    seriesPairs = extendAllf1Series(seriesPairs,babyKit,alltried);
    seriesPairs = firstn(seriesPairs,babyKit.ts.maxPatterns);
    1;
    
function [babySeriesList,babyKit] = babySeriesFromLine(kit,ll,ka)
    babySeriesList = {};
    [fstart hstart istart rank] = pickfirstf(kit,ll);
    fprintf('%s,jumping into series from f=%3.1f, rank %d, height %3.1f\n',kit.molname,fstart,rank,hstart);

    fs = kit.onedpeakfs;
    hs = kit.onedpeakhs;
    
    counttool = makecounttool(hs);
    ts = kit.tightnesssettings.variant3;
    
    ts.gapmax = min(ts.gapmax,(kit.maxf-kit.minf)/(ts.minlines-1));
    hthresh = hstart/ts.atolerance;
    highenough = find(hs > hthresh);
    babyKit.fs = fs(highenough);
    babyKit.hs = hs(highenough);
    maxheight = max(hs);
    minheight = min(hs);
    babyKit.ts = ts;
    babyKit.cheatCodes = kit.cheatCodes;
    hthresh = hstart/ts.babytolerance;
    
    highenough = find(hs > hthresh);
    fs = fs(highenough);
    hs = hs(highenough);

    f2options = choosef2s(fs,fstart,ts,kit.cheatCodes);
   
    for jj = f2options
        [freqs, XI] = sort([fstart fs(jj)]);
        if ((freqs(2) - freqs(1)) > ts.gapmin) && ((freqs(2) - freqs(1)) < ts.gapmax) 
            heights = [hstart hs(jj)];
            heights = heights(XI);
      %      if (secondheight > (firstheight / ts.babytolerance))
            babyseries.f1Freqs = freqs;
            babyseries.f1Heights = heights;
            babyseries.maxheight = maxheight;
            babyseries.minheight = minheight;
            babyseries.maxf = kit.maxf;
            babyseries.minf = kit.minf;
            babyseries.ts = ts;
            babyseries.ka = ka;
            babyseries.searchf0 = 0;
            babyseries.countTool = counttool;
    %         babyseries.firstf = fstart;
    %         babyseries.firsth = hstart;
            babyseries.firstRank = rank;
            babyseries.originString =  sprintf('origin f = %3.2f,rank %d, height %3.1f\n',fstart,rank,hstart);
           % babyseries.whichcolumn = 1;
            1;
            if (max(heights) / min(heights)) < ts.babyatolerance
                try newSeries = updateSeriesPair(babyseries);
                    babySeriesList{end+1} = newSeries;
                catch
                    fprintf('skipping series %s %f %f',babyseries.originString,babyseries.f1Freqs(1),babyseries.f1Freqs(2));
                end
            end
        end
    end
    babySeriesList = sortcellarraybyfield(babySeriesList,'pval');

    
     function f2options = choosef2s(fs,firstline,ts,cheatCodes)
        minjj1 = find(fs > (firstline - ts.gapmax),1,'first');
        maxjj1 = find(fs > (firstline - ts.gapmin),1,'first');
        minjj2 = find(fs > (firstline + ts.gapmin),1,'first');
        maxjj2 = find(fs > (firstline + ts.gapmax),1,'first');
        if length(maxjj2) == 0
            maxjj2 = length(fs);
        end
        if length(minjj1) == 0
            minjj1 = 1;
        end
        f2options = [minjj1:maxjj1 minjj2:maxjj2];
        if isfield(cheatCodes,'forcef2') && cheatCodes.forcef2(1) > 0
            f2options = [];
            for i = 1:length(cheatCodes.forcef2)
                f = cheatCodes.forcef2(i);
                ferrs = abs(fs - f);
                f2options(end+1) = find(ferrs == min(ferrs),1,'first');     
            end
        end
    
    