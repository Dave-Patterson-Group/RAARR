function s1 = addseriesvisbles(s1,window,linespacing)
    visiblefs = [];
    visiblehs = [];
    visibleis = [];
    for i = 1:length(s1.fs)
        if (s1.fs(i) > window(1)) && (s1.fs(i) < window(2))
            visiblefs(end+1) = s1.fs(i);
            visiblehs(end+1) = s1.hs(i);
            visibleis(end+1) = i;
            if isfield(s1,'lowestvisible') == 0
                s1.lowestvisible = s1.cheat.pairseries{i}.shortdescription;
            end
            1;
        end
    end
    if length(visibleis) < 2
        s1.topjvis = 0;
        s1.topjguess = 0;
        s1.botjguess = 0;
        s1.botjvis = 0;
        s1.intjguess = 0;
    else
        s1.topjvis = s1.jvalues(visibleis(end));
        s1.topjguess = visiblefs(end-1) / (visiblefs(end) - visiblefs(end-1));
        s1.botjguess = (visiblefs(1) / (visiblefs(2) - visiblefs(1))) - 1;
        s1.botjvis = s1.jvalues(visibleis(1));
        s1.intjguess = round(s1.botjguess);
    end
    s1.clinchthresh = 1;
    s1.visibleis = visibleis;
    s1.visiblefs = visiblefs;
    s1.visiblehs = visiblehs;
    s1.vishratio = min(s1.visiblehs) / s1.spectrummax;
    s1.numvisible = length(s1.visiblefs);
    if s1.numvisible == 0
        return
    end
    [upferrs downferrs] = polyfitseries(s1.visiblefs);
    s1.visibleuperrors = upferrs;
    s1.visibledownerrors = downferrs;
    s1.visibleabsuperrors = abs(upferrs);
    s1.visibleabsdownerrors = abs(downferrs);
    s1.visibledownps = s1.visibleabsdownerrors / linespacing;
    s1.polymaxdegree = 2;
  
    [uppredict,downpredict] = polyfitseriesnext(s1.visiblefs,s1.polymaxdegree);
    s1.polyuppredict = uppredict;
    s1.polydownpredict = downpredict;
    downi = max(1,min(s1.visibleis) - 1);
    upi = min(length(s1.fs),max(s1.visibleis) + 1);
    s1.downreal = s1.fs(downi);
    s1.upreal = s1.fs(upi);
    s1.downerror = s1.polydownpredict - s1.downreal;
    s1.uperror = s1.polyuppredict - s1.upreal;
    s1.polyPredictString = sprintf('degree %d poly predicts %3.2f/%3.2f [%3.2f/%3.2f]',s1.polymaxdegree,s1.downerror,s1.uperror,downpredict,uppredict);
    s1.numvisibleclinched = length(find(s1.visibleabsdownerrors < s1.clinchthresh));
    s1.visstring = sprintf('%d lines, visibility %3.2f, %d predicts <  %3.1f MHz jguess %3.1f [actually %d]',length(s1.visiblefs),s1.vishratio,s1.numvisibleclinched,s1.clinchthresh,s1.topjguess,s1.topjvis);
    s1.linespacing = linespacing;
    s1.pval = prod(s1.visibledownps);
    
    s1.secondordererror = mean(diff(diff(s1.visiblefs)));
    s1.allordererrors = s1.visibledownerrors;