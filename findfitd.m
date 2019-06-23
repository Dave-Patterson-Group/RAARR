function [kit,foundone] = findfitd(kit)

resetSPFITCOUNT();
format short;

linestouse = kit.forcef1;

kit.numconverged = 0;
kit.numvotes = 0;
kit.finalfit = 0;

%kit.tightnesssettings = settingsfromtightness(kit.startingtightness); %not here?
starttime = now;
kit.speciesStarttime = starttime;
kit.startCensus = kit.totalCensus;
if kit.forcef1 == 0
    linestouse = kit.tightnesssettings.lines;
end
for i = 1:length(linestouse)
    linetouse = linestouse(i);
    kit = addsquaresfromline(kit,linetouse);
    elapsedTime = (now - starttime) * 1e5;
    timeToQuit = isItTimeToQuit(elapsedTime,kit.bestScaffoldp,kit.tightnesssettings.ladderSearchtimes);
    if (kit.bogged == 1) || (timeToQuit == 1)
        break;
    end
end
kit.scaffoldEndtime = now;
if length(kit.candidateScaffolds) == 0
        kit.phase1report = sprintf('no scaffolds found, ran to line %d',i);
else
        kit.phase1report = sprintf('%d scaffolds, best scaffold %s, quads %s',length(kit.candidateScaffolds),kit.candidateScaffolds{1}.pvalstring,kit.candidateScaffolds{1}.longquadstring);
end

[kit,foundone] = trycandidates(kit);
kit.speciesEndtime = now;
if foundone == 1
    kit = addLastReport(kit);
end
    %what order to try in?  try them all?
   % kit.candidateScaffolds;
   % a = extractonefieldfromcellarray(kit.candidateScaffolds,'netpval');
    1;
    function kit = addLastReport(kit)
        thisFit = kit.fitlist{end};
        thisScaffold = thisFit.seriessquare;
        
        thisTrial = thisFit.trial;
        firstAssignment = thisTrial.lineset{1}.descriptor;
        
        scaffoldTime = (kit.scaffoldEndtime - kit.speciesStarttime) * 1e5;
        spfitTime = (kit.speciesEndtime - kit.scaffoldEndtime) * 1e5;
        totalTime = spfitTime + scaffoldTime;
        timeString = sprintf('%d seconds (%d in scaffold search, %d in SPFIT search',round(totalTime),round(scaffoldTime),round(spfitTime));
        spfitString = sprintf('%d total calls to SPFIT',getSPFITCOUNT());
        s = thisFit.fitdescriptor;
        
        diffCensus = kit.totalCensus - kit.startCensus;
        censusReport = reportFromCensus(diffCensus);
        s = sprintf('%s\n%s\n%s\n%s\n%s\n==============\n%s',s,timeString,spfitString,firstAssignment,thisScaffold.longquadstring,censusReport);
        thisFit.fullReport = s;
        kit.fitlist{end} = thisFit;
        
    function s = reportFromCensus(census)
        s = sprintf('%d total flat squares',census(1));
        for i = 2:length(census)
            numlines = 4 + (2*i);
            if census(i) > 0
                s = sprintf('%s\n %d scaffolds with %d lines',s,census(i),numlines);
            end
        end

        
        

    function kit = addtrialsquarestokit(kit,newsquares)
        if length(newsquares) > 0
            newsquares = sortcellarraybyfield(newsquares,'netpval','ascend');
            numsquares = min(kit.tightnesssettings.maxsquaresfromline,length(newsquares));
            for i = 1:numsquares
                thissquare = newsquares{i};
                kit.candidateScaffolds{end+1} = thissquare;
            end %now sort 
            kit.candidateScaffolds = sortScaffolds(kit.candidateScaffolds);
        end
        if length(kit.candidateScaffolds) == 0
            kit.bestScaffoldp = 1;
        else
            kit.bestScaffoldp = kit.candidateScaffolds{1}.netpval;
        end
        
    function newScoffoldList = sortScaffolds(candidateScaffolds)
    newScoffoldList = {};
    hashesUsed = [];
    candidateScaffolds = sortcellarraybyfield(candidateScaffolds,'netpval','ascend');
    for i = 1:length(candidateScaffolds)
        thisScaffold = candidateScaffolds{i};
        thisHash = thisScaffold.gridhash;
        if ismember(thisHash,hashesUsed) == 0
            newScoffoldList{end+1} = thisScaffold;
            hashesUsed(end+1) = thisHash;
        end
    end
    
    function [outputkit,foundone] = trycandidates(kit)
    outputkit = kit;
    bestvotesyet = 0;
    foundone = 0;
    scaffolds = kit.candidateScaffolds;
    
    numtotry = min(length(scaffolds),kit.tightnesssettings.maxscaffolds);
