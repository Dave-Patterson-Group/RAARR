function [kit,argsin] = makefaketwoserieskit(argsin,uniqueid)
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
kit.uniqueid = uniqueid;
kit.iterid = 1;

    if isfield(argsin,'mwupper') == 0
        argsin.mwupper = 25;
    end
    if isfield(argsin,'mwlower') == 0
        argsin.mwlower = 5;
    end
    if isfield(argsin,'ferror') == 0
        argsin.ferror = 0;
    end
    %argsin.molstats.kalimit = max([argsin.ka1 argsin.ka2]) + 1;  %change for higher series..
    pgoargsin.molstats = argsin.molstats;
    pgoargsin.maxj = 36;
    %argsin.usepgo = 0;
    pgoargsin.reduceset = 0;
    pgoargsin.maxrf = 0;  %in GHz
    pgoargsin.minrf = 0;
    pgoargsin.maxmw = argsin.mwupper;
    pgoargsin.minmw = argsin.mwlower;
    pgoargsin.temp = 6;
    pgoargsin.ferror = argsin.ferror;
   % pgoargsin.usespcat = 1;
    [pairlist] = findallpairspgo(pgoargsin);
    fields = extractfieldsfromcellarray(pairlist,{'delfMHZ','sixKweakpulsestrength'});
    kit.onedpeakfs = fields.delfMHZ;
    kit.onedpeakhs = fields.sixKweakpulsestrength;
    
    argsin.molstats.kalimit = max([argsin.ka1 argsin.ka2]) + 1;  %change for higher series..
    argsin.molstats.mub = 0;
    argsin.molstats.muc = 0; 
    pgoargsin.molstats = argsin.molstats;
    [pairlist] = findallpairspgo(pgoargsin);
    
    
    
    kit.maxh = max(kit.onedpeakhs);
    kit.pairlist = pairlist;
    kit.fakemolname = argsin.fakemolname;
    numpairs = length(pairlist);
    
    allseriesmap = containers.Map;
    allseries = {};
    ka1 = argsin.ka1;
    ka2 = argsin.ka2;
    kit.ka = ka1;
    highside1 = argsin.highside1;
    highside2 = argsin.highside2;
    for i = 1:numpairs
        thispair = pairlist{i};
        if (abs(thispair.delj) == 1) && (abs(thispair.delka) <= 1) && (abs(thispair.delkc) <= 1)
%             if strcmp(thispair.shortdescription(1:6),'3 2 2 ') %0=>2 2 1 0 b')
%                 thispair.shortdescription
%                 1;
%             end

            thisseries = pullseries(pairlist,thispair,argsin.visiblewindow);
            if thisseries.numlines >= 2 && (thisseries.bpluscguess > 300) && (thisseries.meanh >  kit.maxh/55)
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
%     series3.fs = [];
%     series2.fs = [];
    series4.fs = [];
for i = 1:numseries
    s = kit.allseries{i};
    if highside1 == 0
        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
            (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka1) && (s.cheat.lowestpair.startka == ka1)
            series1 = s;
            series1.kstring = sprintf('series1 ka=%d lowside',ka1);
        end
    else
        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
                (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka1) && (s.cheat.lowestpair.startka == 1+ka1)
            series1 = s;
            series1.kstring = sprintf('series1 ka=%d highside',ka1);
            
        end
    end
    if highside2 == 0
        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
                (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka2) && (s.cheat.lowestpair.startka == ka2)
            series4 = s;
            series4.kstring = sprintf('series4 ka=%d lowside',ka2);
        end
    else
        if (s.cheat.lowestpair.delj ~= 0) && (s.cheat.lowestpair.delka == 0) && (s.cheat.lowestpair.delkc ~= 0) && ...
                (s.cheat.lowestpair.startkc == s.cheat.lowestpair.startj-ka2) && (s.cheat.lowestpair.startka == 1+ka2)
            series4 = s;
            series4.kstring = sprintf('series4 ka=%d highside %s',ka2);
        end
    end
end

series1.kstring = sprintf('%s %s',series1.kstring,series1.lowestvisible);
series4.kstring = sprintf('%s %s',series4.kstring,series4.lowestvisible);
kit.highlowstring = sprintf('%s\n%s\nmeasurement error %3.3f MHz',series1.kstring,series4.kstring,argsin.ferror);
series1.ka = ka1;
series4.ka = ka2;
series1.highside = highside1;
series4.highside = highside2;
a1diff = 0;
a2diff = 0;
a2flex = 0;
a1bend = 0;
a1flex = 0;
a2bend = 0;


a1j = series1.fs(1) / (series1.fs(2) - series1.fs(1));
a2j = series4.fs(1) / (series4.fs(2) - series4.fs(1));

fourseriesmode = 0;

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

% a1bendstring = sprintf('a1diff %3.3f, a1bend %3.3f, a1flex %3.3f J=%1.2f',a1diff,a1bend,a1flex,a1j);
% a2bendstring = sprintf('a2diff %3.3f, a2bend %3.3f, a2flex %3.3f J=%1.2f ',a2diff,a2bend,a2flex,a2j);
% aamaxerror = a1diff-a2diff;

    kit.serieslengths = [length(series1.fs) length(series4.fs)];
    kit.plotaonly = 1;

bplusc = series1.fs(2) - series1.fs(1);
predictj = series1.fs(1) / bplusc;

kit.fourseriesmode = fourseriesmode;

