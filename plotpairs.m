function plotpairs(pairlist,whichplot,plotstyle,scalefactor,inMHZ)

if nargin == 0
    pairlist = findallpairs();
end
if nargin < 2
    whichplot = 'scaledsixKweakpulsestrength';
end
if nargin < 3
    plotstyle = 'b';
end
if nargin < 4
    scalefactor = 1;
end
if nargin < 5
    inMHZ = 0;
end

flipit = 1;
if whichplot(end) == '-'
    whichplot = whichplot(1:end-1);
    flipit = -1;
end
numpairs = length(pairlist);
if length(numpairs) == 0
    return;
end
freqs = [];
amps = [];
pols = [];
ytoplot = [];
for i = 1:numpairs
    thispair = pairlist{i};
    if inMHZ
        freqs(end+1) = thispair.delfMHZ;
    else
        if isfield(thispair,'localf')
            freqs(end+1) = thispair.localf;
        else
            freqs(end+1) = thispair.delf;
        end
    end
    amps(end+1) = thispair.transmoment;
    pols(end+1) = thispair.polarizability;
    ytoplot(end+1) = scalefactor * flipit * getfield(thispair,whichplot);
    %disp(thispair.description);
end
[f xi] = sort(freqs);
newp = pols(xi);
for i = 1:numpairs
    thispair = pairlist{xi(i)};
	%disp(thispair.description);
end
if plotstyle == 'q'
    hold all
    p = stickplot(freqs,ytoplot);
else
    p = stickplot(freqs,ytoplot,plotstyle);
end
a.datatype = 'Pairlist';
a.pairlist = pairlist;
set(p,'UserData',a);
%dcmObj = datacursormode;  %# Turn on data cursors and return the
                          %#   data cursor mode object
                          
%set(dcmObj,'UpdateFcn',@spectrumcallback);  %# Set the data cursor mode object update
                                     %#   function so it uses updateFcn.m

%xlim([11 20]);
%precisestickies();
ylabel(whichplot);
