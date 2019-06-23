function kit = presentaseriesladder(molname,ka,verbose)
if nargin < 3
    verbose = 1;
end


if nargin < 2
    ka = 0;
end

if nargin == 0
  molname = 'hexanal1';  
end

spread = 0.0;
thismol = molstatsfromwhatever(molname);
fakeargsin.fakemol = 1;

fakeargsin.skiprecommendmolecule = 0;
fakeargsin.randij = 1;

fakeargsin.cloudkit = 0;
fakeargsin.kitfilename = [getspfitpath() '/fakekit'];

if spread ~= 0
    fakeargsin.fakemolname = ['C13' fakeargsin.fakemolname];
end

fakeargsin.molstats = thismol; %molstats = randomizemolecule(thismol,spread,1);
fakeargsin.fakemolname = fakeargsin.molstats.molname;
fakeargsin.distortkit = 0;
fakeargsin.ferror = 0.00;
fakeargsin.mwupper = 150;

fakeargsin.mwlower = 0;
if isfield(thismol,'visiblewindow')
    fakeargsin.visiblewindow = thismol.visiblewindow;
else
    fakeargsin.visiblewindow = [10000 25000];
end
fakeargsin.ka1 = ka;
fakeargsin.ka2 = ka;
fakeargsin.highside1 = 0;
fakeargsin.highside2 = 1;
fakeargsin.aonly = 1;
kit = makefaketwoserieskit(fakeargsin);
kit.plotaonly = 1;

%kit = scanallseries(kit);

kit = saveAshape(kit,1);

if verbose
  %  figure('Position',[680   200   638   778]);
    kit = fitAshape(kit,1);
  %  precisestickies();
    plottwoserieskit(kit);
end
1;