%kit.numlines = numlines;
kit.series1 = series1;
kit.series4 = series4;
kit.visiblewindow = argsin.visiblewindow;

kit.allafs = [kit.series1.fs kit.series4.fs];
afs = [];

kit = adds1s4visibles(kit);

kit.minserieslength = min(kit.serieslengths);
kit.predictj = predictj;
kit.bplusc = bplusc;









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
    
    kit.templatemode = 0;
    kit.templateabsolute = zeros(1,50);
    kit.templatenorm = zeros(1,50);
    kit.forcecorners = 0;
    kit.cornermap = 0;
  
   % try
   kit.titlestring = kit.fakemolname;
   
   %     kit = dryrunaladder(kit);
        kit.a1j = kit.series1.fs(2) /(kit.series1.fs(2) - kit.series1.fs(1));
        kit.a2j = kit.series4.fs(2) /(kit.series4.fs(2) - kit.series4.fs(1));
        
        kit.a1jhigh = kit.series1.fs(end) /(kit.series1.fs(end) - kit.series1.fs(end-1));
        kit.a2jhigh = kit.series4.fs(end) /(kit.series4.fs(end) - kit.series4.fs(end-1));
        f1 = kit.series1.fs(2);
        ferrs = abs(kit.series4.fs - f1);
        besti = find(ferrs == min(ferrs),1,'first');
        f4 = kit.series4.fs(besti);
        kit.f1f4 = f1-f4;
       % kit.aABCstring = sprintf('[[%3.1f %3.1f %3.1f]]',argsin.molstats.a,argsin.molstats.b,argsin.molstats.c);
        kit.aABCstring = '[[[0 0 0]]]';
   
   % end
 %  kit = addvisibles(kit);
%   kit = dryrunaladder(kit);
   
   a1bendstring = sprintf('a1diff %3.3f, a1bend %3.3f, a1flex %3.3f J=%1.3f/%1.3f',a1diff,a1bend,a1flex,kit.a1j,kit.a1jhigh);
   a2bendstring = sprintf('a2diff %3.3f, a2bend %3.3f, a2flex %3.3f J=%1.3f/%1.3f,\n mingapoverbend = %3.1f',a2diff,a2bend,a2flex,kit.a2j,kit.a2jhigh,kit.series4.mingapoverbend);

   s1length = min(10,length(kit.series1.allordererrors));
   s1errors = kit.series1.allordererrors(1:s1length);
   s4length = min(10,length(kit.series4.allordererrors));
   s4errors = kit.series4.allordererrors(1:s4length);
   
   %work out tightness here..
   
   kit.fulla1string = sprintf('%s\n%s p=%3.1e',kit.series1.visstring,num2str(s1errors,4),kit.series1.pval);
   kit.fulla2string = sprintf('%s\n%s p=%3.1e',kit.series4.visstring,num2str(s4errors,4),kit.series4.pval);
   kit.gapstring = sprintf('Min s1-s4 gap %3.3f MHz, min gap to spectrum %3.3f MHz',kit.minvisgap,kit.minvisgaptospec);
   if kit.minvisgaptospec < 0.2
       kit.gapstring = sprintf('%s BLENDED',kit.gapstring);
   end
%   kit.fullerrorstring = sprintf('%s A series: %s\n%s\n%s\n%s',kit.fakemolname,kit.aABCerrorstring,kit.fulla1string,kit.fulla2string,kit.gapstring); 
   kit.a1bendstring = a1bendstring;
   kit.a2bendstring = a2bendstring;
%    kit.abendstring = sprintf('%s ==== \n%s ==== \nf1-f4 %3.1f MHz\n%s\n%s',kit.a1bendstring,kit.a2bendstring,kit.f1f4,kit.aABCstring,kit.aABCerrorstring);
    save(kit.kitfilename,'kit');
  %  displayserieskit(kit);

function kit = addvisibles(kit)
    kit.series1 = addseriesvisbles(kit.series1,kit.minwindow,kit.maxwindow);
    kit.series4 = addseriesvisbles(kit.series4,kit.minwindow,kit.maxwindow);




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

function kit = adds1s4visibles(kit)

    kit.visibleafs = sort([kit.series1.visiblefs kit.series4.visiblefs]);
    kit.minvisgap = min(diff(kit.visibleafs));
    kit.series1gap = closesthighseriesneighboor(kit.series1.visiblefs,kit.series1.visiblehs,kit.onedpeakfs,kit.onedpeakhs);
    kit.series4gap = closesthighseriesneighboor(kit.series4.visiblefs,kit.series4.visiblehs,kit.onedpeakfs,kit.onedpeakhs);
    kit.minvisgaptospec = min([kit.series1gap kit.series4gap]);
    1;
    
function fgap = closesthighseriesneighboor(fs,hs,spectrumfs,spectrumhs)
gaps = fs * 0;
  for i = 1:length(fs)
      gaps(i) = closesthighneighboor(fs(i),hs(i),spectrumfs,spectrumhs);
  end
  fgap = min(gaps);
        
function fgap = closesthighneighboor(f,h,spectrumfs,spectrumhs)
    
    thresh = h/2;
    highlines = find(spectrumhs > thresh);
    ferrors = abs(spectrumfs(highlines) - f);
    besti = find(ferrors == min(ferrors),1,'first');
    ferrors(besti) = 1e10;
    fgap = min(ferrors);
    
    
