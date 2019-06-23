function ts = settingsfromtightness(t,totaltime,flextights)
%tightnesssettings contains all thresholds.  some are fixed, some vary with
%tightness. high tightness is TOLERANT
if nargin < 2
    totaltime = 200;
    flextights = 0;
end

ts.scalartightness = t;



ts.f3f1thresh =  4000 * (t) ;

ts.flatsquareheightratio =  10 * t;
ts.firstcutheightratio =  10 * t;

ts.mindegree = 2;
ts.maxcomponents = 2;
ts.maxpatterns = 20;
ts.maxka = 2;

ts.highsidetolerance =   t * 0.5 * [50 50 10];  %how well can we predict the next f? lactone had to lower
ts.lowsidetolerance =   t * [300 70 25];
ts.lowjthresh = 7;

%ts.btolerance =   0 * t *  [300 90 40 20 4 2 2 2];



ts.aatolerance = t *  800;  %series1 - series4, about. angelica is about 700
ts.abtolerance = t * 4000;


ts.ladderSearchtimes = {[5,1e-40],[20, 1e-40],[100,1e-40],[500,1e-8],[2000,100]}; %these are time,pval pairs. last one means "just quit after 1000".
ts.seriesaratio = 12;
ts.seriesbratio = 12;
ts.gapmax = 4000; %flat square b+c
ts.gapmin = 400;
ts.minlines = 600;  %number of lines in the spectrum after first cut
ts.flatsquarefthresh = .050;
ts.seriessquarefthresh = .050;
ts.flatsquarelimit = 6000;
ts.minpval = 1e-8;
ts.checkablepval = 1e-8;
ts.numABCs = 2;
ts.smallestscaffold = 12;  %usually 12
ts.minrungs = 3; %usually 3
ts.numjguess = 3;
if t >= 1
    ts.checkablepval = 1e-8;
end
if t >= 2
    ts.checkablepval = 1e-5;
end

ts.okhitvotecount = 10;
ts.maxscaffolds = 80; %when do things bog down?
ts.foundfitvotecount = 20;
ts.greathitvotecount = 80;
ts.maxsquaresfromline = 3;
ts.totaltime = totaltime;
ts.trimends = 0;  %cut off ends of long series - they might be wrong and we have enough..

%ts.lines = [1:40]; %[1:40];
ts.lines = [1:10];
if t > 1
    ts.lines = [1:60];
end
if t > 2
    ts.lines = [1:80];
end
%one field is set from a new field
if isstruct(flextights)
    oldts = ts;
    ts2 = settingsfromtightness(flextights.newtight,totaltime,0);
    ts = setfield(ts,flextights.fieldname,getfield(ts2,flextights.fieldname));
    1;
end

%settings for variant 3
ts.babytolerance = 5;
