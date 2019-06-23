function [kit,argsin] = makefakeserieskit(argsin,uniqueid)
%called by runfakeseriesassign.  makes a kit based on a fake molecule, and saves it
%in argsin.kitfilename.  argsin.kitfilename is enough to run complete
%autoseriesassignment.
%a series kit is composed of one or more series; each series is, most
%importantly, a set of frequencies, but also series.cheat which contains
%the correct assignment and correct first line.
%ultimately, there will be a command linesfromseries(firstline), which
%gives the full assignment.


if nargin < 2
    uniqueid = floor(rand * 1e6);
end
rng(uniqueid)
    if isfield(argsin,'whichka') == 0
        argsin.whichka = 0;
    end
    if isfield(argsin,'mwupper') == 0
        argsin.mwupper = 25;
    end
    if isfield(argsin,'mwlower') == 0
        argsin.mwlower = 5;
    end
    argsin.molstats.kalimit = argsin.whichka+1;  %change for higher series..
    pgoargsin.molstats = argsin.molstats;
    pgoargsin.maxj = argsin.maxj;
    %argsin.usepgo = 0;
    pgoargsin.reduceset = 0;
    pgoargsin.maxrf = 0;  %in GHz
    pgoargsin.minrf = 0;
    pgoargsin.maxmw = argsin.mwupper;
    pgoargsin.minmw = argsin.mwlower;
    pgoargsin.temp = 6;
    pgoargsin.weirdok = argsin.actype;
   % pgoargsin.usespcat = 1;
    [pairlist] = findallpairspgo(pgoargsin);
    
    kit.visiblewindow = argsin.visiblewindow;

    kit.uniqueid = uniqueid;
    kit.iterid = 1;
    fields = extractfieldsfromcellarray(pairlist,{'delfMHZ','sixKweakpulsestrength'});
    kit.onedpeakfs = fields.delfMHZ;
    kit.onedpeakhs = fields.sixKweakpulsestrength;
    kit = addvisiblefs(kit);
    kit.maxh = max(kit.onedpeakhs);
    kit.pairlist = pairlist;
    kit.fakemolname = argsin.fakemolname;
    numpairs = length(pairlist);
    
    allseriesmap = containers.Map;
    allseries = {};
    ka = argsin.whichka;
    if argsin.actype == 1
        delkalimit = 1;
        delkclimit = 2;
        heightlimit = kit.maxh/200;
    else
        delkalimit = 1;
        delkclimit = 1;
        heightlimit = kit.maxh/50;
    end
    for i = 1:numpairs
        thispair = pairlist{i};
        if (abs(thispair.delj) <= 1) && (abs(thispair.delka) <= delkalimit) && (abs(thispair.delkc) <= delkclimit)
%             if strcmp(thispair.shortdescription(1:6),'5 0 5 ') %0=>2 2 1 0 b')
%                 thispair.shortdescription
%                 1;
%             end


            
            thisseries = pullseries(pairlist,thispair,kit.visiblewindow);
            if (thisseries.numvisible >= 2) && thisseries.numlines >= 2 && (thisseries.bpluscguess > 300) && (thisseries.meanh > heightlimit)
%                thisseries = addpolytoseries(thisseries);
                allseriesmap(thisseries.cheat.descriptor) = thisseries;
                1;
%                 if allseriesmap.Count > 4
%                     break
%                 end
            end
        end
    end
    for series= allseriesmap.values
        
        allseries{end+1} = series{1};
    end
   
    kit.allseries = allseries;


    cheat.molstats = argsin.molstats;
    cheat.molstring = sprintf('%d: [%3.1f %3.1f %3.1f]',kit.uniqueid,cheat.molstats.a,cheat.molstats.b,cheat.molstats.c);
%    cheat.descriptor = [seriesi.cheat.descriptor ' :: ' seriesj.cheat.descriptor];
    
    kit.cheat = cheat;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numseries = length(kit.allseries);
    series1.fs = [];
    series3.fs = [];
    series2.fs = [];
    series4.fs = [];