%     if kit.bogged == 1
%         numtotry = 0;
%     end
    
    for j = 1:numtotry
        fprintf('trying %d/%d scaffolds, starting with %s\n',j,numtotry,scaffolds{j}.pvalstring);
        thisScaffold = scaffolds{j};
        thisScaffold.attemptIndex = j;
        thisScaffold.phase1report = kit.phase1report;
        %showseriessquare(thisScaffold);
        kit.numtries = kit.numtries+1;

        [newkit] = tryseriessquare(thisScaffold,kit);   %horrible flow. what does tryss return? a kit?   No, return just a finalfit
        thisfit = newkit.latestfit;
        numvotes = newkit.numvotes;
        if numvotes > kit.tightnesssettings.okhitvotecount  %great hit - put this into tightness though.
            kit.numconverged = kit.numconverged +1;
        end
        
        if numvotes > bestvotesyet  %good hit
            outputkit = newkit;
            outputkit.finalfit = thisfit;
            outputkit.numvotes = numvotes;
            outputkit.foundfit = newkit.foundfit;
            bestvotesyet = numvotes;
            foundone = 1;
            %newkit = kit;
        end
        if numvotes > kit.tightnesssettings.greathitvotecount  %great hit - put this into tightness though.
            return; %we're done. could also keep looking
        end
    end
        

function [finalsquares,searchReport] = squaresfromline(kit,linetouse)
    %new flow: call 'findflatsquares' and 'extendflatsquares', both of
    %which can be run on an existing ladder.
%tightnesssettings = settingsfromtightness(tightness);
ts = kit.tightnesssettings;
ts.starttime = now;

searchReport.bogged = 0;
searchReport.numflatsquares = 0;
% bogged = 1;
% 
% while bogged == 1
%     [finalsquares bogged] = squaresfromlinewithtightness(linetouse,kit,tightnesssettings);
%     if bogged == 1
%         tightness = tightness * 0.6;
%     end
% end
% newtightness = tightness;
% 
% 
% function [finalsquares bogged] = squaresfromlinewithtightness(linetouse,kit,ts)
    %ts is tightnesssettings
   finalsquares = {};
  

    
    [allsquares,kit] = getflatsquares(kit,linetouse,ts);
    fs = kit.usefs;
    hs = kit.usehs;
    seriessquares = {};
    
    searchReport.numflatsquares = length(allsquares);
    for i = 1:length(allsquares)
        seriessquares{end+1} = seriessquarefromflatsquare(allsquares{i},0);
        if seriessquares{end}.dtype && kit.Dinverted 
            seriessquares{end+1} = seriessquarefromflatsquare(allsquares{i},1);
        end
        
    end
    %cowcow
   % seriessquares = {seriessquares{7}};
  %  disp(length(seriessquares));
    if length(seriessquares) > ts.flatsquarelimit
        fprintf('%d is far too many flatsquares\n',length(seriessquares));
        searchReport.bogged = 1;
        return
    end

    if linetouse > 5000 %force f1
        if length(seriessquares) < 3
            for i = 1:length(seriessquares)
                disp(seriessquares{i}.bestfstring);
                showseriessquare(seriessquares{i},kit);
                1;
            end
        end
        1;
    end
    
    1;
%  seriessquares = {seriessquares{2}};
    [seriessquares,bogged,census] = extendseriessquarealltheway(seriessquares,fs,hs);
    searchReport.census = census;
    if bogged == 1
        searchReport.bogged = 1;
        return
    end
