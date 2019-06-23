function [allpairs trianglelist drlist] = findalltriangles(argsin)
if nargin == 0
    argsin.molstats = loadmol('menthone2');
    argsin.maxj = 12;
    argsin.usepgo = 0;
    argsin.reduceset = 0;
    argsin.maxrf = 1.0;  %in GHz
    argsin.minrf = 0;
    argsin.maxmw = 20.0;
    argsin.minmw = 11.0;
    argsin.mindr = 12.0;
    argsin.temp = 6;
    argsin.finddrs = 1;
    argsin.usespcat = 1;
end

if isfield(argsin, 'skiptrips') == 0
    argsin.skiptrips = 0;
end

if isfield(argsin, 'usespcat') && argsin.usespcat == 1
    nmolstats = argsin.molstats;
    nmolstats.a = argsin.molstats.a / 1000;
    nmolstats.b = argsin.molstats.b / 1000;
    nmolstats.c = argsin.molstats.c / 1000;
    nmolstats.DJ = argsin.molstats.DJ / 1000;
    nmolstats.DJK = argsin.molstats.DJK / 1000;
    nmolstats.DK = argsin.molstats.DK / 1000;
    nmolstats.deltaJ = argsin.molstats.deltaJ / 1000;
    nmolstats.deltaK = argsin.molstats.deltaK / 1000;
    
    argsin_spcat.filename = '.\spfitstuff\tempfile2';
    argsin_spcat.molstats = nmolstats; %56 benzonitrile
    argsin_spcat.vibstates = 1; 
    argsin_spcat.spindegeneracy = 1;
    argsin_spcat.kmin = 0;
    argsin_spcat.kmax = 99;
    argsin_spcat.jmin = 0;
    argsin_spcat.jmax = argsin.maxj;
    argsin_spcat.temp = argsin.temp;
    argsin_spcat.intensethresh = -11; %log of intensity threshold
    argsin_spcat.maxf = argsin.maxmw; % in GHz
    pairlist = runspcat(argsin_spcat);
else
    if argsin.usepgo == 1
        [pairlist] = findallpairspgo(argsin);
    else
        [pairlist] = findallpairs(argsin);
    end
end
if isfield(argsin, 'calcpolarizability') && argsin.calcpolarizability == 1
    pairlist = addpolarizabilitypairlist(pairlist);
end

%pairlist = finddrbystate(pairlist,argsin);

disp('here');
mwpairs = trimpairs(pairlist,argsin.minmw,argsin.maxmw);
rfpairs = trimpairs(pairlist,0,argsin.maxrf);
allpairs = [rfpairs mwpairs];
trianglelist = {};
drlist = {};
numpairs = length(allpairs);
%now find drs
for i = 1:numpairs
    ipair = allpairs{i};
    ipair.drlist = {};
    ipair.pairDRstring = 'No Drs';
    allpairs{i} = ipair;
end

