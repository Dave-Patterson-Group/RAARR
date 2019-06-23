function [fstart hstart istart rank] = pickfirstf(kit,d)
    fs = kit.onedpeakfsunassigned;
    hs = kit.onedpeakhsunassigned;
% 
% ulines = find(kit.whichspecies == 0);
% fs = fs(ulines);
% hs = hs(ulines);
frange = max(fs) - min(fs);
% fmin = fs(1) + frange/4;
% fmax = fs(1) + frange/2;
fmin = min(fs) + 0.1* frange;
fmax = min(fs)  + 0.6*frange;
imin = find(fs > fmin,1,'first');
imax = find(fs > fmax,1,'first');
possf = fs(imin:imax);
possh = hs(imin:imax);
[sorth XI] = sort(possh,'descend');

if d > 2000 %interpret as a frequency
    ferrs = abs(fs - d);
    [mind besti] = min(ferrs);  %replaces my old besti code! amazing!
    fstart = fs(besti);
    hstart = hs(besti);
    istart = besti;
    
    rank = find(sorth < hstart,1,'first');
    
    if length(rank) == 0
        rank = 0;
    end
    return
end


frange = fs(end) - fs(1);
% fmin = fs(1) + frange/4;
% fmax = fs(1) + frange/2;
fmin = fs(1) + frange/100;
fmax = fs(1) + 0.6*frange;
imin = find(fs > fmin,1,'first');
imax = find(fs > fmax,1,'first');
possf = fs(imin:imax);
possh = hs(imin:imax);
[sorth XI] = sort(possh,'descend');
if d < 1
    d = 1 + floor(rand() * length(possh));
end
d = min(d,length(possh));
besti = XI(d);
fstart = possf(besti);
hstart = possh(besti);
istart = besti + imin - 1;
rank = d;