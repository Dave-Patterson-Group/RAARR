function allpairs = loadlinelistspcat(argsin,filename)

allpairs = {};
molstats = argsin.molstats;

for types = ['a' 'b' 'c']
    catcsvfilename = [filename types '_cat.csv'];
    strcsvfilename = [filename types '_str.csv'];
    
    f = fopen(catcsvfilename);
    g = fopen(strcsvfilename);
    
    %extract from cat csv
    C = textscan(f, '%f %f %f %u %f %u %u %u %u %u %u %u %u %u %u %u %u %u %u %u','Delimiter',','); 

    freqs = C{1}; % in MHz
    errors = C{2};
    logintensity = C{3}; % in units of nm^2 MHz
    degreesoffreedom = C{4}; % 0 for atoms, 2 for linear molecules, 3 for nonlinear
    energylower = C{5}; % energy of lower state in wavenumbers
    upperdegeneracy = C{6}; % upper state degeneracy
    speciesID = C{7}; % species identifier. If in loadmol, it is negative of molID
    qnfmt = C{8}; % quantum number format, refer to documentation
    Jupper = C{9}; % upper state J
    Kaupper = C{10}; % upper state Ka
    Kcupper = C{11}; % upper state Kc
    qn4upper = C{12}; % for our purposes, meaningless, be careful, NaN imports as 0
    qn5upper = C{13}; % for our purposes, meaningless, be careful, NaN imports as 0
    qn6upper = C{14}; % for our purposes, meaningless, be careful, NaN imports as 0
    Jlower = C{15}; % lower state J
    Kalower = C{16}; % lower state Ka
    Kclower = C{17}; % lower state Kc
    qn4lower = C{18}; % for our purposes, meaningless, be careful, NaN imports as 0
    qn5lower = C{19}; % for our purposes, meaningless, be careful, NaN imports as 0
    qn6lower = C{20}; % for our purposes, meaningless, be careful, NaN imports as 0

    if (isfield(molstats,'conformer') == 0)
        molstats.conformer = 1;
    end
    hashes = molstats.conformer * 1e13 + (1e10*cast(Jupper,'int64')) + (1e8*cast(Kaupper,'int64')) + ...
        (1e6 *cast(Kcupper,'int64')) + (1e4 * cast(Jlower,'int64')) + ...
        (1e2 * cast(Kalower,'int64')) + cast(Kclower,'int64');
    
    % extract from str csv, for matrix element
    D = textscan(g,'%f %f %u %u %u %u %u %u %u %u %u %u %u %u %u %u','Delimiter',',');
    
    freqs_str = D{1};
    matrix_el = D{2};
    qnfmt_str = D{3};
    Jupper_str = D{4}; % upper state J
    Kaupper_str = D{5}; % upper state Ka
    Kcupper_str = D{6}; % upper state Kc
    qn4upper_str = D{7}; % for our purposes, meaningless, be careful, NaN imports as 0
    qn5upper_str = D{8}; % for our purposes, meaningless, be careful, NaN imports as 0
    qn6upper_str = D{9}; % for our purposes, meaningless, be careful, NaN imports as 0
    Jlower_str = D{10}; % lower state J
    Kalower_str = D{11}; % lower state Ka
    Kclower_str = D{12}; % lower state Kc
    qn4lower_str = D{13}; % for our purposes, meaningless, be careful, NaN imports as 0
    qn5lower_str = D{14}; % for our purposes, meaningless, be careful, NaN imports as 0
    qn6lower_str = D{15}; % for our purposes, meaningless, be careful, NaN imports as 0
    dipole_number = D{16}; %unclear what this means...
    
    hashes_str = molstats.conformer * 1e13 + (1e10*cast(Jupper_str,'int64')) + (1e8*cast(Kaupper_str,'int64')) + ...
        (1e6 *cast(Kcupper_str,'int64')) + (1e4 * cast(Jlower_str,'int64')) + ...
        (1e2 * cast(Kalower_str,'int64')) + cast(Kclower_str,'int64');

   % h = waitbar(0,'');

    for i = 1:length(freqs)
%         if mod(i,100) == 1
%             waitbar(i/length(freqs), h, sprintf('Making Pair %i out of %i (SPCAT)', i, length(freqs)));
%         end

        d = hashes(i);
        t = floor(d/1e12);
        d = d - 1e12*t;
        t = floor(d/1e6);
        upperhash = t;
        d = d - 1e6*t;
        lowerhash = d;

        starterstate.j = double(Jupper(i));
        starterstate.ka = double(Kaupper(i));
        starterstate.kc = double(Kcupper(i));
        starterstate.m = 0;
        starterstate.i = upperhash;

        enderstate.j = double(Jlower(i));
        enderstate.ka = double(Kalower(i));
        enderstate.kc = double(Kclower(i));
        enderstate.m = 0;
        enderstate.i = lowerhash;

        thispair.transitiontype = types;
        delf = freqs(i)/1e3;
        thispair.delf = delf; % in GHz
