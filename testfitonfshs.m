function fit = testfitonfshs(fit,fs,hs)
%testfitonkit decides if the fit has predictive power.  returns fields like
%fit.yesvotes: the number of predicted lines
%fit.novotes: the number of lines it is MISSING

explineset = observablelines(fit.minocteths,fs,hs);
predictlist = pairlistnearfit(fit);
[fit.typestring, fit.branchstring, fit.branchtypestring, fit.fitdescriptor] = deal(strings(1,3));
fit.allpredictedf = extractfieldsfromcellarray(predictlist,{'delf'});
fit.allpredictedf = fit.allpredictedf.delf;
fit.allpredictedh = extractfieldsfromcellarray(predictlist,{'realinten'});
fit.allpredictedh = fit.allpredictedh.realinten;
predictlist = trimpairs(predictlist,explineset.fmin,explineset.fmax);
predictlist = trimweirdpairs(predictlist);
predictlist = trimweakpairs(predictlist);
[upvotes,expfs,newassignments] = numpredicted(explineset,predictlist);%[upvotes,expfs,newassignments]
[typestring,branchstring,descriptor] = transitiontypes(newassignments);
fit.typestring = typestring;
fit.branchstring = branchstring;
fit.branchtypestring = descriptor;
fit.yesvotes = upvotes;
fit.novotes = length(predictlist) - upvotes;
fit.fitdescriptor = fitdescriptor(fit);
tempstruct = extractfieldsfromcellarray(newassignments,{'delf'});
fit.unstretchedpredictedf = tempstruct.delf;
tempstruct = extractfieldsfromcellarray(newassignments,{'realinten'});
fit.predictedh = tempstruct.realinten;
fit.expfreq = fs;
fit.expheight = hs;
fit = addhits(fit,expfs,fs,hs);

function s = fitdescriptor(fit)
1;
s = sprintf('FOUND: [%s] %d upvotes, %d downvotes',num2str(fit.ABC,5),fit.yesvotes,fit.novotes);

function [typestring,branchstring,descriptor] = transitiontypes(pairlist)
outputs = extractfieldsfromcellarray(pairlist,{'transitiontype','delj'});
types = outputs.transitiontype;
deljs = outputs.delj;

typestring = '';
branchstring = '';
for i = 1:length(pairlist)
    typestring = [typestring types{i}];
    if deljs(i) == 0
        branchstring = [branchstring 'Q'];
    elseif abs(deljs(i)) == 1
        branchstring = [branchstring 'R'];
    else
        branchstring = [branchstring 'X'];
    end
end
descriptor = sprintf('%s\n%s',typestring,branchstring);
        

function [upvotes,expfs,newpairs] = numpredicted(explineset,predictlist)
assignedfs = [];
assignedis = [];
for i = 1:length(predictlist)
    thispair = predictlist{i};
    predictf = thispair.delf;
    [fs,errs] = closestf(predictf,explineset.fs,3);
    if ((errs(1) < explineset.fthreshold)) && (errs(1) < errs(end)/10)  %we have a match!
        assignedfs(end+1) = fs(1);
        assignedis(end+1) = i;
    else
%         predictf
%         fs
%         errs
        1;
    end
end  %later pull out assignedfs which are unique, like in boggle.  THOSE are true matches.
[expfs,whichworked] = bogglefs(assignedfs);
pairsthatworked = assignedis(whichworked);
newpairs = selectcells(predictlist,pairsthatworked);
newpairs = assignfstopairs(newpairs,expfs);
upvotes = length(unique(assignedfs));

function pairs = assignfstopairs(pairs,expfs)
for i = 1:length(pairs)
    pairs{i}.expf = expfs(i);
end
    
function pairlist = pairlistnearfit(fit)
%calls SPCAT to return a list of pairs in and near the fit
argsin = fit.info.argsout;
jmin = fit.info.minj - 2;
jmax = fit.info.maxj + 4;
argsin.hasa = 1;
argsin.hasb = 1;
argsin.hasc = 1;

pairlist = spcatjrange(argsin,jmin,jmax,0,jmax);  %just do all k seems more stable

function fit = addhits(fit,expfs,fs,hs)
%goes back to the experimental onedpeakfs, finds them, adds the lines.
%helps with plotting
hitis = [];
for ii = 1:length(expfs)
    [~,~,i] = closestf(expfs(ii),fs,1);%[f,err,i]
    hitis(end+1) = i;
end
fit.hitis = hitis;
fit.hitfs = fs(fit.hitis);
fit.hiths = hs(fit.hitis);
fit.onedpeakfs = fs(~ismembc(1:length(fs),fit.hitis));
fit.onedpeakhs = hs(~ismembc(1:length(hs),fit.hitis));

function explineset = observablelines(thresh2xrung,fs,hs)
fcloseyes = 0.06;
explineset.hthresh = thresh2xrung/4;
usablei = find(hs > explineset.hthresh);
explineset.fs = fs(usablei);
explineset.hs = hs(usablei);
explineset.fmin = explineset.fs(1) + 50;
explineset.fmax = explineset.fs(end) - 50;
explineset.meanspacing = (explineset.fmax - explineset.fmin) / length(explineset.fs);
explineset.fthreshold = max(fcloseyes,explineset.meanspacing / 20);

function outpairs = trimpairs(pairlist,minf,maxf,smalldelk)
%displays the list, sorted by f.
if nargin < 4
    smalldelk = 0;
end
numpairs = length(pairlist);

outpairs = {};
for i = 1:numpairs
    if numpairs == 1
        thispair = pairlist;
    else
       thispair = pairlist{i};
    end
    f = thispair.delf;
    if (f > minf) && (f < maxf)
        if (smalldelk == 0) || ...
           ((abs(thispair.delka) <= 1) && (abs(thispair.delkc) <= 1))
            
            outpairs{end+1} = thispair;
        end
    end
end

function outpairs = trimweakpairs(pairlist,heightthresh)
%displays the list, sorted by f.
outpairs = {};
if nargin < 2
    heightthresh = 0.05;
end
heights = extractfieldsfromcellarray(pairlist,{'sixKweakpulsestrength'});
heights = heights.sixKweakpulsestrength;
minheight = max(heights) * heightthresh;

for i = 1:length(heights)
    if heights(i) >= minheight
        
        outpairs{end+1} = pairlist{i};
    end
    
end
