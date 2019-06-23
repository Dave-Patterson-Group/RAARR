function launchpgopher(molname,conformer)
%typical usage: launchpgopher('nopinone');
if nargin < 2
    conformer = 1;
end

csvfilename = completeFilename(molname);
if length(csvfilename) > 0
     [molname,directoryname] = molnamefromfilename(csvfilename);
     pgofilename = sprintf('%s%s_comp%d.pgo',directoryname,molname,conformer);
     if length(dir(pgofilename)) > 0
         cmdline = ['../pgofiles/pgopher ' pgofilename ' ' csvfilename '&'];
         system(cmdline);
         return
     end
end

molstats =  molstatsfromwhatever(molname);
if isstruct(molname)  %can pass it a kit
    molname = molname.molname;
end

pgofilename = makefakepgofile(molstats, molname);
% pgofilename = sprintf('%s%s_comp%d.pgo',directoryname,molname,conformer);
 pgofilename = fullfilename(pgofilename);
 csvfilename = completeFilename(molname);
 if length(csvfilename) > 0
     [molname,directoryname] = molnamefromfilename(csvfilename);

     csvfilename = fullfilename(csvfilename);
     

     cmdline = ['../pgofiles/pgopher ' pgofilename ' ' csvfilename '&'];
 else
     cmdline = ['../pgofiles/pgopher ' pgofilename ' &'];
 end
system(cmdline);
1;


