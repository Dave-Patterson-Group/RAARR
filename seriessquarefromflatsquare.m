function s = seriessquarefromflatsquare(flatsquare,flipd)
%a series square has three series which add up.  Series 1 is always
%represented twice.  For example, series1(n) + series1(n+1) - series2(n) -
%series3(n) = 0 for any n.  Series1 must be one longer than any other
%series

%the argument flatsquare is four frequencies. f1 and f2 are assumed to be
%the series; this is reasonable given how we found the square, but might
%not be correct. Wait! this is a trap. two squares can be unique, as
%defined by uniquesquares, but different, as seen by this function. Hm. ok.
%
%the central call we want to make eventually is
%extendseriesbyone(s,allfs,allhs). This will let us extend the square by
%one, either up or down..

if nargin < 2
    flipd = 0;
end
s.flatsquare = flatsquare;
series1.fs = flatsquare.fs(1:2);
series1.hs = flatsquare.hs(1:2);
if flipd == 0
    series2.fs = [flatsquare.fs(3) 0];
    series2.hs = [flatsquare.hs(3) 0];
    series3.fs = [0 flatsquare.fs(4)];
    series3.hs = [0 flatsquare.hs(4)];
else
    series2.fs = [flatsquare.fs(4) 0];
    series2.hs = [flatsquare.hs(4) 0];
    series3.fs = [0 flatsquare.fs(3)];
    series3.hs = [0 flatsquare.hs(3)];
end
series4.fs = [0 0];
series4.hs = [0 0];
series1.frange = flatsquare.frange;
series2.frange = flatsquare.frange;
series3.frange = flatsquare.frange;
series4.frange = flatsquare.frange;

dsigns = [1 1 -1 -1];
slantupsigns = [1 -1 -1 1];


s.signs = flatsquare.signs;
s.flipped = 0;
if norm(s.signs - dsigns) == 0  %dtype
    s.flattype = 'D';
    s.dtype = 1;
    s.column1 = series1;
    s.column2 = series2;
    s.column3 = series3;
    s.column4 = series4;
else
    s.dtype = 0;
    
    if norm(s.signs - slantupsigns) == 0  %slantup
        s.column2 = series1;
        s.column1 = series2;
        s.column4 = series3;
        s.column3 = series4;
        s.flattype = '/';
    else
        s.column3 = series1;
        s.column4 = series2;
        s.column1 = series3;
        s.column2 = series4;
        s.flattype = '\';
        
    end 
end
s.usecorrection = flatsquare.usecorrection;
s.laddermode = flatsquare.laddermode;
s.signs = flatsquare.signs;  %these are [S1(1) S1(2) S2(1) S3(1)]
s.tightnesssettings = flatsquare.tightnesssettings;
s.counttool = flatsquare.counttool;
s.ordercutoff = 100;
s.frange = flatsquare.frange;
s.closedout = 0;
%s.secondsigns = [0 0 0 0];   %these are [S1(1) S2(1) S3(1) S4(1)]
s.originalf1 = flatsquare.fs(1);
s.flatdescriptor = flatsquare.descriptor;
s.originstring = flatsquare.originstring;
s.forcecorners = flatsquare.forcecorners;
s.cornermap = flatsquare.cornermap;
s.templateabsolute =  flatsquare.templateabsolute;
s.templatenorm =  flatsquare.templatenorm;
s.upterminated = 0;
s.downterminated = 0;

s.highsidetolerance = flatsquare.tightnesssettings.highsidetolerance; 
s.lowsidetolerance = flatsquare.tightnesssettings.lowsidetolerance;
s.btolerance = s.highsidetolerance * 0; 
s.aatolerance = flatsquare.tightnesssettings.aatolerance;
s.abtolerance = flatsquare.tightnesssettings.abtolerance;

%s.atolerance(2) = s.atolerance(2) * 2;

s.column1 = settolerance(s.column1,flatsquare.tightnesssettings,'a',1);
s.column2 = settolerance(s.column2,flatsquare.tightnesssettings,'b',2);
s.column3 = settolerance(s.column3,flatsquare.tightnesssettings,'b',3);
s.column4 = settolerance(s.column4,flatsquare.tightnesssettings,'a',4);

% s.column1.type = 'a';
% s.column1.highsidetolerance = s.highsidetolerance;
% s.column1.lowsidetolerance = s.lowsidetolerance;
% s.column2.type = 'b';
% s.column2.highsidetolerance = s.highsidetolerance;
% s.column2.lowsidetolerance = s.lowsidetolerance;
% s.column3.type = 'b';
% s.column3.highsidetolerance = s.highsidetolerance;
% s.column3.lowsidetolerance = s.lowsidetolerance;
% s.column4.type = 'a';
% s.column4.highsidetolerance = s.highsidetolerance;
% s.column4.lowsidetolerance = s.lowsidetolerance;

% s.column1.whichcolumn = 1;
% s.column2.whichcolumn = 2;
% s.column3.whichcolumn = 3;
% s.column4.whichcolumn = 4;
s.frecommendedmin = flatsquare.frecommendedmin;
s.frecommendedmax = flatsquare.frecommendedmax;


s = updateseriessquare(s);
%s.fgrid
1;

function column = settolerance(column,tightnesssettings,type,whichcolumn)
column.type = type;
column.highsidetolerance = tightnesssettings.highsidetolerance;
column.lowsidetolerance = tightnesssettings.lowsidetolerance;
column.lowjthresh = tightnesssettings.lowjthresh;
column.whichcolumn = whichcolumn;

