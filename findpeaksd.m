function peakresults =  findpeaksd(newf,finalspec,threshsigma,specr)
if (nargin < 3)
    threshsigma = 7;
end
if nargin < 4
    specr = 0.05e6;
end
freqs = [];
sigheights = [];
%specr = 0.05e6;  %spectral resolution; closest lines.  Maybe make 
%eventually compare to a PGOPHER line list out, lifted from grotrian code.
%Eventually eventually do some fitting..

%save(newfilename,'newf','finalspec','bigspecvals');
%load(bigspecfilename);

livepoints = find(finalspec ~= 0);
finalspec = finalspec(livepoints);
newf = newf(livepoints);
nsmooth = floor(1 + (specr / (newf(2) - newf(1))));
%nsmooth

smoothspec = smooth(finalspec,nsmooth);


rawdata = smoothspec(find(smoothspec > 0));
rawmedian = median(rawdata);
zeropoints = rawdata(find(rawdata < rawmedian*2));
% rawstd = std(smoothspec);
% rawmean = mean(smoothspec);
% smoothspec(smoothspec < (rawmean - (2 * rawstd))) = rawmean;
% smoothspec = smooth(smoothspec,nsmooth);
% trimmedspec = smoothspec;
% trimmedspec(trimmedspec > (rawmean + (2 * rawstd))) = rawmean;
% trimmedspec(trimmedspec < (rawmean - (2 * rawstd))) = rawmean;
% 
% absspec = abs(finalspec);
% m = median(absspec);
% absspec(absspec > 2*m) = m;
newstd = std(zeropoints);
flatspec = smoothspec - rawmedian;

newthresh = newstd *  threshsigma;
%[freqs sigheights] = findpeaks(newf,finalspec,specr);
% figure;
% plot(newf,flatspec,'b');
% hold all;
% %plot(newf,trimmedspec,'r');
% a = xlim;
% plot(a,[newthresh newthresh],'g');
% plot(newf,absspec,'k');
%   [...] = FINDPEAKS(X,'MINPEAKHEIGHT',MPH) finds only those peaks that
%   are greater than MINPEAKHEIGHT MPH. Specifying a minimum peak height
%   may help in reducing the processing time. MPH is a real valued scalar.
%   The default value of MPH is -Inf.
%
%   [...] = FINDPEAKS(X,'MINPEAKDISTANCE',MPD) finds peaks that are at
%   least separated by MINPEAKDISTANCE MPD. MPD is a positive integer
%   valued scalar. This parameter may be specified to ignore smaller peaks
%   that may occur in close proximity to a large local peak. For example,
%   if a large local peak occurs at index N, then all smaller peaks in the
%   range (N-MPD, N+MPD) are ignored. If not specified, MPD is assigned a
%   value of one. 
[pks locs] = findpeaks(flatspec,'MINPEAKHEIGHT',newthresh','MINPEAKDISTANCE',nsmooth);
[pks pki] = sort(pks,'descend');
locs = locs(pki);
freqs = newf(locs);
peakresults.excluded = 0 * newf;
peakresults.residuals = flatspec;
delf = newf(2)-newf(1);
allpeaks = {};
for (i = 1:length(freqs))
    thispeak.f = freqs(i);
    thispeak.specrs = specr;
    thispeak.height = pks(i);
    thispeak.centeri = locs(i);
    zonesize = nsmooth * 20;
    thispeak.minzone = max(1,thispeak.centeri-zonesize);
    thispeak.maxzone = min(length(newf),thispeak.centeri+zonesize);
    thispeak.zonei = thispeak.minzone:thispeak.maxzone;
    thispeak.zonef = newf(thispeak.zonei);
    thispeak.zonesig = flatspec(thispeak.zonei)';
    thispeak.assigned = 0;
    thispeak.threshhold = newthresh;
    errsig = Inf;
    for guessi = -1:0.01:1  %find exactf.
        guessf = thispeak.f + (delf*guessi);
        localdetune = (thispeak.zonef - guessf) / (2.4*specr);
        gaussenv = (1.0 * thispeak.height * exp(-localdetune.^2))';
        sizegauss = size(gaussenv);
        sizeresults = size(peakresults.residuals(thispeak.zonei));
        if (sizegauss(1) == sizeresults(1))
            gaussenv = gaussenv';
        end
        thiserror = sum((peakresults.residuals(thispeak.zonei) - gaussenv').^2);
        if thiserror < errsig
            errsig = thiserror;
            bestguessf = guessf;
            bestenv = gaussenv;
        end
    end
    peakresults.residuals(thispeak.zonei) = peakresults.residuals(thispeak.zonei) - bestenv'; %really should fit height, f
    thispeak.exactf = bestguessf;
    localdetune = (thispeak.zonef - bestguessf) / (2.6*specr);
    thispeak.gaussenv = 1.0 * thispeak.height * exp(-localdetune.^2);
    localdetune = (thispeak.zonef - bestguessf) / (1.8*specr);
    thispeak.exclusionenv = 0.9 * thispeak.height * (1./(1+abs(localdetune).^3.00));
    allpeaks{i} = thispeak;
    for (j = thispeak.zonei)
        peakresults.excluded(j) = max(peakresults.excluded(j),thispeak.exclusionenv(1+j-thispeak.minzone));
    end
end
exactfs = [];
exacths = [];
for (i = 1:length(allpeaks))
    thispeak = allpeaks{i};
    if thispeak.height > peakresults.excluded(thispeak.centeri)
        exactfs(end+1) = thispeak.exactf;
        exacths(end+1) = thispeak.height;
        
        thispeak.verified = 1;
    else
        thispeak.verified = 0;
    end
end
    
%[prunedfreqs prunedheights] = prunepeaks(freqs,heights,specr);
%plot(freqs,pks,'bs');
sigheights = pks;
peakresults.allpeaks = allpeaks;
peakresults.freqs = freqs;
peakresults.exactfs = exactfs;
peakresults.exacths = exacths;
peakresults.sigheights = sigheights;
peakresults.stddev = newstd;
peakresults.thresh = newthresh;
peakresults.threshsigma = threshsigma;
peakresults.flatspec = flatspec;
peakresults.newf = newf;
%title(bigspecfilename);
% xlabel('freq, Hz');
% ylabel('signal, au');
% legend('spectrum','threshold','peaks');