if argsin.finddrs
    
    w = waitbar(0,'');
    
    for i = 1:numpairs
        waitbar(i/numpairs,w,sprintf('Checking for DR (going strong): %i out of %i',i, numpairs))
        ipair = allpairs{i};
        pairDRstring = '';
        idrs = {};
        for j = 1:numpairs
            jpair = allpairs{j};
            if isconnected(ipair,jpair)
                istriple = 0;
                trippair = 0;
                triple = ' ';
                if argsin.skiptrips == 0
                    for k = 1:numpairs
                        kpair = allpairs{k};
                        if isconnected(ipair,kpair) && isconnected(jpair,kpair)
                            fs = [ipair.delf jpair.delf kpair.delf];
                            [sortf whichi] = sort(fs);
                            ferror = abs(sortf(1) + sortf(2) - sortf(3));
                            if ferror < 1e-2
                                istriple = 1;
                                triple = 'T';
                                kpair.drlist = {}; %saves huge recursion
                                trippair = kpair;
                            end
                        end
                    end
                end
                thepairs = [ipair jpair];
                fs = [ipair.delf jpair.delf];
                [sortf whichi] = sort(fs);
                
                thisdr.fs = sortf;
                
                lowpair = thepairs(whichi(1));
                
                highpair = thepairs(whichi(2));
                start1 = highpair.starterstate.i;
                end1 = highpair.enderstate.i;
                start2 = lowpair.starterstate.i;
                end2 = lowpair.enderstate.i;
                if start2 == end1
                    thisdr.midstate = highpair.enderstate;
                    thisdr.outerstate1 = highpair.starterstate;
                    thisdr.outerstate2 = lowpair.enderstate;
                end
                if start1 == end2
                    thisdr.midstate = highpair.starterstate;
                    thisdr.outerstate1 = highpair.enderstate;
                    thisdr.outerstate2 = lowpair.starterstate;
                end
                if start1 == start2
                    thisdr.midstate = highpair.starterstate;
                    thisdr.outerstate1 = highpair.enderstate;
                    thisdr.outerstate2 = lowpair.starterstate;
                end
                if end1 == end2
                    thisdr.midstate = highpair.enderstate;
                    thisdr.outerstate1 = highpair.starterstate;
                    thisdr.outerstate2 = lowpair.starterstate;
                end
                
                lowpair.drlist = {};
                highpair.drlist = {};
                thisdr.minf = sortf(1);
                thisdr.maxf = sortf(2);
                thisdr.trippair = trippair;
                thisdr.istriple = istriple;
                thisdr.rfd = lowpair.transmoment;
                thisdr.lowpair = lowpair;
                thisdr.highpair = highpair;
                thisdr.moments = [lowpair.transmoment highpair.transmoment];
                thisdr.minmoment = min(thisdr.moments);
                if thisdr.minmoment < 1e-6
                    thisdr.strong = 0;
                else
                    thisdr.strong = 1;
                end
                isV = 0;
                vchar = '/';
                maxlow = thisdr.lowpair.maxenergyGHz;
                minlow = thisdr.lowpair.minenergyGHz;
                maxhigh = thisdr.highpair.maxenergyGHz;
                minhigh = thisdr.highpair.minenergyGHz;
                thresh = 0.00002;
                if abs(maxlow - maxhigh) < thresh
                    isV = 1;
                    vchar = 'V';
                   
                end
                if abs(minlow - minhigh) < thresh
                    isV = 1;
                    vchar = 'V';
                end
                thisdr.isV = isV;
                thisdr.vchar = vchar;
                thisdr.twistd = thisdr.lowpair.transmoment;
                thisdr.listend =  thisdr.highpair.transmoment;
                thisdr.shortdescription = sprintf('twist %3.4f listen %3.4f %s%s\n',thisdr.lowpair.delf,thisdr.highpair.delf,vchar,triple);
                thisdr.middescription = sprintf('twist %3.5f listen %3.5f %s%s\n%s %3.1fS\n%s  %3.1fS',thisdr.lowpair.delf,thisdr.highpair.delf,vchar,triple,thisdr.lowpair.shortdescription,thisdr.lowpair.transmoment*1e3,thisdr.highpair.shortdescription,thisdr.highpair.transmoment*1e3);
                thisdr.longdescription = sprintf('%s double resonance: %s%s\n twist %s\n listen %s\n',argsin.molstats.molname,vchar,triple,thisdr.lowpair.description,thisdr.highpair.description);
                if triple == 'T'
                    thisdr.middescription;
                end
                ispossible = 1;
                if thisdr.minf < argsin.mindr
                    ispossible = 0;
                end
                if thisdr.maxf > argsin.maxmw
                    ispossible = 0;
                end
                thisdr.ispossible = ispossible;
                if i ~= j
                    thisdr.otherpair = litepair(jpair);
                    thisdr.otherfreq = jpair.delf;
                    thisdr.othertype = jpair.transitiontype;
                    thisdr.otherstrength = jpair.transmoment;
                    
                %    thisdr.otherpair = jpair;
                    pairDRstring = sprintf('%s %f:%c%c,',pairDRstring,thisdr.otherfreq,thisdr.othertype,thisdr.vchar);
                    idrs{end+1} = thisdr;
                end
                if j > i
                    drlist{end+1} = thisdr;
                end
                
            end
        end
        ipair.drlist = idrs;
       % iipair = ipair;
        ipair.pairDRstring = pairDRstring;
        allpairs{i} = ipair;
    end
    
    delete(w);
