function kit = distortkit(kit)
%this function combines nearby lines, adds extra lines, and adds random
%frequency jitter to lines

if isfield(kit,'experimental') && (kit.experimental == 1)
    return
end
linewidth = 0.08;
ferror = 0.010;

linewidth = 0.18;
ferror = 0.020;

kit.undistortedfs = kit.onedpeakfs;
kit.undistortedhs = kit.onedpeakhs;

fs = kit.onedpeakfs;
hs = kit.onedpeakhs;
combining = 1;
while combining
    combining = 0;
    nump = length(fs);
    newfs = [];
    newhs = [];
    i = 1;
    while i < nump
        j = i+1;
        thissetf = [fs(i)];
        thisseth = [hs(i)];
        while (j <= nump) && ((fs(j) - fs(j-1)) < linewidth)
            thissetf(end+1) = fs(j);
            thisseth(end+1) = hs(j);
            combining = 1;
            j = j+1;
        end
        weightedf = sum(thissetf .* thisseth) / sum(thisseth);
        weightedh = sum(thisseth);
        newfs(end+1) = weightedf;
        newhs(end+1) = weightedh;
        i = j;
    end
    fs = newfs;
    hs = newhs;
end
for i = 1:length(fs)
    fs(i) = fs(i) + ((rand() - 0.5) * ferror);
end
kit.onedpeakfs = fs;
kit.onedpeakhs = hs;
% figure;
% stickplot(kit.undistortedfs,kit.undistortedhs);
% hold all
% stickplot(kit.onedpeakfs,-kit.onedpeakhs);
% 1;

