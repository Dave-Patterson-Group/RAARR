function reportstring = makefakepaperfigure()

%repeats a specific run.  can be forced to pick the 'right' line via f1, f1
%
%below. 42 specifically is  Menth1 [1220.4 674.0 492.3]
%should return 42 rng CORRECT: Menth1 [1220.4 674.0 492.3] in 40.5 seconds [10000  22000] range 214 upvotes on trial 18
%see manyfakeswithspread(repeatnum) - this is a kind of 'hand build'
%version
i = 42;
f1 = 18; %leave f1 = 0 to try whole spectrum
%f1 = 15639;

        rng(i);
        molstats = loadmol('menthone1');
        molstats = randomizemolecule(molstats,0.6,1);
        molstats.frange = [10000 18000];
        makefakepgofile(molstats, sprintf('fakerng%d',i));
        csvfilename = makefakecsv(molstats);
        kit = autofitladder(csvfilename,0,f1);%franges{i});%,tightmodes(i));
       %  displaybarekit(kit);
        [reportstring] = reportonkit(kit,molstats,i);
       % presentprimaryladder(molstats,0,1);
        disp(reportstring);
        subplot(3,3,[1 2 4 5]);
        legend('unassigned lines','theoretical spectrum','assigned lines')
        title('');
        addtext('A = 1220.4 B = 674.0 C = 492.3 MHz')
        %fix frequency axis to look smart, like '14000 15000 16000'
end