for i = 1:numseries
    if argsin.actype == 0
        s = kit.allseries{i};
        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka) && (s.cheat.lowestpair.startka == ka)
            series1 = s;

        end

        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka ~= 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka) && (s.cheat.lowestpair.startka == ka)
            series3 = s;
        end

        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka ~= 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka) && (s.cheat.lowestpair.startka == 1+ka)
            series2 = s;
        end

        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka) && (s.cheat.lowestpair.startka == 1+ka)
            series4 = s;
        end
    else
        s = kit.allseries{i};
        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka) && (s.cheat.lowestpair.startka == ka)
            series1 = s;

        end

        if (s.cheat.lowestpair.delj ~= 0) && (abs(s.cheat.lowestpair.delka) == 1) && (abs(s.cheat.lowestpair.delkc) == 2) && ...
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka) && (s.cheat.lowestpair.startka == ka)
            series3 = s;
        end

        if (s.cheat.lowestpair.delj ~= 0) && (abs(s.cheat.lowestpair.delka) == 1) && (s.cheat.lowestpair.delkc == 0) && ... %cowcow
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka-1) && (s.cheat.lowestpair.startka == 1+ka)
            series2 = s;
        end

        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka-1) && (s.cheat.lowestpair.startka == 1+ka)
            series4 = s;
        end
    end
end

if (length(series1.fs) < 2) || (length(series2.fs) < 2) || (length(series3.fs) < 2) || (length(series4.fs) < 2)
    error('not all series found %d %d %d %d',length(series1.fs),length(series2.fs),length(series3.fs),length(series4.fs));
end
a1diff = 0;
a2diff = 0;
a2flex = 0;
a1bend = 0;
a1flex = 0;
a2bend = 0;
b1diff = 0;
b2diff = 0;
b1bend = 0;
b2bend = 0;
a1j = series1.fs(1) / (series1.fs(2) - series1.fs(1));
a2j = series4.fs(1) / (series4.fs(2) - series4.fs(1));

if (length(series2.fs) > 0) && (length(series3.fs) > 0)
    fourseriesmode = 1;
else
    fourseriesmode = 0;
end

if length(series1.fs) >= 2
    a1diff = mean(diff(series1.fs));
end

if length(series1.fs) >= 3
    a1bend = mean(diff(diff(series1.fs)));
end
if length(series1.fs) >= 4
    a1flex = mean(diff(diff(diff(series1.fs))));
end

if length(series4.fs) >= 2
    a2diff = mean(diff(series4.fs));
end

if length(series4.fs) >= 3
    a2bend = mean(diff(diff(series4.fs)));
end
if length(series1.fs) >= 4
    a2flex = mean(diff(diff(diff(series4.fs))));
end

a1bendstring = sprintf('a1diff %3.3f, a1bend %3.3f, a1flex %3.3f J=%1.2f',a1diff,a1bend,a1flex,a1j);
a2bendstring = sprintf('a2diff %3.3f, a2bend %3.3f, a2flex %3.3f J=%1.2f ',a2diff,a2bend,a2flex,a2j);
aamaxerror = a1diff-a2diff;

if length(series2.fs) >= 2
    b1diff = mean(diff(series2.fs));
end

if length(series2.fs) >= 3
    b1bend = mean(diff(diff(series2.fs)));
end

if fourseriesmode
    if length(series3.fs) >= 2
        b2diff = mean(diff(series3.fs));
    end
    
    if length(series3.fs) >= 3
        b2bend = mean(diff(diff(series3.fs)));
    end
    
    b1bendstring = sprintf('b1diff %3.3f, b1bend %3.3f',b1diff,b1bend);
    b2bendstring = sprintf('b2diff %3.3f, b2bend %3.3f',b2diff,b2bend);
    
    
    tightdescriptor = sprintf('%s\n%s\n%s\n%s\naa tolerance %3.1f\n',a1bendstring,a2bendstring,b1bendstring,b2bendstring,aamaxerror);
    
    
    minjs = [series1.cheat.lowestpair.endj series2.cheat.lowestpair.endj series3.cheat.lowestpair.endj series4.cheat.lowestpair.endj];
    bottomj = max(minjs);
    numtrim = bottomj - minjs;
    
    oldseries3 = series3;
    try
        series1 = trimseries(series1,numtrim(1));
        series2 = trimseries(series2,numtrim(2));
        series3 = trimseries(series3,numtrim(3));
        series4 = trimseries(series4,numtrim(4));
    catch
        fprintf('series 2 jvalues:\n');
        series2.jvalues
        fprintf('series 3 jvalues:\n');
        series3.jvalues
        error('could not make a lattice');
    end
    numlines = [series1.numlines series2.numlines series3.numlines series4.numlines];
    numlines = min(numlines);
    fprintf('series 1: %s %d lines\n',series1.descriptor,length(series1.fs));
    fprintf('series 2: %s %d lines\n',series2.descriptor,length(series2.fs));
    fprintf('series 3: %s %d lines\n',series3.descriptor,length(series3.fs));
    fprintf('series 4: %s %d lines\n',series4.descriptor,length(series4.fs));
    1;
