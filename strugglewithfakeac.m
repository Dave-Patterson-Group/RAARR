function reportstring = strugglewithfakeac()

%14218 finds a ladder! although there should be none! this is a clue..
%so does 14421!
f1 = 14218; %leave f1 = 0 to try whole spectrum

        molstats = loadmol('acmenthone');
  %      molstats = randomizemolecule(molstats,0.6,1);
        molstats.frange = [10000 18000];
        makefakepgofile(molstats);
        csvfilename = makefakecsv(molstats);
        kit = autofitladder(csvfilename,0,f1);%franges{i});%,tightmodes(i));
         displaybarekit(kit);
        [reportstring] = reportonkit(kit,molstats);
        presentprimaryladder(molstats,0,1);
        disp(reportstring);

end

