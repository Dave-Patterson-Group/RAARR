function peakresults =  findpeakse(freqs,amps,threshsigma,specr)
if (nargin < 3)
    threshsigma = 7;
end
if nargin < 4
    specr = 0.05e6;
end

%first make a version with a flat noise floor

livepoints = find(amps ~= 0);
amps = amps(livepoints);
freqs = freqs(livepoints);

[noisefloors localmeans] = findnoise(amps);

newamps = amps - localmeans;
flatamps = newamps ./ noisefloors;
flatamps = flatamps - (min(flatamps) * 1.001);
figure;
subplot(2,1,1);

plot(freqs,amps,'b');
hold all;
plot(freqs,noisefloors,'r');
plot(freqs,noisefloors+localmeans,'g');
subplot(2,1,2);

plot(freqs,flatamps,'b');

peakresults =  findpeaksd(freqs,flatamps,threshsigma,specr);
%now correct by noisefloor - peak heights should be downrated by noisefloor
peakresults.allpeaks = 0;
for i = 1:length(peakresults.freqs)
    thisf = peakresults.freqs(i);
    thisnoise = interp1(freqs,noisefloors,thisf);
    peakresults.exacths(i) = peakresults.exacths(i)/thisnoise;
end
1;

function [noisefloors localmeans] = findnoise(amps)
npoints = 5000;
i = npoints/2;
noisefloors = amps * 0;
localmeans = amps * 0;
while i < length(amps)
    firstp = max(1,i-(npoints/2));
    lastp = min(length(amps),i+(npoints/2));
    if (lastp-firstp) < npoints/4
        break;
    end
    thesepoints = firstp:lastp;
    theseamps = amps(firstp:lastp);
    [nf localmean] = noisefloor(theseamps);
    noisefloors(thesepoints) = nf;
    localmeans(thesepoints) = localmean;
    i = i + npoints/2;
end
noisefloors = smooth(noisefloors,npoints*2);
localmeans = smooth(localmeans,npoints*2);

function [nf localmean] = noisefloor(theseamps)
    mvalue = median(theseamps);
    
    theseamps(theseamps > (mvalue * 5)) = mvalue;
    nf = std(theseamps - mvalue);
    localmean = mean(theseamps);

    