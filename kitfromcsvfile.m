function kit = kitfromcsvfile(csvfilename,ts)

if contains(csvfilename,'fake')   ||  contains(csvfilename,'propanediol')   
    correctheights = 0;
else
    correctheights = 1;
end

    
if (nargin >= 2) && isfield(ts,'correctheights') == 1
    correctheights = ts.correctheights;
end

try
    M = csvread(csvfilename);
    freqs = M(:,1);
    amps = M(:,2);
catch
    
    M = dlmread(csvfilename,' ');
    freqs = M(:,1);
    amps = M(:,2) * 1000;
end
peakresults = findpeaksd(freqs,amps,7,.050);
%peakresults = findpeaksd(freqs,amps,7,.050);
fs = peakresults.exactfs;
hs = peakresults.exacths;
[fs XI] = sort(fs);
hs = hs(XI);

if correctheights
    [fs hs] = redrigspectralcorrection(fs,hs);
end

% lastslash = find(csvfilename == '/',1,'last') + 1;
% lastdot = find(csvfilename == '.',1,'last') - 1;
% molname = filenames(lastslash:lastdot);
% lastslash = find(filenames == '/',1,'last') + 1;
% lastdot = find(filenames == '.',1,'last') - 1;
kit.kitfilename =  kitfilename(csvfilename);
kit.figfilename = figfilename(csvfilename);
kit.pdffilename = pdffilename(csvfilename);
kit.reportfilename = reportfilename(csvfilename);
[kit.molname directoryname] = molnamefromfilename(csvfilename);
kit.directoryname = directoryname;
kit.freqs1d = freqs;
kit.amps1d = amps;
kit.searchedf1s=[];
kit.candidateScaffolds = {};

kit.latestpattern = 0;
kit.numvotes = 0;
kit.skipspfit = 0;
kit.onedpeakfs = fs;
kit.onedpeakhs = hs;
kit.onedpeakfsunassigned = fs;
kit.onedpeakhsunassigned = hs;
kit.minf = min(kit.onedpeakfs);
kit.maxf = max(kit.onedpeakfs);
kit.frange = kit.maxf - kit.minf;
kit.numpeaks = length(kit.onedpeakfs);
kit.SNR = 0.5 * max(hs)/peakresults.stddev;
kit.barekitdescriptor = sprintf('Spectrum %3.1f->%3.1f MHz\n %d peaks, SNR = %3.1f',min(fs),max(fs),kit.numpeaks,kit.SNR);
kit.numspecies = 0;
kit.numtries = 0;
kit.fitlist = {};
kit.Dinverted = 1;
kit.bogged = 0;
kit.experimental = 1;
kit.fitlistreport = '';
kit.totalflatsquares = 0;
kit.totalCensus = zeros(1,20);
kit.bestScaffoldp = 1;
kit.csvfilename = csvfilename;
kit.whichspecies = zeros(1,length(kit.onedpeakfs));
kit.templateabsolute = zeros(1,50);
kit.templatenorm = zeros(1,50);
kit.forcecorners = 0;
kit.cornermap = 0;
%kit.tightmode = tightmode;
kit.breakmode = 1;
%kit.maxka = 4;
kit.flexibletightness = 1;
kit.flextights = 0;
%kit.skipfit = 0;
kit.foundfit = 0;