%     if linetouse > 5000 %force f1
%         fprintf('after extend\n');
%         for i = 1:length(seriessquares)
%             disp(seriessquares{i}.bestfstring);
%     %        showseriessquare(seriessquares{i},kit);
%             1;
%         end
%         1;
%     end
%     1;
    %we now evaluate how well we did.  The ultimate test is: do we have
    %1) A manageable number of ``confirmed'' answers, defined here to be degree 3 or more
    %2) A reasonable fraction contain the right answer - at least 7 lines
    %3) Those 7 lines are sufficient to converge [this one we don't know yet;
    %some work with cheats is required.  But I am fearful if the bends are
    %small
    allps = extractfieldsfromcellarray(seriessquares,{'netpval','testable'});
    alltests = allps.testable;
    allps = allps.netpval;
    
   % disp(allps.netpval);
%     if linetouse > 5000 %force f1
%         for i = 1:length(seriessquares)
%             disp(seriessquares{i}.bestfstring);
%         %    showseriessquare(seriessquares{i},kit);
%             1;
%         end
%         1;
%     end
   % seriessquares = addpvals(seriessquares,fs,hs);
%    sr = successreport(seriessquares,f1cheat);
%    disp(sr.summary);
    
    for i = 1:length(seriessquares)
        s = seriessquares{i};
%             [a b] = min(sr.pvals);
%             s2 = seriessquares{b};
%             showseriessquare(s,kit);
%             if s.degree >= 4
%                 showseriessquare(s,kit);
%                 1;
%             end
        if s.testable == 1 %s.netpval < ts.minpval  %more tightness
            numps = length(find(alltests == 1));
            if s.netpval == min(allps)
                fprintf('adding %d squares from %3.1f of degree %d, pval %3.2e\n',numps,s.originalf1,s.degree,s.netpval);
            end
            finalsquares{end+1} = s;
        end
    end
    finalsquares = sortcellarraybyfield(finalsquares,'netpval','ascend');
    if ts.trimends
        finalsquares = trimends(finalsquares);
    end
    finalsquares = removeidentical(finalsquares);
    
%     if length(sr.worthconfirming) > 0
%         for i = sr.worthconfirming
%             finalsquares{end+1} = seriessquares{i};
%         end
%     end
    
    


%end
    function s = addrows(s,addrowabove,addrowbelow)
        if addrowabove
            s.column1.fs = [s.column1.fs 0];
            s.column1.hs = [s.column1.hs 0];
            s.column2.fs = [s.column2.fs 0];
            s.column2.hs = [s.column2.hs 0];
            s.column3.fs = [s.column3.fs 0];
            s.column3.hs = [s.column3.hs 0];
            s.column4.fs = [s.column4.fs 0];
            s.column4.hs = [s.column4.hs 0];
        end
        if addrowbelow
            s.column1.fs = [0 s.column1.fs];
            s.column1.hs = [0 s.column1.hs];
            s.column2.fs = [0 s.column2.fs];
            s.column2.hs = [0 s.column2.hs];
            s.column3.fs = [0 s.column3.fs];
            s.column3.hs = [0 s.column3.hs];
            s.column4.fs = [0 s.column4.fs];
            s.column4.hs = [0 s.column4.hs];
        end
        
        
        function s = getcolumn(fullsquare,whichseries)
            switch whichseries
                case 1
                    s = fullsquare.column1;
                case 2
                    s = fullsquare.column2;
                case 3
                    s = fullsquare.column3;
                case 4
                    s = fullsquare.column4;
            end
            


% frange = [minf maxf];
% mingap = 200;
% minf2 = predictf2 - f_allowed(n+1);
% maxf2 = predictf2 + f_allowed(n+1);
%
% totf = allfs(end) - allfs(1);
% delf = maxf - minf;
% expectedn = length(allfs) * delf / totf;
% maxf2 = predictf2 + fthresh;
% if maxf2 > allfs(end)
%     s.terminal = 1;
% else
%     s.terminal = 0;
% end
% allowedf = find((allfs < maxf) & (allfs > minf) & ((allfs < (s.fs(1)-mingap)) | (allfs > (s.fs(1)+mingap))));
% 
% nextfs = allfs(allowedf);
% nexths = allhs(allowedf);
% ferrors = nextfs - predictf;

function [nextfs nexths ferrors frange] = extendseriesbyone(fullsquare,whichseries,whichj,allfs,allhs)

%uses a polynomial fit to extend the series f.
%this thing explodes when extending series of length one.  In this mode, if
%tightmode is turned on, it uses fs(1) + bplusc as a first guess
%if nothing is found, returns [[] []];
newseriesset = {};

switch whichseries
    case 1
        s = fullsquare.column1;
    case 2
        s = fullsquare.column2;
    case 3
        s = fullsquare.column3;
    case 4
        s = fullsquare.column4;
end
upordown = -1;
if (whichj <= length(s.fs)) && (whichj > 0) && (s.fs(whichj) ~= 0)
    error('looking for a line I already have!');
end
if (whichj > 1) && (s.fs(whichj-1) ~= 0)
    upordown = 1;
end
if (whichj < length(s.fs)) && (s.fs(whichj+1) ~= 0)
    upordown = 0;
end
%f_allowed = [0 50 20 12 8 8 6 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];  %allowed errors after n hits.  with 2 lines, window is +- 50.
%f_allowed = [800 15 4 3 1 1 1 1 1 1 1 1 1 1 1 ];  %allowed errors after n hits.  with 2 lines, window is +- 50.
%f_allowed = [1500 60 35 20 20 20 20 20 20 20 20 20 20 ]; %how good do we demand the prediction be?
% if tightmode == 1
%     f_allowed = [60 35 20 3 2 2 2 1 1 1 1 1 1 1 1 ];
% else
%     f_allowed = [300 70 40 20 10 8 6 6 6 6 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];
% end

f_allowed = s.tolerance; %tightness * [300 70 40 20 10 8 6 6 6 6 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4 4];
% if tightmode == 1
%     f_allowed = f_allowed/2;
% end
%f_allowed = [1500 200 100 100 100 100 20 20 20 20 20 20 20 ];

if upordown == -1  %empty series, use column 1 or 3
    if fullsquare.column1.fs(whichj) ~= 0 
        predictf = fullsquare.column1.fs(whichj);  %theres a f1f4 tweak here possible..
    else
        predictf = fullsquare.column4.fs(whichj); 
    end
    if (whichseries == 2) || (whichseries == 3)
        fthresh = fullsquare.abtolerance;
    else
        fthresh = fullsquare.aatolerance;
    end
else
    n = length(s.realfs);
    x = 1:n;
    y = s.realfs;
    [p] = polyfit(x,y,n-1);
    if upordown == 1
        predictf = polyval(p,n+1);
        fthresh = f_allowed(n);
   %     predictf2 = s.nextf;
    end
    if upordown == 0
        predictf = polyval(p,0);
        fthresh = f_allowed(n);
    %    predictf2 = s.prevf;
    end

    if n == 1
        if upordown == 1
            predictf = s.realfs(1) + fullsquare.bpluscguess;  %more tweaks here cowcow
        else
            predictf = s.realfs(1) - fullsquare.bpluscguess;
        end
        if (whichseries == 2) || (whichseries == 3)
            fthresh = fullsquare.bpluscerror * 4;
        else
            fthresh = fullsquare.bpluscerror * 2;
        end
    end
end
%if n == 0  %first line in a series..
    
minf = predictf - fthresh;
maxf = predictf + fthresh;

frange = [minf maxf];
mingap = 200;
% minf2 = predictf2 - f_allowed(n+1);
% maxf2 = predictf2 + f_allowed(n+1);
%
% totf = allfs(end) - allfs(1);
% delf = maxf - minf;
% expectedn = length(allfs) * delf / totf;
% maxf2 = predictf2 + fthresh;
% if maxf2 > allfs(end)
%     s.terminal = 1;
% else
%     s.terminal = 0;
% end
allowedf = find((allfs < maxf) & (allfs > minf) & ((allfs < (s.fs(1)-mingap)) | (allfs > (s.fs(1)+mingap))));
nextfs = allfs(allowedf);
nexths = allhs(allowedf);
ferrors = nextfs - predictf;


% s.series1 = s.column1;
% s.series2 = s.column2;
% s.series3 = s.column3;
% s.series4 = s.column4;
% s = updateseriessquare(s);

    




% 
% 
% function r = successreport(seriessquares,f1cheat)
% %successreport does not use explicit cheats, like pairlist.  But it can use
% %the quad errors, which are exactly zero on undistorted simulated data.
% %rewrite this whole thing, it's hot garbage. "seemsgood"??
% degrees = extractfieldsfromcellarray(seriessquares,{'degree','maxsquaresum','worstquadsum','singlequaderror','doublequaderror','netpval'});
% n = degrees.degree;
% sqe = degrees.singlequaderror;
% dqe = degrees.doublequaderror;
% worstquadsum = degrees.worstquadsum;
% pvals = degrees.netpval;
% if ischar(f1cheat)
%     r.context = f1cheat;
% else
%     r.context = 'should get context from f1cheat struct';
% end
% 
% if length(seriessquares) == 0
%     r.maxdegree = 0;
%     r.numseries = 0;
%     r.degrees = [];
%     r.singlequaderror = [];
%     r.doublequaderror = [];
%     r.confirmedi = [];
%     r.worthpursuing = [];
%     r.worthconfirming = [];
%     r.reallyworthpursuing = [];
%     r.goodnewsi = [];
%     r.findable = [];
%     r.superi = [];
%     r.goodone = 0;
%     r.pursuethis = 0;
%     r.firstround = [];
%     r.summary = sprintf('%s none found',r.context);
%     return
% end
% firstround = find(n >= 2);
% confirmedi = find(n >= 3);
% superconfirmedi = find(n >= 4);
% convergable = find(dqe < 1e-8);  % this is cheating, but very likely to work
% unlikely = find(pvals < 1e-4);
% 
% passedquad = find(worstquadsum < .060);  %this seems to be a touchy one.. 
% 
% findable = intersect(firstround,convergable);
% goodnewsi = intersect(confirmedi,convergable);
% superi = intersect(superconfirmedi,convergable);
% 
% worthpursuing = intersect(intersect(confirmedi,passedquad),unlikely);
% worthconfirming = intersect(firstround,passedquad);
% reallyworthpursuing = intersect(superconfirmedi,passedquad);
% 
% r.degrees = n;
% r.pvals = pvals;
% r.unlikely= unlikely;
% r.worstquadsum = worstquadsum;
% r.passedquad = passedquad;
% r.minpval = min(pvals);
% r.maxdegree = max(n);
% r.mindegree = min(n);
% r.numseries = length(n);
% r.singlequaderror = sqe;
% r.doublequaderror = dqe;
% r.confirmedi = confirmedi;
% r.worthpursuing = worthpursuing;
% r.worthconfirming = worthconfirming;
% r.reallyworthpursuing = reallyworthpursuing;
% r.goodnewsi = goodnewsi;
% r.findable = findable;
% r.superi = superi;
% r.firstround = firstround;
% r.summary = sprintf('%s %d found degree %d->%d min p %3.2e',r.context,r.numseries,r.mindegree,r.maxdegree,r.minpval);
% if length(findable) == 0
%     assessstring = '7 line fit was never seen';  %4 line fit?
% end
% if (length(findable) > 0) && (length(goodnewsi) == 0)
%     assessstring = '7 line fit was right but never confirmed';
% end
% 
% if (length(goodnewsi) > 0)
%     assessstring = sprintf('GOOD NEWS - %d/%d confirmed 7 line hits (%d to degree 4) [first is #%d]',length(goodnewsi),length(n),length(superi),goodnewsi(1));
% end
% if isstruct(f1cheat)
%     r.context = sprintf('%s\n%s <----- %s\n',assessstring,f1cheat.kingdescription,f1cheat.setupdescription);
% else
%     r.context = f1cheat;
% end
% 
% %r.titlestring = sprintf('GOOD %d/%d confirmed 7 liners (%d to degree 4) %s',length(goodnewsi),length(n),length(superi),f1cheat.kingdescription);
% r.pursuethis = 0;
% 
% if length(reallyworthpursuing) > 0
%     r.pursuethis = seriessquares{reallyworthpursuing(1)};
% elseif length(reallyworthpursuing) > 0
%     r.pursuethis = seriessquares{reallyworthpursuing(1)};
%     %sort by degree, then bends?
% elseif length(worthconfirming) > 0
%     for i = 1:length(worthconfirming)
%         bends(i) = abs(seriessquares{worthconfirming(i)}.series1bend);
%     end
%     besti = find(bends == min(bends),1,'first');
%     r.besti = worthconfirming(besti);
%     r.pursuethis = seriessquares{worthconfirming(besti)};
% end
% 
% if isstruct(r.pursuethis)
%     if isstruct(f1cheat)
%         r.pursuetitlestring = sprintf('pursue %s %d/%d confirmed %s %s',f1cheat.setupdescription,length(worthpursuing),length(n),f1cheat.kingdescription,r.pursuethis.bendstring);
%     else
%         r.pursuetitlestring = sprintf('pursue %d/%d confirmed %s',length(worthpursuing),length(n),r.pursuethis.bendstring);
%     end
% end
% 
% r.goodone = 0;
% if length(superi) > 0
%     r.goodone = seriessquares{superi(1)};
% elseif length(goodnewsi) > 0
%     r.goodone = seriessquares{goodnewsi(1)};
% end
% if isstruct(r.goodone)
%     r.titlestring = sprintf('GOOD %s %d/%d confirmed (%d to n=4) %s %s',f1cheat.setupdescription,length(goodnewsi),length(n),length(superi),f1cheat.kingdescription,r.goodone.bendstring);
% end
% 
% r.assesstring = assessstring;
% %identifies the line, series, etc from line f1.

function yesorno = seriessubset(series1,series2,thresh)
if nargin < 3
    thresh = 0.05;
end
%returns 1 if series1 is 
yesorno = 1;
for i = 1:length(series1)
    errs = abs(series2 - series1(i));
    if min(errs) > thresh
        yesorno = 0;
    end
end

function yesorno = squaresubset(s1,s2,thresh,i,j)
if nargin < 3
    thresh = 0.05;
end
yesorno = 0;
if (seriessubset(s1.series1.fs,s2.series1.fs,thresh) && ...
   seriessubset(s1.series2.fs,s2.series2.fs,thresh) && ...
   seriessubset(s1.series3.fs,s2.series3.fs,thresh)) 
    yesorno = 1;
end
if (seriessubset(s1.series1.fs,s2.series1.fs,thresh) && ...
   seriessubset(s1.series2.fs,s2.series3.fs,thresh) && ...
   seriessubset(s1.series3.fs,s2.series2.fs,thresh) && (i < j)) 
   yesorno = 1;
end

function yesorno = identicalseries(s1,s2)
yesorno = 1;
if (length(s1.fgrid(:,1)) ~= length(s2.fgrid(:,1)))
    yesorno = 0;
    return
end

different1 = 0;
different2 = 0;
for i = 1:length(s1.fgrid(:,1))
    s1vals = s1.fgrid(i,:);
    s2vals = s2.fgrid(i,:);
    diffs = s1vals - s2vals;
    if max(abs(diffs)) > 0.01
        different1 = 1;
    end
    s2vals = s2vals([4 3 2 1]);
    diffs = s1vals - s2vals;
    if max(abs(diffs)) > 0.01
        different2 = 1;
    end
end
if different1 && different2
    yesorno = 0;
end

    function s = trimend(s)
    numj = length(s.column1.fs);
    if numj <= 3
        return
    end
    if numj == 4
        jmin = 1;
        jmax = 3;
    end
    if numj > 4
        jmin = 2;
        jmax = 4;
    end
    s.column1.fs = s.column1.fs(jmin:jmax);
    s.column2.fs = s.column2.fs(jmin:jmax);
    s.column3.fs = s.column3.fs(jmin:jmax);
    s.column4.fs = s.column4.fs(jmin:jmax);
    
    s.column1.hs = s.column1.hs(jmin:jmax);
    s.column2.hs = s.column2.hs(jmin:jmax);
    s.column3.hs = s.column3.hs(jmin:jmax);
    s.column4.hs = s.column4.hs(jmin:jmax);
    olds = s;
    s = updateseriessquare(s);
%     showseriessquare(olds);
%     showseriessquare(s);
    1;
    
function squarelist = trimends(squarelist)
    newlist = {};
    for i = 1:length(squarelist)
        s = squarelist{i};
     %   oldnetpval = s.netpval;
        s.originalpval = s.netpval;
        s = trimend(s);
        
        squarelist{i} = s;
    end
    
function newlist = removeidentical(slist)
    newlist = {};
    for i = 1:length(slist)
        isindy = 1;
        for j = 1:length(newlist)
            if identicalseries(slist{i},newlist{j})
                isindy = 0;
            end
        end
        if isindy
            sortfs = sort(slist{i}.allfs);
            if min(diff(sortfs)) > 0.01
                
                newlist{end+1} = slist{i};
            end
        end
        
    end

function newlist = removesubsets(slist)
%newlist contains all memebers of slist which aren't subsets of other
%members of slist, not counting themselves of course
%slist = sortcellarraybyfield(slist,'netpval','ascend');
newlist = {};
for i = 1:length(slist)
    isindy = 1;
    for j = 1:length(slist)
        if (i ~= j) && (squaresubset(slist{i},slist{j},0.05,i,j) == 1)
            isindy = 0;
        end
    end
    if isindy
        newlist{end+1} = slist{i};
    end
end

function s = addseriespval(s, linedensity)
pval = 1;
linespacing = 1 / linedensity;
for i = 3:length(s.predicterrs)
    thisp = abs(s.predicterrs(i) / linespacing);
    if thisp < 1
        pval = pval * thisp;
    end
end
s.pval = pval;
1;



% 
% function count = countfrommcounttool(counttool,h)
%     count = interp1(counttool.hvalues,counttool.countvalues,h);
    
    

    
function yesorno = containsf(s,f)
    yesorno = 0;
    ferrors = abs(s.allfs - f);
    if min(ferrors) < 0.1
        yesorno = 1;
    end
        
