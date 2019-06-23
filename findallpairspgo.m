function pairlist = findallpairspgo(argsin)
    if nargin == 0
        argsin.molstats = loadmol(1);
        argsin.maxj = 2;
        argsin.usepgo = 0;
        argsin.reduceset = 0;
        argsin.maxrf = 1.0;  %in GHz
        argsin.minrf = 0;
        argsin.maxmw = 20.0;
        argsin.minmw = 11.0;
        argsin.mindr = 12.0;
        argsin.temp = 6;
        argsin.ferror = 0;
    end
    if isfield(argsin,'ferror') == 0
        argsin.ferror = 0;
    end
    
    argsin.molstats.maxj = argsin.maxj;
    [~,~,hashes, alltransitions] = runpgopherfast(argsin.molstats,argsin.temp);
    
    %convert from alltransitions into pairlist format
    
    pairlist = {};
    h = waitbar(0,'');
    for i = 1:length(alltransitions)
        if mod(i,1000) == 0
            waitbar(i/length(alltransitions),h, sprintf('Making pair %i out of %i',i,length(alltransitions)));
        end
        

        d = hashes(i);
        t = floor(d/1e12);
        d = d - 1e12*t;
        t = floor(d/1e6);
        upperhash = t;
        d = d - 1e6*t;
        lowerhash = d;
        
        starterstate.j = alltransitions(i).Jupper;
        starterstate.ka = alltransitions(i).Kaupper;
        starterstate.kc = alltransitions(i).Kcupper;
        starterstate.m = 0;
        starterstate.energy = alltransitions(i).Eupper;
        starterstate.i = upperhash;

        enderstate.j = alltransitions(i).Jlower;
        enderstate.ka = alltransitions(i).Kalower;
        enderstate.kc = alltransitions(i).Kclower;
        enderstate.m = 0;
        enderstate.energy = alltransitions(i).Elower;
        
        enderstate.i = lowerhash;
        delf = alltransitions(i).freq / 1e3;
        ferror = (rand() - 0.5) * argsin.ferror;
        delf = delf + (ferror/1000);
        thispair.molname = argsin.molstats.molname;
        thispair.molstats = argsin.molstats;
        thispair.delf = delf;
        thispair.delfMHZ = alltransitions(i).freq + ferror;
        thispair.transitiontype = alltransitions(i).type;
        switch thispair.transitiontype
            case 'a'
                thispair.relevantmoment = argsin.molstats.mua;
            case 'b'
                thispair.relevantmoment = argsin.molstats.mub;
            case 'c'
                thispair.relevantmoment = argsin.molstats.muc;
        end
