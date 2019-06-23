function fit = findbruteforcefit(kit)
if nargin == 1
    save('bftfile','kit')  %'tfile is 
else
    load('bftfile','kit');
    kit.tightnesssettings = settingsfromtightness(kit.tightnesssettings.scalartightness); %update tightness
end
rng(1);
ABCexact = [8572.0553 3640.1063 2790.9666];
ABCguess = [8572.0 3640.0 2790.0];   %very good guess for now
ABCguess = ABCguess .* [.990 1.01 .99]; 
kit = trimkit(kit,kit.tightnesssettings.bruteforce.numexperimentlines);

flimits = [min(kit.onedpeakfs) max(kit.onedpeakfs)];
theoryset = linesforbruteforce2(ABCguess,flimits,kit.tightnesssettings.bruteforce.numtheorylines,max(kit.onedpeakhsunassigned));

linestouse.lines = theoryset;
linestouse.heighttouse = 'sixKweakpulsestrength';
linestouse.fitdescriptor = 'made up brute force fit';
linestouse.ABCxxxxx = [ABCguess 0 0 0 0 0];
%addC13swithlinelist 

ABClist = {ABCguess};
dAdBdC = [.01 .01 .01];

linestouse.ABClist = ABClist;
linestouse.dAdBdC = dAdBdC;
kit.findfitsettings = kit.tightnesssettings.bruteforce;

allfits = findfits(linestouse,kit);

fit = pullbest(allfits,kit);
fit.patternType = 'bruteforce';
kit = addfittokit(kit,fit);
displaykitwithfits(kit);
1;

function bestfit = pullbest(fitlist,kit)
minScore = 0;
bestfit = 0;
for i = 1:length(fitlist)
    thisfit = applyfittokit(fitlist{i},kit);
    thisfit = addscore(thisfit,'pval');
    if thisfit.fitScore > minScore
        bestfit = thisfit;
        minScore = thisfit.fitScore;
    end
end

function kit = trimkit(kit,numlines)
exphs = kit.onedpeakhsunassigned;
expfs = kit.onedpeakfsunassigned;
[exphs,XI] = sort(exphs,'descend');
numlines = min(numlines,length(exphs));
kit.onedpeakhsunassigned = exphs(1:numlines);
kit.onedpeakfsunassigned = expfs(XI(1:numlines));

    
function outpairs = linesforbruteforce2(ABC,mwbounds,numlines,scaledh)
pairlist = spcatjrangeABC([ABC 0 0 0 0 0],0,12);
pairlist = trimpairs(pairlist,mwbounds(1),mwbounds(2));
heights = extractonefieldfromcellarray(pairlist,'sixKweakpulsestrength');

numlines = min(numlines,length(heights));
[heights XI] = sort(heights,'descend');
scale = scaledh/max(heights);
    
numlines = min(numlines,length(heights));
outpairs = {};

    for i = 1:numlines
        thispair = pairlist{XI(i)};
        thispair.sixKweakpulsestrength = thispair.sixKweakpulsestrength*scale;
        outpairs{end+1} = thispair;
    end
    
% outpairs;
% theoryf  = extractonefieldfromcellarray(pairlist,'delf');
% figure;
% stickplot(theoryf,heights);
% 1;

    
% 
% function outpairs = linesforbruteforce(ABC,mwbounds,numlines,scaledh)
% pgoargsin.molstats = molstatsfromwhatever(ABC);
%     pgoargsin.maxj = 20;
%     %argsin.usepgo = 0;
%     pgoargsin.reduceset = 0;
%     pgoargsin.maxrf = 0;  %in GHz
%     pgoargsin.minrf = 0;
%     pgoargsin.minmw = mwbounds(1);
%     pgoargsin.maxmw = mwbounds(2);
%     
%     pgoargsin.temp = 6;
%    % pgoargsin.usespcat = 1;
%     [pairlist] = findallpairspgo(pgoargsin);
%     pairlist = trimpairs(pairlist,mwbounds(1)/1000,mwbounds(2)/1000);
%     heights = extractonefieldfromcellarray(pairlist,'sixKweakpulsestrength');
%     [heights XI] = sort(heights,'descend');
%     numlines2 = min(numlines*2,length(heights));
%     firstpairs = {};
% 
%     for i = 1:numlines2
%         thispair = pairlist{XI(i)};
%         thispair.Jupper = thispair.startj;
%         thispair.Jlower = thispair.endj;
%         firstpairs{end+1} = thispair;
%     end
%     
%       
%     thisfit.lines = firstpairs;
%     thisfit.ABCxxxxx = [ABC 0 0 0 0 0];
%     [basefit survivors] = quickspcat(thisfit);
%     firstpairs = survivors;
%     
%     heights = extractonefieldfromcellarray(firstpairs,'sixKweakpulsestrength');
%     scale = scaledh/max(heights);
%     [heights XI] = sort(heights,'descend');
%     numlines = min(numlines,length(heights));
%     outpairs = {};
%     
%     for i = 1:numlines
%         thispair = firstpairs{XI(i)};
%         thispair.sixKweakpulsestrength = thispair.sixKweakpulsestrength*scale;
%         outpairs{end+1} = thispair;
%     end
%     
%     
%     1;
%     
%     
    
