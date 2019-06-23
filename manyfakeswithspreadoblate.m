function manyfakeswithspreadoblate(repeatnum)
spread = 0.6;

%basemolname = 'menthone1';
basemolname = 'oblate';
frange = [10000 20000];
if nargin == 1
    mini = repeatnum;
    maxi = repeatnum;
else
    mini = 100;
    maxi = 100;
end

ts = settingsfromtightness(1);
ts.maxcomponents = 1;
ts.numjguess = 2;
ts.ladderSearchtimes = {[20, 1e-30],[100,1e-20],[500,1e-8],[2000,100]};
ts.maxka = 2;
%kit = autofitladder('Molecules/myrtenal_1d/myrtenal.csv',1,11,ts);
        
for i = mini:maxi
    
        rng(i);
        molstats = loadmol(basemolname);
        molstats = randomizemolecule(molstats,spread,1);
        molstats.frange = frange;
        
        makefakepgofile(molstats, sprintf('fakerng%d',i));
        csvfilename = makefakecsv(molstats);
        try
            presentprimaryladder(molstats,0,1);
        
            kit = autofitladder(csvfilename,0,0,ts);%franges{i});%,tightmodes(i));
             displaybarekit(kit);

            [reportstring] = reportonkit(kit,molstats,i);
            archivetext(reportstring);
            %make pgo file in here at some point? for debugging
            if nargin == 0
                if kit.foundfit == 1
                    delete(csvfilename);
                end

                close all;
            end
        end

end