%     fprintf('series 1, a-ladder\n');
%     presentclassical(series1);
%     fprintf('series 2, b-ladder\n');
%     presentclassical(series2);
%     fprintf('series 3, b-ladder\n');
%     presentclassical(series3);
%     fprintf('series 4, a-ladder\n');
%     presentclassical(series4);
    
    series1.ploth = 0;
    series2.ploth = 0;
    series3.ploth = series1.fs(1) - series3.fs(1);
    series4.ploth = series3.ploth;
    for i = 1:numlines
        series1.ploth(end+1) = series1.ploth(end) + series1.fs(i);
        
        series4.ploth(end+1) = series4.ploth(end) + series4.fs(i);
        
    end
    
    
    series2.ploth = series1.ploth;
    series3.ploth = series4.ploth;
    
    f1f3 = series1.fs(1) - series2.fs(1);
    f3predict = (series1.fs(2) - series1.fs(1)) + (series2.fs(1));
    f3error = series2.fs(2) - f3predict;
    
    
    actualj= series1.cheat.lowestpair.startj;
    actualka = series1.cheat.lowestpair.startka;
    kit.serieslengths = [length(series1.fs) length(series2.fs) length(series3.fs) length(series4.fs)];
    kit.series2 = series2;
    kit.series3 = series3;
    kit.fullseries3 = oldseries3;
    kit.plotaonly = 0;
    kit.f1f3 = f1f3;
    kit.f3predict = f3predict;
    kit.f3error = f3error;
    
    kit.actualj = actualj;
    kit.actualka = actualka;
    kit.b2bendstring = b2bendstring;
    kit.tightdescriptor = tightdescriptor;
    kit.numlines = numlines;
else
    kit.serieslengths = [length(series1.fs) length(series4.fs)];
    kit.plotaonly = 1;
end
bplusc = series1.fs(2) - series1.fs(1);
predictj = series1.fs(1) / bplusc;

kit.fourseriesmode = fourseriesmode;

%kit.numlines = numlines;
kit.series1 = series1;
kit.series4 = series4;
kit.minwindow = kit.visiblewindow(1);
kit.maxwindow = kit.visiblewindow(2);


kit.minserieslength = min(kit.serieslengths);
kit.predictj = predictj;
kit.bplusc = bplusc;

if isfield(argsin,'skipdryrun') && argsin.skipdryrun == 1
    return
end







    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if argsin.cloudkit == 1
        kit.kitfilename = sprintf('Kits/fakekit%d',kit.uniqueid);
    else
        
       kit.kitfilename = [getspfitpath() sprintf('/fakekit%d',kit.uniqueid)];
    end
   % kit.kitfilename = argsin.kitfilename;
    if argsin.distortkit
        kit = distortkit(kit);
    end
    if isfield(argsin,'templatekit')
        kit.templatemode = 1;
        kit.templateabsolute = [argsin.templatekit.dryrunsquare.listerrors zeros(1,20)];
        kit.templatenorm = [argsin.templatekit.dryrunsquare.listnormerrors zeros(1,20)];
        kit.dryrunstartpair = argsin.templatekit.dryrunstartpair;
        kit.dryrunstartline = argsin.templatekit.dryrunstartline;
        kit.forcecorners = 1;
        kit.cornermap = argsin.templatekit.dryruncorners;
    
    
    else
        kit.templatemode = 0;
        kit.templateabsolute = zeros(1,50);
        kit.templatenorm = zeros(1,50);
        kit.forcecorners = 0;
        kit.cornermap = 0;
    end
   % try
   kit.titlestring = kit.fakemolname;
   if kit.fourseriesmode
        kit.aonly = 0;