end
%%cowcow!
%drlist = {};
numrf = length(rfpairs);
nummw = length(mwpairs);
b = waitbar(0,'');
for i = 1:numrf
    waitbar(i/numrf, b, sprintf('Checking for triangles (Does it ever end...), RF: %i out of %i', i, numrf))
    ipair = rfpairs{i};
    for j = 1:nummw
        jpair = mwpairs{j};
        if isconnected(ipair,jpair)
            for k = j+1:nummw
                kpair = mwpairs{k};
                if isconnected(ipair,kpair) && isconnected(jpair,kpair)
                    thepairs = [ipair jpair kpair];
                    fs = [ipair.delf jpair.delf kpair.delf];
                    [sortf whichi] = sort(fs);
                    ferror = abs(sortf(1) + sortf(2) - sortf(3));
                    if ferror < 0.001
                        thistriangle.fs = sortf;
                        
                        lowpair = thepairs(whichi(1));
                        midpair = thepairs(whichi(2));
                        highpair = thepairs(whichi(3));
                        thistriangle.midpair = midpair;
                        thistriangle.highpair = highpair;
                        thistriangle.moments = [lowpair.transmoment midpair.transmoment highpair.transmoment];
                        thistriangle.ferror = ferror;
                        thistriangle.minf = sortf(1);
                        thistriangle.maxf = sortf(2);
                        thistriangle.rfd = lowpair.transmoment;
                        thistriangle.lowpair = lowpair;
                        if midpair.transmoment < highpair.transmoment
                            thistriangle.drivepair = midpair;
                            thistriangle.listenpair = highpair;
                        else
                            thistriangle.drivepair = highpair;
                            thistriangle.listenpair = midpair;
                        end
                        thistriangle.drived = thistriangle.drivepair.transmoment;
                        thistriangle.listend =  thistriangle.listenpair.transmoment;
                        thistriangle.shortdescription = sprintf('push %3.6f twist %3.6f listen %3.6f',thistriangle.drivepair.delf,thistriangle.lowpair.delf,thistriangle.listenpair.delf);
                        
                        thistriangle.longdescription = sprintf('%s triangle:\n push   %s\n twist  %s\n listen %s',argsin.molstats.molname,thistriangle.drivepair.description,thistriangle.lowpair.description,thistriangle.listenpair.description);
                        ispossible = 1;
                        thistriangle.isweird = 0;
                        if ispairweird(lowpair) || ispairweird(midpair) || ispairweird(highpair)
                            thistriangle.isweird = 1;
                            ispossible = 0;
                        end
                        if thistriangle.minf < argsin.minrf
                            ispossible = 0;
                        end
                        if thistriangle.minf > argsin.maxrf
                            ispossible = 0;
                        end
                        if thistriangle.maxf > argsin.maxmw
                            ispossible = 0;
                        end
                        thistriangle.ispossible = ispossible;
                        trianglelist{end+1} = thistriangle;
                    end
                end
            end
        end
    end
end
delete(b);

function yesorno = ispairweird(pair)
yesorno = 0;
    delka = abs(pair.startka - pair.endka);
    delj = abs(pair.startj - pair.endj);
    delkc = abs(pair.startkc - pair.endkc);
    if (delj >= 2) || (delka >= 2) || (delkc >= 2)
        yesorno = 1;
    end
    1;


%listtriangles(trianglelist);





