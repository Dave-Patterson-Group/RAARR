function ts = settingsfromtightness(t)
%tightnesssettings contains all thresholds.  some are fixed, some vary with
%tightness. high tightness is TOLERANT

%first settings which are common to methods
%ts has various components: variant settings, spfit settings

ts.scalartightness = t;
ts.f3f1thresh =  4000 * (t) ;

ts.flatsquareheightratio =  12 * t;
ts.firstcutheightratio =  12 * t;

ts.mindegree = 2;

% patternfitting.maxcomponents = 1;
% patternfitting.maxpatterns = 20;
% patternfitting.maxka = 1;
% ts.patternfitting = patternfitting;
% 
% ts.maxcomponents = 1;
% ts.maxpatterns = 20;
% ts.maxka = 1;

ts.highsidetolerance =   t * 0.5 * [50 50 10];  %how well can we predict the next f? lactone had to lower
ts.lowsidetolerance =   t * [300 70 25];
ts.lowjthresh = 7;

%ts.btolerance =   0 * t *  [300 90 40 20 4 2 2 2];



ts.aatolerance = t *  800;  %series1 - series4, about. angelica is about 700
ts.abtolerance = t * 4000;


ts.ladderSearchtimes = {[5,1e-40],[20, 1e-40],[100,1e-40],[500,1e-8],[4000,100]}; %these are time,pval pairs. last one means "just quit after 1000".
ts.seriesaratio = 15;
ts.seriesbratio = 15;
ts.gapmax = 4000; %flat square b+c
ts.gapmin = 400;
ts.minlines = 600;  %number of lines in the spectrum after first cut
ts.flatsquarefthresh = .050;
ts.seriessquarefthresh = .050;
ts.flatsquarelimit = 6000;
ts.minpval = 1e-6;
ts.checkablepval = 1e-8;
%ts.numABCs = 3;


ts.smallestscaffold = 12;  %usually 12
ts.minrungs = 3; %usually 3
ts.numjguess = 3;
if t >= 1
    ts.checkablepval = 1e-8;
end
if t >= 2
    ts.checkablepval = 1e-5;
end
ts.maxka = 2;
ts.okhitvotecount = 10;
ts.maxscaffolds = 80; %when do things bog down?
ts.evolveFit = 0;
ts.addisotopes = 0;
ts.foundfitvotecount = 20;
ts.greathitvotecount = 80;
ts.maxsquaresfromline = 3;
%ts.totaltime = totaltime;
ts.trimends = 0;  %cut off ends of long series - they might be wrong and we have enough..

%ts.lines = [1:40]; %[1:40];
ts.lines = [1:50];
if t > 1
    ts.lines = [1:60];
end
if t > 2
    ts.lines = [1:80];
end
%%
isotopefitting.heightratiomax = 250;
isotopefitting.freqmin = .98;
isotopefitting.freqmax = 1.01;
isotopefitting.numtargetmax = 15;
isotopefitting.targetminheight = 100;
isotopefitting.freqpixel = .10;
isotopefitting.minSNR = 200;
isotopefitting.c13pval = 1e-10;
isotopefitting.numtrials = 100;
isotopefitting.maxspecies = 1;   %number of isotopologues you can find..
isotopefitting.fdriftmax = 0.05;
isotopefitting.targetoccupancy = 0.05;
isotopefitting.maxmisses = 125;
isotopefitting.dicerolls = 4;  %lower is more random, more stupid triad choices
isotopefitting.spurratiomin = 0.001;
ts.isotopefitting = isotopefitting;

patternfitting.numABCs = 3;
patternfitting.maxcomponents = 1;
patternfitting.maxpatterns = 20;
patternfitting.actypes = [0];  %try both ab and ac
%patternfitting.actypes = [1];  %try just ac
patternfitting.maxka = 2;
patternfitting.numjguess = 3;
ts.patternfitting = patternfitting;
%% block for bruteforce
bruteforce.numtheorylines = 50;
bruteforce.numexperimentlines = 500;
bruteforce.heightratiomax = 500;
% bruteforce.freqmin = .98;
% bruteforce.freqmax = 1.01;
bruteforce.numtargetmax = 15;
bruteforce.targetminheight = 0;
bruteforce.freqpixel = 2.00;
bruteforce.minSNR = 1;
bruteforce.c13pval = 1e-10;
bruteforce.numtrials = 3;
bruteforce.maxspecies = 1;
bruteforce.fdriftmax = 0.05;
bruteforce.targetoccupancy = 0.05;
bruteforce.spurratiomin = 0.05;  %spurs must be this tall
bruteforce.maxmisses = 125;
bruteforce.dicerolls = 4;  %lower is more random, more stupid triad choices
ts.bruteforce = bruteforce;

%%
variant3.babytolerance = 5;  %height ratio for first pair
variant3.atolerance = 30;  %height ratio for ANY line in an a-series
variant3.babyatolerance = 10;  %height ratio for first two line in an a-series
variant3.meantolerance = 20;  %height new line from a-series mean
variant3.fancytolerance = 0.5; %in MHz.  on fake data seem to hit more like 0.1 MHz.
variant3.fancytolerancef1lowJ = 5; 
  
variant3.fancytolerancef0 = 0.5; %in MHz.  on fake data seem to hit more like 0.1 MHz.
variant3.fancytolerancef0first = 10; %in MHz.  on fake data seem to hit more like 0.1 MHz.
variant3.fancytolerancef0lowJ = 10; %5 MHz was too little, missed 1/9
variant3.f1tof0tolerance = 50; %in MHz
variant3.f1tof0toleranceSure = 300;  %accept MANY jumps if f1 series is iron clad
variant3.f1tof0toleranceThresh = 1e2;
variant3.minf1length = 3; %how long does an f1 streak need to be befoe jumping to f0
variant3.minlines = 4;
variant3.gapmax = 4000; %flat square b+c
variant3.gapmin = 400; 
variant3.maxPatterns = 2;
variant3.heightHealthRatio = 15;  %higher is more tolerance
variant3.freqHealthLimit = 0.2;  %higher is more tolerance. in MHz.
variant3.maxPval = 10;  %think about this. sliding scale?
variant3.minforcloseout = 2;
variant3.maxtof0 = 20;
variant3.totalHealthLimit = 1; %larger is LESS tolerant. 
%variant3.maxfromoneline = 2;
variant3.gapoverbendmax = 100; %never seen this violated
%cowcow make bendtolerance higher at higher j. if j < 6, double it maybe? 
variant3.bendTolerance = [50 20 10 10 10 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2]; %third line in f1 a series can be how far out of straight
variant3.lowj = 5;  %all tolerances looser down here
variant3.lines = [1:30];
variant3.kaguesses = [0];
variant3.verbose = 0;
%settings for variant 3
ts.variant3 = variant3;

%%
bowties.rank = 200;
bowties.containsOblate = false;
bowties.weakAorB = 0;
bowties.divthresh = 8;
bowties.divthresh2 = 8;
bowties.divthreshs = 105;
bowties.dthresh = 0.05;
bowties.hsdivthresh = 3500;
bowties.rmsthresh = 0.005;
bowties.percentmaxdiff = 0.08;
bowties.percenth14diff = 0.04;
bowties.leftsq = 0.02;
bowties.rightsq = 0.02;
bowties.prll1 = 0.02;
bowties.prll2 = 0.02;
bowties.inttest = 0;
bowties.ratiovar = 0.045;
ts.bowties = bowties;



