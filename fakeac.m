function fakeac(repeatnum)
spread = 0.6;

%basemolname = 'menthone1';
%basemolname = 'myrtenalac';
basemolname = 'weirdac';
frange = [10000 20000];
if nargin == 1
    mini = repeatnum;
    maxi = repeatnum;
else
    mini = 100;
    maxi = 110;
end

ts = settingsfromtightness(1);
ts.maxcomponents = 1;
ts.numjguess = 2;
ts.ladderSearchtimes = {[20, 1e-30],[100,1e-20],[500,1e-8],[2000,100]};
ts.maxka = 2;
%kit = autofitladder('Molecules/myrtenal_1d/myrtenal.csv',1,11,ts);
pvals = [];  
numtry = 1;
for i = 1:numtry
    rng(i);
molstats = loadmol(basemolname);
molstats = randomizemolecule(molstats,spread,1);
molstats.frange = frange;

pgofilename = makefakepgofile(molstats, sprintf('fakerng%d',i));
csvfilename = makefakecsv(molstats);
%     try
%presentprimaryladder(molstats,0);
ts = settingsfromtightness(1);
ts.patternfitting.actypes = [1]; 
ts.minpval = 1e-8;
ts.evolveFit = 0;
ts.addisotopes = 0;
ts.patternfitting.maxpatterns = 1;
    [kit] = autofit(csvfilename,'scaffold',0,1,ts);%franges{i});%,tightmodes(i));
    if isstruct(kit.latestpattern)
        pvals(end+1) = kit.latestpattern.pval;
%         showseriessquare(kit.latestpattern.archive);
%         cmdline = ['../pgofiles/pgopher ' pgofilename ' ' csvfilename '&'];
%         system(cmdline);
    end
end
fprintf('found %d out of %d\n', length(pvals),numtry);
disp(pvals);
