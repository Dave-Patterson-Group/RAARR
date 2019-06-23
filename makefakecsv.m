function [csvfilename,freqs,amps] = makefakecsv(molname,perfection)

if nargin == 0
  molname = 'menthone1';
end

if nargin < 2
  perfection = 0;
end

thismol = molstatsfromwhatever(molname);

csvfilename = fakecsvname(thismol.molname,perfection);
if perfection
   argsin = perfectcsvargsin(); 
else
    argsin = defaultcsvargsin();
end
if isfield(thismol,'frange')
    argsin.visiblewindow = thismol.frange;
end
argsin.molstats = thismol;
[freqs,amps] = buildfakespectrum(argsin);

savecsv(freqs,amps,csvfilename)



function [freqs,amps] = buildfakespectrum(argsin)
freqs = argsin.visiblewindow(1):argsin.resolution:argsin.visiblewindow(2);

[realfs,realhs] = linesfrommolecule(argsin.molstats,argsin.visiblewindow);
realfs = adjustfs(realfs,argsin.ferror);
realhs = adjusths(realhs,argsin.herror);

%[realfs,realhs] = makeuplines(realfs,realhs,argsin);
size(realfs)
[realfs,realhs] = makeuplines(realfs,realhs,argsin);
size(realfs)
%line here to add artificial lines by copying these ones randomly
noiselessspectrum = constructspectrum(freqs,realfs,realhs,argsin.linewidth);

noiselevel = max(noiselessspectrum) / argsin.SNR;
noise = normrnd(0,noiselevel,size(freqs));
amps = noiselessspectrum + noise;
amps = argsin.maxlevel * amps / max(amps);
1;

function [fs,hs] = makeuplines(fs,hs,argsin)
dopplesizes = argsin.dopplesizes;
doppledist = argsin.doppledist;
numoriginal = length(fs);
% fs(numoriginal * (numdopples+1)) = 0;
% hs(numoriginal * (numdopples+1)) = 0;
thisline = numoriginal + 1;
minf = min(fs) + 100;
maxf = max(fs) - 100;
for i = 1:numoriginal
    thisf = fs(i);
    thish = hs(i);
    for j = 1:length(dopplesizes)
        newf = thisf + (randn()*doppledist);
        newh = thish * rand() * dopplesizes(j);
        if (newf > minf) && (newf < maxf)
            if rand() < argsin.dopplefrac
                fs(end+1) = newf;
                hs(end+1) = newh;
            
                thisline = thisline+1;
            end
        end
    end
end
[fs XI] = sort(fs);
hs = hs(XI);
1;


function amps = constructspectrum(freqs,realfs,realhs,linewidth)
amps = freqs * 0;
localfs = -7 * linspace(-linewidth,linewidth,100);
localhs = (1 / (4 * pi)) * exp(-(localfs/linewidth).^2)/linewidth;

for i = 1:length(realfs)
    f = realfs(i);
    h = realhs(i);

    [irange,detunings] = findrange(freqs,f,linewidth);
    newpoints = h * interp1(localfs,localhs,detunings,'linear','extrap');
    amps(irange) = amps(irange) + newpoints;
    1;
end
a = isnan(amps);
amps(a == 1) = 0;

function [irange,detunings] = findrange(freqs,f,linewidth)
[centeri centerf] = findbestf(freqs,f);

delf = freqs(2) - freqs(1);
ispan = floor(5*linewidth/delf);
mini = max(1,centeri - ispan);
maxi = min(length(freqs),centeri + ispan);
irange = mini:maxi;
detunings = freqs(irange) - f;



function [i,f] = findbestf(freqs,f)
%returns the index and frequency of the closest point in freqs to f
delf = freqs(2) - freqs(1);
relativef = f - freqs(1);
iguess = relativef / delf;
guess1 = floor(iguess);

if guess1 < 1
    i = 1;
    f = freqs(i);
    return
end
if guess1 > length(freqs)
    i = length(freqs);
    f = freqs(i);
    return
end
i = guess1;
f = freqs(i);


function hs = adjusths(hs,herror)    
    hs = hs .* exp(normrnd(0,herror,size(hs)));
    
function fs = adjustfs(fs,ferror)    
    fs = fs + normrnd(0,ferror,size(fs));

function csvargsin = perfectcsvargsin()
csvargsin.resolution = 0.05;
csvargsin.linewidth = 0.06;
csvargsin.dopplesizes = [];
csvargsin.doppledist = 2000;
csvargsin.dopplefrac = 0;
csvargsin.ferror = 0.000;  %additional errors from noise will emerge
csvargsin.herror = 0.0;  %fractional error. errors of about exp(herror) are normal./
csvargsin.visiblewindow = [10000 20000];
csvargsin.maxlevel = 5000;
csvargsin.SNR = 10000;

function csvargsin = defaultcsvargsin()
csvargsin.resolution = 0.05;
csvargsin.linewidth = 0.06;
csvargsin.dopplesizes = [.2 .1 .05 .05 .03 .02 .01 .01 .01 .01 .01 .01];
csvargsin.doppledist = 2000;
csvargsin.dopplefrac = 1;
csvargsin.ferror = 0.005;  %additional errors from noise will emerge
csvargsin.herror = 1.0;  %fractional error. errors of about exp(herror) are normal./
csvargsin.visiblewindow = [10000 20000];
csvargsin.maxlevel = 5000;
csvargsin.SNR = 1000;
