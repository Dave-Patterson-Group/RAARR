function presentprimaryladder(molname,ka1,ka2)
% 
% if nargin == 0
%     molname = 'myrtenalac';
%     actype = 1;
% end
thismol = molstatsfromwhatever(molname);

if nargin == 0
    molname = 'myrtenal';
    actype = 0;
end
if strcmp(thismol.molid(end-1:end),'ac')
    actype = 1;
else
    actype = 0;
end
if nargin < 2
    ka1 = 0;
end


fakeargsin = argsforfakeserieskit(thismol,[9200 18800]);
if nargin < 2
    fakeargsin.mwupper = 28800;
    fakeargsin.mwlower = 8000;
else
    fakeargsin.mwupper = 22000;
    fakeargsin.mwlower = 8000;
end
fakeargsin.actype = actype;

fakeargsin.whichka = ka1;
kit = makefakeserieskit(fakeargsin);


plotprimaryseries(kit);
if nargin == 3
    fakeargsin.whichka = ka2;
    kit = makefakeserieskit(fakeargsin);
    subplot(5,2,[2 8]);
    plotscaffold(kit);
end


function fakeargsin = argsforfakeserieskit(thismol,visiblewindow)
if nargin < 2
    visiblewindow = [7000 22000];
end
if isfield(thismol,'frange')
    visiblewindow = thismol.frange;
end
fakeargsin.actype = 0;
fakeargsin.mwupper = 30;
fakeargsin.mwlower = 6;
fakeargsin.fakemolname = thismol.molname;
fakeargsin.fakemol = 1;
fakeargsin.skiprecommendmolecule = 0;
fakeargsin.randij = 1;
fakeargsin.maxj = 26;
fakeargsin.visiblewindow = visiblewindow;
fakeargsin.cloudkit = 0;
fakeargsin.kitfilename = [getspfitpath() '/fakekit'];
fakeargsin.molstats = thismol;
fakeargsin.distortkit = 0;







