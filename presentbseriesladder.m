function kit = presentbseriesladder(molname,ka,verbose)
if nargin < 3
    verbose = 1;
end


if nargin < 2
    ka = 0;
end

if nargin == 0
  molname = [5000 2000 1500];  
end

spread = 0.0;
thismol = molstatsfromwhatever(molname);
c = thismol.c;
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
fakeargsin.aonly = 1;
kit = makefakebserieskit(fakeargsin);



s4 = kit.series4;
intercept = s4.fs(end) - (2 * c * s4.jvalues(end));
slope = (s4.fs(end) - s4.fs(end-1))/(2 * c);
fprintf('%s [%3.1f %3.1f %3.1f] intercept %3.1f slope %f/2c\n',s4.cheat.descriptor,thismol.a,thismol.b,thismol.c,intercept,slope);
1;
% pattern = patternfromkit(kit,[1 0]);
% patternlist{1} = pattern;
% newfit = trypatterns(kit,patternlist);
% disp(newfit.shortdescriptor);
% 1;

% kit.plotaonly = 1;
% 
% %kit = scanallseries(kit);
% 
% kit = saveAshape(kit,1);
kit = saveBshape(kit,1);
if verbose
  %  figure('Position',[680   200   638   778]);
  %  kit = fitAshape(kit,1);
  %  precisestickies();
    plottwoserieskit(kit);
end
1;

function p = patternfromkit(kit,whichload)
if nargin == 2
    whichload = [1 1];
end
fgrid = zeros(20,4);
if whichload(1)
    s = kit.series1;
    for i = s.visibleis
        j = s.jvalues(i);
        f = s.fs(i);
        if (j > 0)
            fgrid(j,3) = f;
        end
    end
end
if whichload(2)
    s = kit.series4;
    for i = s.visibleis
        j = s.jvalues(i);
        f = s.fs(i);
        if (j > 0)
            fgrid(j,2) = f;
        end
    end
end
p.fgrid = fgrid;
p.pval = 1e-100;
p.patternType = 'btype';
p.archive = kit;
p.descriptor = 'fake b type';

% pattern.fgrid = scaffold.usablefgrid;    %an [nx4] matrix with series1,series2,series3,series4 in it. Can have any offset; zeros are read as 'unknown'
%     pattern.pval = scaffold.netpval;    %an estimate of how likely it was this pattern was coincidence.
%     pattern.patternType = 'scaffold';   %this would be `doubleBowTie' for variant 2, or 'atypes' for variant 3
%     pattern.archive = scaffold;  %the full structure handed down from runvariant1. Keeping this is dangerous - lets me debug, also lets me cheat.
%     pattern.descriptor 