%         thispair.startstate = startstate;
%         thispair.endstate = endstate;
        thispair.minenergy = min([alltransitions(i).Elower alltransitions(i).Eupper] * 4.7992447e-5); %expected in all pairs. 0 for experimental lines. 
        thispair.maxenergy = max([alltransitions(i).Elower alltransitions(i).Eupper] * 4.7992447e-5); % expected in all pairs. 0 for experimental lines.
        thispair.minenergyGHz =  min([alltransitions(i).Elower alltransitions(i).Eupper] * 1e-3);
        thispair.maxenergyGHz = max([alltransitions(i).Elower alltransitions(i).Eupper] * 1e-3);
                                        
        thispair.sixKpop = exp(-thispair.minenergyGHz/(20.83 * 6.0)) * (starterstate.j+1);
        thispair.tenKpop = exp(-thispair.minenergyGHz/(20.83 * 10.0)) * (starterstate.j+1);
        transmoment = sqrt(alltransitions(i).intensity);
        thispair.sixKsatstrength = thispair.sixKpop * (1 - exp(-thispair.delf/(20.83 * 6.0))) * transmoment * 1e6; % potentially dubious
        thispair.sixKweakpulsestrength = thispair.sixKpop * (1 - exp(-thispair.delf/(20.83 * 6.0))) * transmoment * transmoment * 1e12; % potentially dubious
        thispair.scaledsixKweakpulsestrength = thispair.sixKweakpulsestrength * thispair.relevantmoment;
        thispair.tenKsatstrength = thispair.tenKpop * (1 - exp(-thispair.delf/(20.83 * 10.0))) * transmoment; % potentially dubious
        thispair.tenKweakpulsestrength = thispair.tenKpop * (1 - exp(-thispair.delf/(20.83 * 10.0))) * transmoment * transmoment * 1e12; % potentially dubious
        thispair.Avalue = alltransitions(i).Avalue;

        thispair.polarizability = -1e-12; % pgo does not calculate polarizability
        thispair.starterstate = starterstate;
        thispair.enderstate = enderstate;
        thispair.startj = thispair.starterstate.j;
        thispair.startka = thispair.starterstate.ka;
        thispair.startkc = thispair.starterstate.kc;
        thispair.starterhash = (thispair.startj * 10000) + (thispair.startka * 100) + thispair.startkc;
        thispair.endj = thispair.enderstate.j;
        thispair.endka = thispair.enderstate.ka;
        thispair.endkc = thispair.enderstate.kc;
        thispair.enderhash = (thispair.endj * 10000) + (thispair.endka * 100) + thispair.endkc;
        thispair.hash = thispair.enderhash + (1e6 * thispair.starterhash);
        thispair.delj = thispair.endj - thispair.startj;
        thispair.delka = thispair.endka - thispair.startka;
        thispair.delkc = thispair.endkc - thispair.startkc;
        
        startshortstring = sprintf('%i %i %i %i', starterstate.j, starterstate.ka, starterstate.kc, starterstate.m);
        endshortstring = sprintf('%i %i %i %i', enderstate.j, enderstate.ka, enderstate.kc, enderstate.m);
        if isfield(argsin.molstats,'molname') == 0
            argsin.molstats.molname = 'nemo';
        end
        thispair.labelstring = sprintf('%s \n%i %i %i => %i %i %i\n%c-type\n%3.2f MHz', argsin.molstats.molname,...
                            starterstate.j, starterstate.ka, starterstate.kc,...
                            enderstate.j, enderstate.ka, enderstate.kc, thispair.transitiontype,delf * 1000);
        thispair.startshortstring = startshortstring;
        thispair.endshortstring = endshortstring;
        %delf = alltransitions(i).freq / 1e3;
        thispair.shortdescription = sprintf('%s=>%s %c',startshortstring,endshortstring,thispair.transitiontype); %expected in all pairs
      
        thispair = addsemiclassical(thispair);
        
        thispair.matrixel = sqrt(abs(thispair.Avalue/delf^3));% something a and freq ^3
        thispair.selfpolarizability = thispair.matrixel^2/delf;
        thispair.polstring = sprintf('pol: %3.2f',thispair.polarizability*1e12);
        thispair.realf = delf; % expected in all pairs, but delf when no observed lines
        thispair.realinten = transmoment; % expected in all pairs, but transmoment when no observed lines
        thispair.transmoment = transmoment;
        thispair.source = 'home calc pgo only'; %expected in all pairs
        thispair.molstats = argsin.molstats; %expected in all pairs
        thispair.observed = 0; %expected in all pairs
        thispair.autoobserved = 0; %expected in all pairs
        thispair.speciesID = -argsin.molstats.molid; %expected in all pairs. negative if home calculations
        thispair.description = sprintf('%s => %s ~ %3.6f GHz strength %3.2f minenergy %2.6f maxenergy %2.6f pol %3.4f %c',thispair.startshortstring,thispair.endshortstring,thispair.delf,thispair.transmoment*1e6, thispair.minenergy, thispair.maxenergy, thispair.polarizability*1e12,thispair.transitiontype);
        pairlist{end+1} = thispair;
    end
    if isfield(argsin,'maxrf')
        input.min = 0;
        input.max = argsin.maxrf;
        pairlist1 = filterdatabasebyfield(pairlist, 'realf', input);
        
        input.min = argsin.minmw;
        input.max = argsin.maxmw;
        if input.max > 2000
            input.min = input.min/1000;
            input.max = input.max/1000;
        end
        pairlist2 = filterdatabasebyfield(pairlist, 'realf', input);
        pairlist = combinedatabases(pairlist1, pairlist2);
    end
    
    delete(h)


function thispair = addsemiclassical(thispair)
    molstats = thispair.molstats;
    thispair.semistarter = semiclassicaljs(thispair.starterstate,molstats);
    thispair.semiender = semiclassicaljs(thispair.enderstate,molstats);
    thispair.semifreq = abs(thispair.semistarter.energy - thispair.semiender.energy);
    
function semiset = semiclassicaljs(state,molstats)
    semiset.ja = state.ka;
    semiset.jc = state.kc;
    semiset.j = sqrt(state.j * (state.j+1));
    semiset.jb = sqrt(semiset.j^2 - (semiset.ja^2 + semiset.jc^2));
    semiset.exactenergy = state.energy;
    semiset.energy = (molstats.a * semiset.ja^2) + (molstats.b * semiset.jb^2) + (molstats.c * semiset.jc^2);
    