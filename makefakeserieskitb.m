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

    pgoargsin.molstats = argsin.molstats;
    pgoargsin.maxj = 18;
    %argsin.usepgo = 0;
    pgoargsin.reduceset = 0;
    pgoargsin.maxrf = 0;  %in GHz
    pgoargsin.minrf = 0;
    pgoargsin.maxmw = 32.0;
    pgoargsin.minmw = 1.0;
    pgoargsin.temp = 6;
   % pgoargsin.usespcat = 1;
    [pairlist] = findallpairspgo(pgoargsin);
    
    kit.uniqueid = uniqueid;
    kit.iterid = 1;
    fields = extractfieldsfromcellarray(pairlist,{'delfMHZ','sixKweakpulsestrength'});
    kit.onedpeakfs = fields.delfMHZ;
    kit.onedpeakhs = fields.sixKweakpulsestrength;
    kit.maxh = max(kit.onedpeakhs);
    kit.pairlist = pairlist;
    kit.fakemolname = argsin.fakemolname;
    numpairs = length(pairlist);
    
    allseriesmap = containers.Map;
    allseries = {};
    for i = 1:numpairs
        thispair = pairlist{i};
        if (abs(thispair.delj) <= 1) && (abs(thispair.delka) <= 1) && (abs(thispair.delkc) <= 1)
        
            thisseries = pullseries(pairlist,thispair);
            if thisseries.numlines >= 2 && (thisseries.bpluscguess > 300) && (thisseries.meanh >  kit.maxh/15)
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
%     
%     kit.ichoice = 1;
%     kit.jchoice = 2;
%     numguesses = 0;
%     if argsin.randij == 1
%         ichoice = 0; 
%         jchoice = 0;
%         numseries = length(allseries);
%         while ichoice == jchoice
%             ichoice = 1 + floor(rand() * numseries);
%             jchoice = 1 + floor(rand() * numseries);
%             if1 = kit.allseries{ichoice}.fs(1);
%             if2 = kit.allseries{jchoice}.fs(1);
%             if abs(if1 - if2) < 100 %lines on top of each other, weird choice.
%                 ichoice = 0;
%                 jchoice = 0;
%             end
%             numguesses = numguesses + 1;
%             if numguesses > 1000
%                 fprintf('no compatible series found %d %d %d\n',argsin.molstats.a,argsin.molstats.b,argsin.molstats.c);
%                 error('no compatible series found %d %d %d\n',argsin.molstats.a,argsin.molstats.b,argsin.molstats.c);
%             end
%         end
%         kit.ichoice = ichoice;
%         kit.jchoice = jchoice;
%     end
    
  %  kit.kchoice = 3;
%     
%     seriesi = kit.allseries{kit.ichoice};
%     seriesj = kit.allseries{kit.jchoice};
  %  seriesk = kit.allseries{kit.kchoice};

    cheat.molstats = argsin.molstats;
    cheat.molstring = sprintf('%d: [%3.1f %3.1f %3.1f]',kit.uniqueid,cheat.molstats.a,cheat.molstats.b,cheat.molstats.c);
%    cheat.descriptor = [seriesi.cheat.descriptor ' :: ' seriesj.cheat.descriptor];
    
    kit.cheat = cheat;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    numseries = length(kit.allseries);
for i = 1:numseries
    s = kit.allseries{i};
    if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
        (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj) && (s.cheat.lowestpair.startka == 0)
        series1 = s;
       
    end
    
    if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka ~= 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
        (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj) && (s.cheat.lowestpair.startka == 0)
        series3 = s;
    end
    
    if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka ~= 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
        (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj) && (s.cheat.lowestpair.startka == 1)
        series2 = s;
    end
    
    if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
        (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj) && (s.cheat.lowestpair.startka == 1)
        series4 = s;
    end
end

a1diff = 0;
a2diff = 0;
a1bend = 0;
a2bend = 0;
b1diff = 0;
b2diff = 0;
b1bend = 0;
b2bend = 0;
if length(series1.fs) >= 2
    a1diff = mean(diff(series1.fs));
end

if length(series1.fs) >= 3
    a1bend = mean(diff(diff(series1.fs)));
end
a1bendstring = sprintf('a1diff %3.3f, a1bend %3.3f',a1diff,a1bend);

if length(series2.fs) >= 2
    b1diff = mean(diff(series2.fs));
end

if length(series2.fs) >= 3
    b1bend = mean(diff(diff(series2.fs)));
end

b1bendstring = sprintf('b1diff %3.3f, b1bend %3.3f',b1diff,b1bend);

if length(series4.fs) >= 2
    a2diff = mean(diff(series4.fs));
end

if length(series4.fs) >= 3
    a2bend = mean(diff(diff(series4.fs)));
end
a2bendstring = sprintf('a2diff %3.3f, a2bend %3.3f',a2diff,a2bend);

if length(series3.fs) >= 2
    b2diff = mean(diff(series3.fs));
end

if length(series3.fs) >= 3
    b2bend = mean(diff(diff(series3.fs)));
end
b2bendstring = sprintf('b2diff %3.3f, b2bend %3.3f',b2diff,b2bend);
aamaxerror = a1diff-a2diff;

tightdescriptor = sprintf('%s\n%s\n%s\n%s\naa tolerance %3.1f\n',a1bendstring,a2bendstring,b1bendstring,b2bendstring,aamaxerror);


minjs = [series1.cheat.lowestpair.endj series2.cheat.lowestpair.endj series3.cheat.lowestpair.endj series4.cheat.lowestpair.endj];
bottomj = max(minjs);
numtrim = bottomj - minjs;

series1 = trimseries(series1,numtrim(1));
series2 = trimseries(series2,numtrim(2));
series3 = trimseries(series3,numtrim(3));
series4 = trimseries(series4,numtrim(4));

numlines = [series1.numlines series2.numlines series3.numlines series4.numlines];
numlines = min(numlines);
fprintf('series 1: %s\n',series1.descriptor);
fprintf('series 2: %s\n',series2.descriptor);
fprintf('series 3: %s\n',series3.descriptor);
fprintf('series 4: %s\n',series4.descriptor);
1;


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

bplusc = series1.fs(2) - series1.fs(1);
predictj = series1.fs(1) / bplusc;
actualj= series1.cheat.lowestpair.startj;

kit.numlines = numlines;
kit.series1 = series1;
kit.series2 = series2;
kit.series3 = series3;
kit.series4 = series4;
kit.serieslengths = [length(series1.fs) length(series2.fs) length(series3.fs) length(series4.fs)];
kit.minserieslength = min(kit.serieslengths);
kit.bplusc = bplusc;
kit.f1f3 = f1f3;
kit.f3predict = f3predict;
kit.f3error = f3error;
kit.predictj = predictj;
kit.actualj = actualj;
kit.tightdescriptor = tightdescriptor;

kit.b2bendstring = b2bendstring;

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
    else
        kit.templatemode = 0;
        kit.templateabsolute = zeros(1,50);
        kit.templatenorm = zeros(1,50);
    end
    kit = dryrunladder(kit);
    
    save(kit.kitfilename,'kit');
  %  displayserieskit(kit);


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