%         thispair.startstate = startstate;
%         thispair.endstate = endstate; 
        thispair.minenergy = energylower(i) * 1.42879; %in K, expected in all pairs. 0 for experimental lines. 
        thispair.maxenergy = thispair.minenergy + (freqs(i) / 1e3) / 20.8364; % expected in all pairs. 0 for experimental lines.
        thispair.minenergyGHz =  thispair.minenergy * 20.8364;
        thispair.sixKpop = exp(-thispair.minenergyGHz/(20.83 * 6.0)) * (starterstate.j+1);
        thispair.tenKpop = exp(-thispair.minenergyGHz/(20.83 * 10.0)) * (starterstate.j+1);
        transmoment = sqrt(10^(logintensity(i))) / sqrt(thispair.delf);
        thispair.sixKsatstrength = thispair.sixKpop * (1 - exp(-thispair.delf/(20.83 * 6.0))) * transmoment * 1e6; % potentially dubious
        thispair.sixKweakpulsestrength = thispair.sixKpop * (1 - exp(-thispair.delf/(20.83 * 6.0))) * transmoment * transmoment * 1e12; % potentially dubious
        thispair.tenKsatstrength = thispair.tenKpop * (1 - exp(-thispair.delf/(20.83 * 10.0))) * transmoment; % potentially dubious
        thispair.tenKweakpulsestrength = thispair.tenKpop * (1 - exp(-thispair.delf/(20.83 * 10.0))) * transmoment * transmoment * 1e12; % potentially dubious
%         thispair.Avalue = alltransitions(i).Avalue;

        thispair.polarizability = -1e-12; % pgo does not calculate polarizability
        thispair.starterstate = starterstate;
        thispair.enderstate = enderstate;
        thispair.startj = thispair.starterstate.j;
        thispair.startka = thispair.starterstate.ka;
        thispair.startkc = thispair.starterstate.kc;
        thispair.endj = thispair.enderstate.j;
        thispair.endka = thispair.enderstate.ka;
        thispair.endkc = thispair.enderstate.kc;
        thispair.delj = thispair.endj - thispair.startj;
        thispair.delka = thispair.endka - thispair.startka;
        thispair.delkc = thispair.endkc - thispair.startkc;
        
        startshortstring = sprintf('%i %i %i %i', starterstate.j, starterstate.ka, starterstate.kc, starterstate.m);
        endshortstring = sprintf('%i %i %i %i', enderstate.j, enderstate.ka, enderstate.kc, enderstate.m);
        thispair.startshortstring = startshortstring;
        thispair.endshortstring = endshortstring;
        %delf = alltransitions(i).freq / 1e3;
        thispair.shortdescription = sprintf('%s=>%s %c',startshortstring,endshortstring,thispair.transitiontype); %expected in all pairs
        thispair.polstring = sprintf('pol: %3.2f',thispair.polarizability*1e12);
 
        thispair.matrixel = matrix_el(hashes_str == hashes(i));% something a and freq ^3
        thispair.selfpolarizability = thispair.matrixel^2/delf;
        thispair.realf = delf; % expected in all pairs, but delf when no observed lines
        thispair.realinten = transmoment; % expected in all pairs, but transmoment when no observed lines
        thispair.transmoment = transmoment;
        thispair.source = 'home calc spcat only'; %expected in all pairs
        thispair.molstats = argsin.molstats; %expected in all pairs
        thispair.observed = 0; %expected in all pairs
        thispair.autoobserved = 0; %expected in all pairs
        thispair.speciesID = speciesID(i); %expected in all pairs. negative if home calculations
        thispair.description = sprintf('%s => %s ~ %3.6f GHz strength %3.2f minenergy %2.6f maxenergy %2.6f pol %3.4f %c',thispair.startshortstring,thispair.endshortstring,thispair.delf,thispair.transmoment*1e6, thispair.minenergy, thispair.maxenergy, thispair.polarizability*1e12,thispair.transitiontype);
        allpairs{end+1} = thispair;
    end
   % delete(h);
    fclose(f);
    fclose(g);
end

allpairs = sortstructcellarraybyfield(allpairs, 'realf');

end