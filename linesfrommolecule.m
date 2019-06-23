function [fs,hs] = linesfrommolecule(molstats,visiblewindow)
    if nargin < 2
        visiblewindow = [10000 26000];
    end
    pgoargsin.molstats = molstats;
    pgoargsin.maxj = 26;
    %argsin.usepgo = 0;
    pgoargsin.reduceset = 0;
    pgoargsin.maxrf = 0;
    pgoargsin.maxmw = visiblewindow(2);
    pgoargsin.minmw = visiblewindow(1);
    pgoargsin.temp = 6;
    pgoargsin.ferror = 0;  
    pgoargsin.molstats = molstats;
    
    [pairlist] = findallpairspgo(pgoargsin);
    fields = extractfieldsfromcellarray(pairlist,{'delfMHZ','sixKweakpulsestrength'});
    
    fs = fields.delfMHZ;
    hs = fields.sixKweakpulsestrength;
    
end