%        kit = dryrunladder(kit);
        kit = alignfs(kit);
        kit.f1f4 = kit.precalcfs(5,1) - kit.precalcfs(5,4);
        kit.a1j = kit.precalcfs(4,1)/(kit.precalcfs(4,1) - kit.precalcfs(3,1));
        kit.a2j = kit.precalcfs(4,4)/(kit.precalcfs(4,4) - kit.precalcfs(3,4));
        
        kit.a1jhigh = kit.precalcfs(6,1)/(kit.precalcfs(6,1) - kit.precalcfs(5,1));
        kit.a2jhigh = kit.precalcfs(6,4)/(kit.precalcfs(6,4) - kit.precalcfs(5,4));
        
        a1bendstring = sprintf('a1diff %3.3f, a1bend %3.3f, a1flex %3.3f J=%1.3f/%1.3f',a1diff,a1bend,a1flex,kit.a1j,kit.a1jhigh);
       a2bendstring = sprintf('a2diff %3.3f, a2bend %3.3f, a2flex %3.3f J=%1.3f/%1.3f',a2diff,a2bend,a2flex,kit.a2j,kit.a2jhigh);

       s1length = min(6,length(kit.series1.allordererrors));
       s1errors = kit.series1.allordererrors(1:s1length);
       s4length = min(6,length(kit.series4.allordererrors));
       s4errors = kit.series4.allordererrors(1:s4length);

       %work out tightness here..

       kit.fulla1string = num2str(s1errors,4);
       kit.fulla2string = num2str(s4errors,4);

       kit.fullerrorstring = sprintf('%s\n%s',kit.fulla1string,kit.fulla2string); 
       kit.a1bendstring = a1bendstring;
       kit.a2bendstring = a2bendstring;
   
    else
%         kit = dryrunaladder(kit);
%         kit.a1j = kit.series1.fs(2) /(kit.series1.fs(2) - kit.series1.fs(1));
%         kit.a2j = kit.series4.fs(2) /(kit.series4.fs(2) - kit.series4.fs(1));
%         
%         kit.a1jhigh = kit.series1.fs(end) /(kit.series1.fs(end) - kit.series1.fs(end-1));
%         kit.a2jhigh = kit.series4.fs(end) /(kit.series4.fs(end) - kit.series4.fs(end-1));
%         f1 = kit.series1.fs(2);
%         ferrs = abs(kit.series4.fs - f1);
%         besti = find(ferrs == min(ferrs),1,'first');
%         f4 = kit.series4.fs(besti);
%         kit.f1f4 = f1-f4;
%         kit.aABCstring = sprintf('[[%3.1f %3.1f %3.1f]]',argsin.molstats.a,argsin.molstats.b,argsin.molstats.c);
    end
   % end
   
%    kit.abendstring = sprintf('%s ==== \n%s ==== \nf1-f4 %3.1f MHz\n%s',kit.a1bendstring,kit.a2bendstring,kit.f1f4,kit.aABCstring);
    save(kit.kitfilename,'kit');
  %  displayserieskit(kit);

function kit = alignfs(kit)  
startline = 0;
numrows = 12;
allfs = zeros(numrows,4);
for i = 1:kit.minserieslength
    % thisf = kit.series1.fs(i);
    thisrow = 3 + i - startline;
    if (thisrow > 0) && (thisrow <= numrows)
        allfs(thisrow,1) = kit.series1.fs(i);
        allfs(thisrow,2) = kit.series2.fs(i);
        allfs(thisrow,3) = kit.series3.fs(i);
        allfs(thisrow,4) = kit.series4.fs(i);
    end
end
kit.f1j = kit.actualj + startline - 1;
kit.precalcfs = allfs;


function s = trimseries(s,numdrop)
s.fs = s.fs(1+numdrop:end);
s.hs = s.hs(1+numdrop:end);
s.numlines = length(s.fs);
newpairs = {};
for i = 1:s.numlines
    newpairs{i} = s.cheat.pairseries{i+numdrop};
end
s.cheat.pairseries = newpairs;
s.cheat.lowestpair = newpairs{1};
s.descriptor = s.cheat.lowestpair.shortdescription;

s = addpolytoseries(s);

function presentclassical(s)
for i = 1:length(s.fs)
    fprintf('%s exact=%3.1f Hz classical=%3.1f Hz\n',s.cheat.pairseries{i}.shortdescription,s.fs(i),s.classicalf(i));
    
    1; %series.cheat.dddd
end
