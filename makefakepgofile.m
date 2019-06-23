function pgofilename = makefakepgofile(molstats,molname)
if nargin == 2
  molstats.molname = molname;
end
if ischar(molstats)
    molname = molstats;
    molstats = loadmol(molstats);
    pgofilename = sprintf('../pgofiles/%s.pgo',molname);
    if length(dir(pgofilename)) > 0
        a = input(sprintf('Warning! %s already exists, enter Y to overwrite',pgofilename));
        if a~= 'Y' && a~= 'y'
            return
        end
    end
else
  pgofilename = fakepgoname(molstats.molname);
end
  makepgofile(molstats,pgofilename,6,'abc');
  fprintf('%s output to %s\n',molstats.molname,pgofilename);
  
  
