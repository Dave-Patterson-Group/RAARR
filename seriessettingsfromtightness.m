function ts = seriessettingsfromtightness(t)
%tightnesssettings contains all thresholds.  some are fixed, some vary with
%tightness. high tightness is TOLERANT
if nargin < 2
    totaltime = 200;
    flextights = 0;
end
ts.scalartightness = t;

ts.numseriestotry = 40;
ts.inttestlimit = 0.1 * t;
ts.atolerance = t * [300 40 4 1 1 1 1 1 1 1 1];
ts.lowjthresh = 7;
ts.aatolerance = t * 400;
ts.abtolerance = t * 2000;
ts.babytolerance = t  * 3;
ts.fullseriesratio = 20;
ts.rmsthresh = 0.5;  %in MHz.  for final spfit.
ts.seriesaratio = 6;
ts.numconfirmsneeded = 20;
ts.gapmax = 4000; %flat square b+c
ts.gapmin = 600;
ts.minlines = 400;  %number of lines in the spectrum after first cut
ts.f1f2ratiothresh = t * 0.02;
ts.minserieslength = 4;
ts.lines = [1:40];
if t > 1
    ts.lines = [1:60];
end
if t > 2
    ts.lines = [1:80];
end



