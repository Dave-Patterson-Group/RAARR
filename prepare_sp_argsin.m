function argsout = prepare_sp_argsin

argsout.filename = [getspfitpath '/tempfile4'];
argsout.molstats = loadmol(3); %56 benzonitrile
argsout.molstats.molname = 'unknown';
argsout.molstats.shortname = 'unknown';
argsout.vibstates = 1; 
argsout.spindegeneracy = 1;
argsout.kmin = 0;
argsout.kmax = 99;
argsout.jmin = 0;
argsout.jmax = 30;
argsout.temp = 6;
argsout.intensethresh = -11; %log of intensity threshold
argsout.maxf = 30; % in GHz


end
