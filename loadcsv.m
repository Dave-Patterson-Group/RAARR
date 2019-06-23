function [freqs amps] = loadcsv(fileid,invert,factor)
if nargin < 2
    invert = 0;
end
if nargin < 3
    factor = 1;
end
peakfname = 'X';
if isnumeric(fileid)

    [csvfname peakfname] = csvfilenamefromnumber(fileid);
else
    csvfname = fileid;
end

M = csvread(csvfname);

    amps = M(:,2) * factor;
    freqs = M(:,1);
    



