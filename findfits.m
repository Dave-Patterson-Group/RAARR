
function allisotopes = findfits(linestouse,kit)
%originalkit = kit;
allisotopes = {};
nummisses = 0;
ABClist = linestouse.ABClist;

linestouse = addABClist(linestouse,ABClist); %precalculate line positions and derivatives for each ABC
rng(6);
for i = 1:kit.findfitsettings.numtrials
    
%     sublines = findgoodsub(fit,kit);
%     if (isstruct(sublines) == 1)
%         sublines.targets = findTargets(fit,kit);
%     end
%     if (isstruct(sublines) == 1) && (isstruct(sublines.targets) == 1)
        [isotopefit,kit] = findIsotopeFit(linestouse,kit,linestouse.ABClist,linestouse.dAdBdC);
        if isstruct(isotopefit)
%            fprintf('%s YES\n',sublines.descriptor);
            allisotopes{end+1} = isotopefit;
            %         if f ~= 0
            %             close f
            %         end
            %         f = displaykitwithfits(kit);
            
            allisotopes = sortcellarraybyfield(allisotopes,'A');
            nummisses = 0;
   
            fprintf('\n\ntotal of %d isotopologues found %d trials\n======\n',length(allisotopes),i);
            
        else
            nummisses = nummisses +1;
            %          fprintf('%s NO\n',sublines.descriptor);
            fprintf('No new isotope found, %d misses in a row\n',nummisses);
        end
        if length(allisotopes) >= kit.findfitsettings.maxspecies
            break
        end
        if nummisses > kit.findfitsettings.maxmisses
            break;
        end
        
end




function linestouse = addABClist(linestouse,ABClist) %precalculate line positions and derivatives for each ABC
stretchlinesets = {};
linestouse = addDerivatives(linestouse,[0 0 0]);
linestouse = assesslines(linestouse);
% testDerivatives(linestouse,[1 1 1]);
% 1;


for i = 1:length(ABClist)
    thisABCstretch = ABClist{i};
    if max(abs(thisABCstretch)) > 100  %absolute
        thisABCstretch = thisABCstretch - linestouse.ABCxxxxx(1:3);
    end
    thisABCxxxxxstretch = [thisABCstretch 0 0 0 0 0];
    thislinestouse = addDerivatives(linestouse,thisABCstretch);
    stretchlineset.index = i;
    
    stretchlineset.absABCxxxxx = linestouse.ABCxxxxx + thisABCxxxxxstretch;
    stretchlineset.diffABCxxxxx = thisABCxxxxxstretch;
    stretchlineset.lineset = thislinestouse.lines;
    stretchlinesets{i} = stretchlineset;
end
linestouse.stretchlinesets = stretchlinesets;

function [ABClist,dAdBdC] = getABClist(ABC)
    dAdBdC = [.01 .01 .01];
    ABClist{1} = ABC .* [.99 .99 .99]; %in absolute MHz
    ABClist{end+1} = ABC .* [.98 .99 .99];
    ABClist{end+1} = ABC .* [.99 1  1];
    %ABClist{end+1} = [-5 -1 -1];   % in Delta MHz
function [ivals,jvals,kvals,hitcounts] = ijkvals(sublines)
hitcounts = zeros(sublines.totaltriads,1);
ivals = hitcounts;
jvals = hitcounts;
kvals = hitcounts;
cc = 1;
for i = 1:sublines.line1.numspurs   
    for j = 1:sublines.line2.numspurs
        for k = 1:sublines.line3.numspurs
            ivals(cc) = i;
            jvals(cc) = j;
            kvals(cc) = k;
            cc = cc+1;
        end
    end
end

function [numhits,ijk,df,dABC,set] = extrappoint(sublines,cc,ivals,jvals,kvals,kit,returnset)
    i = ivals(cc);
    j = jvals(cc);
    k = kvals(cc);
    ijk = [i j k];
    df1 = sublines.line1.spurfs(i) - sublines.line1.theoryf;
    df2 = sublines.line2.spurfs(j) - sublines.line2.theoryf;
    df3 = sublines.line3.spurfs(k) - sublines.line3.theoryf;
    df = [df1 df2 df3]';
    if norm(df) < 10
        1;
    end
    dABC = sublines.dABCfromdf * df;
    targetfs = sublines.targets.fList + (sublines.targets.fMatrix * dABC);
    hashes = round(targetfs/kit.findfitsettings.freqpixel); %half way between floor and floor+1
    for ii = 1:length(hashes)
        inspec(ii) = isKey(sublines.targets.kitContainer,hashes(ii));
    end
    numhits = length(find(inspec == 1));
    if returnset
        whichhits = find(inspec == 1);
        
        set.numhits = numhits;
        set.df = df;
        set.dABC = dABC;
        newlines = {};
        triadlines = {};
        fulldescriptor = '';
        for i = 1:length(inspec)
            thisline = sublines.targets.linelist{i};
            
            if inspec(i) == 1
                foundf = sublines.targets.kitContainer(hashes(i));
                fulldescriptor = sprintf('%s\nline %d HIT  linearerror %3.1f %s %3.1f %3.1f h target %3.1f %d dupes found %3.1f',fulldescriptor,i,thisline.linearerror,thisline.descriptor,thisline.theoryf,thisline.sixKweakpulsestrength,targetfs(i),thisline.dupelevel,foundf);
            else
                fulldescriptor = sprintf('%s\nline %d MISS linearerror %3.1f %s %3.1f %3.1f h target %3.1f %d dupes',fulldescriptor,i,thisline.linearerror,thisline.descriptor,thisline.theoryf,thisline.sixKweakpulsestrength,targetfs(i),thisline.dupelevel);
            end
            if ismember(thisline.hash,sublines.hashes)
                fulldescriptor = sprintf('%s*',fulldescriptor);
            end
        end
        for i = 1:numhits
            thisi = whichhits(i);
            foundf = sublines.targets.kitContainer(hashes(thisi));
            thisline = sublines.targets.linelist{thisi};
            if isfield(thisline,'expf')
                thisline.orginalexpf = thisline.expf;
            else
                thisline.orginalexpf = 0;
            end
            thisline.orginalexph = thisline.(sublines.heighttouse);
           
            ferrors = abs(foundf - kit.onedpeakfsunassigned);
            besti = find(ferrors == min(ferrors),1);
            thisline.exph = kit.onedpeakhsunassigned(besti);
    
            thisline.expf = foundf;
            thisline.expfreq = foundf;
            newlines{end+1} = thisline;
            if ismember(thisline.hash,sublines.hashes)
                triadlines{end+1} = thisline;
            end
        end
        set.c13lines = newlines;
        set.triadlines = triadlines;
        set.hitdescriptor = fulldescriptor;
    end
    
function sublines = addAllSpurs(sublines,kit,dAdBdC)

    dAdBdC = dAdBdC .* sublines.ABCxxxxx(1:3);
    sublines.line1 = addSpurs(sublines.line1,sublines.heighttouse,kit,sublines.dffromdABC(1,:),dAdBdC);
    sublines.line2 = addSpurs(sublines.line2,sublines.heighttouse,kit,sublines.dffromdABC(2,:),dAdBdC);
    sublines.line3 = addSpurs(sublines.line3,sublines.heighttouse,kit,sublines.dffromdABC(3,:),dAdBdC);
    sublines.totaltriads = sublines.line1.numspurs * sublines.line2.numspurs * sublines.line3.numspurs;
    sublines.fulldescriptor = sprintf('3 lines, dscore %3.1f,hscore %3.1f, linearscore %3.1f,%d total triads',sublines.dscore,sublines.hscore,sublines.linearscore,sublines.totaltriads);
    
    
function [c13fit,kit] = findIsotopeFit(fit,kit,ABClist,dAdBdC)
    
    c13fit = 0;
    sublines = findgoodsub(fit,kit);
    if (isstruct(sublines) == 0)
        return
    end
    sublines.targets = findTargets(fit,kit);
    if (isstruct(sublines.targets) == 0)
        return
    end   
    disp(sublines.targets.hashreport);
    for i = 1:length(ABClist)
        sublines.stretchindex = i;
        sublines = updatesublines(sublines,fit);
        1;
    
        sublines = addAllSpurs(sublines,kit,dAdBdC);
       % oldtargets = sublines.targets;
        sublines.targets = updatetargets(sublines.targets,fit,i);
        sublines.targets = addmaps(sublines.targets,kit);
       % newtargets = sublines.targets;
        c13fit = sweepSpurs(sublines,kit,1);
        subplot(1,1,1);
        title(sprintf('ABC %d, [%s]',i,num2str(ABClist{i})));
        pause(0.001);
        if isstruct(c13fit)
            kit = addfittokit(kit,c13fit);
            break;
        end
    end

function c13fit = sweepSpurs(sublines,kit,verbose)
if nargin < 3
    verbose = 0;
end
[ivals,jvals,kvals,hitcounts] = ijkvals(sublines);
bestyet = 0;
c13fit = 0;
iFitList = {};
for cc = 1:length(ivals)
    [numhits ijk df dABC] = extrappoint(sublines,cc,ivals,jvals,kvals,kit,0);
    hitcounts(cc) = numhits;
    if numhits > bestyet
        bestijk = ijk;
        bestf1f2f3 = df;
        bestyet = numhits;
     %   fprintf('%d hits, %s %s\n',numhits,num2str(bestijk),num2str(bestf1f2f3));
    end
    if mod(cc,40000) == 0
        fprintf('finished %d of %d triads, bestyet %d\n',cc,length(ivals),bestyet);
    end
end
whichi = significanthits(hitcounts,verbose);
if length(whichi) == 0
    return
end
besti = whichi(1);
fprintf('mean hit count %3.1f, inspecting hit count of %d\n',mean(hitcounts),hitcounts(besti));

[numhits ijk df dABC thisset] = extrappoint(sublines,besti,ivals,jvals,kvals,kit,1);
fprintf(' frequency pixel size is %3.1f\n',kit.findfitsettings.freqpixel);
disp(sublines.fulldescriptor);
disp(thisset.hitdescriptor);
1;  %do I have ABC here?
%thisfit = quickspfit(thistrial.lineset,thistrial.ABC);
%newfit = myquickspfit(thisset.triadlines,sublines.ABCxxxxx,0);
%  newfit = quickspfit(thisset.triadlines,sublines.ABCxxxxx,0);
fprintf('Parent fit:  %s\n',sublines.parentfitdescriptor);
newfit = quickspfit(thisset.c13lines,sublines.ABCxxxxx,0);
newfit.patterntype = 'C13extension';
newfit = testfitonkit(newfit,kit);
%    newfit.C13frac = fitfrac(parentfit,childfit);
%newerfit2 = evolveFitSave(newfit,kit,'broadpval',[4 4]); %seems to never help, explore.
%     dABC2 = sublines.ABCxxxxx - newerfit2.ABCxxxxx;
%     dABC
%     dABC2

if newfit.pval < kit.findfitsettings.c13pval
    c13fit = newfit;
end


% figure;
% plot(hitcounts);


    

function whichi = significanthits(hitcounts,verbose)
hitcounts = hitcounts - 3;  %subtract off 3 guaranteed hits
lambda = mean(hitcounts);
pvals = poisscdf(hitcounts,lambda,'upper');
thresh = 0.1/length(hitcounts);
whichi = find(pvals < thresh);
ipvals = pvals(whichi);
[ipvals,XI] = sort(ipvals);
whichi = whichi(XI);
if verbose
    %figure;
    subplot(311);
    plot(0,0);
    subplot(1,1,1);
    plot(hitcounts);
    hold all;
    stickplot(whichi,hitcounts(whichi),'r');
    title(sprintf('%d significant hits found bestp = %3.1e\n',length(whichi),min(pvals)));
    xlabel('attempt');
    ylabel('hit count');
%     subplot(3,1,2);
%     x = 0:max(hitcounts) + 5;
%     y = poisspdf(x,lambda);
%     y2 = y*0;
%     for i = 1:length(x)
%         y2(i) = length(find(hitcounts == x(i)))/length(hitcounts);
%     end
%     plot(x,y,'bs');
%     hold all;
%     plot(x,y2,'rs');
%     legend(sprintf('possion, lambda = %3.2f',lambda),'hitcount');
%     subplot(3,1,3);
%     x = 0:max(hitcounts) + 5;
%     y = poisspdf(x,lambda);
%     for i = 1:length(x)
%         y2(i) = length(find(hitcounts == x(i)))/length(hitcounts);
%     end
%     plot(x,y,'bs');
%     hold all;
%     plot(x,y2,'rs');
%     legend(sprintf('possion, lambda = %3.2f',lambda),'hitcount');
%     ylim([0 .01]);
end

function df = dfmax(dfdABC,dABC)
vvals = {[1 1 1]',[1 1 -1]',[1 -1 1]',[1 -1 -1]'};
for i = 1:4
    dfs(i) = dfdABC * (dABC' .* vvals{i}); 
end
df = max(abs(dfs));

function line = addSpurs(line,heighttouse,kit,dfdABC,dABC)
1;

df = dfmax(dfdABC,dABC);

line.spurhthresh = line.(heighttouse) / kit.findfitsettings.heightratiomax;
% line.spurfmin = line.expf * kit.findfitsettings.freqmin;
% line.spurfmax = line.expf * kit.findfitsettings.freqmax;
line.spurfmin = line.theoryf - df;
line.spurfmax = line.theoryf + df;
spurhs = [];
spurfs = [];
for i = 1:length(kit.onedpeakfsunassigned)
    thisf = kit.onedpeakfsunassigned(i);
    thish = kit.onedpeakhsunassigned(i);
    if (thisf > line.spurfmin) && (thisf < line.spurfmax) && (thish > line.spurhthresh) % && (abs(thisf - line.expf) > .0001)
        spurfs(end+1) = thisf;
        spurhs(end+1) = thish;
    end
end
line.numspurs = length(spurfs);
line.spurfs = spurfs;
line.spurhs = spurhs;
line.spurdescription = sprintf('%d spurs from %s',line.numspurs,line.descriptor);

function bestlines = findgoodsub(fit,kit)
%first task is pick lines to use for the search.  For now, pick just 3?
%Maybe I can use ALL for confirmation
bestlines = 0;
exphs = extractonefieldfromcellarray(fit.lines,fit.heighttouse);
hthresh = min(kit.onedpeakhsunassigned);
maxscore = 0;
for i = 1:kit.findfitsettings.dicerolls
    sublines = findasub(fit,exphs,hthresh,kit.findfitsettings.minSNR);
   % disp(sublines.descriptor);
    if sublines.healthy
        if sublines.netscore > maxscore
            bestlines = sublines;
            maxscore = bestlines.netscore;
        end
    end
end
if maxscore == 0
    fprintf('No healthy triad found');
else
    fprintf('picking sublines %s\n',bestlines.descriptor);
end

function targets = findTargets(fit,kit)
targets = 0;
exphs = extractonefieldfromcellarray(fit.lines,fit.heighttouse);
[exphs,XI] = sort(exphs,'descend');
hthresh = min(kit.onedpeakhsunassigned) * kit.findfitsettings.targetminheight;
possibles = find(exphs > hthresh);
if length(possibles) < min(kit.findfitsettings.numtargetmax)
    fprintf('Not enough strong targets');
    return
else
    clear targets;
    numTargets = length(possibles);
    exphs = exphs(1:numTargets);
    XI = XI(1:numTargets);
    
end
   
%numTargets = min(kit.findfitsettings.numtargetmax,length(exphs));

targets.indices = XI;
targets.useheights = exphs;


targets = updatetargets(targets,fit,0);
targets = addmaps(targets,kit);

function targets = addmaps(targets,kit)
for i = 1:length(targets.linelist)
    thisline = targets.linelist{i};
    thisline.useheight = targets.useheights(i);
    c = containers.Map({0},{0});
    remove(c,0);
    thisline.lineContainer = c;
    targets.linelist{i} = thisline;
end
    
frange = max(kit.onedpeakfsunassigned) - min(kit.onedpeakfsunassigned);
numblips = length(kit.onedpeakfsunassigned);
freqpixel = kit.findfitsettings.freqpixel;
autofreqpixel = 0.1 * frange/numblips;
targets.hashreport = sprintf('%d blips are %3.1f wide, auto recommends %3.1f\n',numblips,freqpixel,autofreqpixel);
c = containers.Map({0},{0});
remove(c,0);
for ii = 1:length(kit.onedpeakfsunassigned)
    i = 1 + length(kit.onedpeakfsunassigned) - ii;  %go backwards
    thisf = kit.onedpeakfsunassigned(i);
    thish = kit.onedpeakhsunassigned(i);
    thishash = floor(thisf/kit.findfitsettings.freqpixel);
    c(thishash) = thisf;
    c(thishash+1) = thisf;
    for j = 1:length(targets.linelist)
        thisline = targets.linelist{j};
        thisbasef = thisline.theoryf;
        thisbaseh = thisline.useheight;
        if (abs(thisbasef - thisf)/thisbasef) < kit.findfitsettings.fdriftmax  %spur is close enough
            if thish > (thisbaseh * kit.findfitsettings.spurratiomin)   %spur is high enough
                targets.linelist{j}.lineContainer(thishash) = thisf;
                targets.linelist{j}.lineContainer(thishash+1) = thisf;
            end
        end
    end
end
for i = 1:length(targets.linelist)
    thisline = targets.linelist{i};
    targetspurs = stripcellarray(thisline.lineContainer.values());
    targetkeys = stripcellarray(thisline.lineContainer.keys());
   
    thisline.numtargetspurs = length(targetspurs);
    thisline.targetspurrange = [min(targetspurs) max(targetspurs)];
    thisline.targetfpixel = (max(targetspurs) - min(targetspurs)) / thisline.numtargetspurs;
    thisline.dupelevel = floor(kit.findfitsettings.targetoccupancy * ((max(targetkeys) - min(targetkeys)) / thisline.numtargetspurs) / 2);
    
    c2 = containers.Map(thisline.lineContainer.keys,thisline.lineContainer.values);
    for j = targetkeys
        for kk = j-thisline.dupelevel:j+thisline.dupelevel
            c2(kk) = c2(j);
        end
    end
    thisline.broadlineContainer = c2;
    targets.linelist{i} = thisline;
end

targets.kitContainer = c;


1;



function targets = updatetargets(targets,fit,ABCindex)
targets.numtargets = length(targets.indices);
fMatrix = zeros(targets.numtargets,3);
flist = zeros(targets.numtargets,1);
linearerrorlist = zeros(targets.numtargets,1);
linelist = {};

for i = 1:targets.numtargets %use as many targets as possibple
    j = targets.indices(i);
    if ABCindex == 0 
        thisline = fit.lines{j};
    else
        thisline = fit.stretchlinesets{ABCindex}.lineset{j};
    end
    %thisline = fit.lines{j};
    flist(i) = thisline.theoryf;
    linearerrorlist(i) = thisline.linearerror;
    fMatrix(i,:) = thisline.dfdABC;
    linelist{i} = thisline;
end

targets.fList = flist;
targets.fMatrix = fMatrix;
targets.linearerrorlist = linearerrorlist;
targets.numtargets = length(flist);
targets.linelist = linelist;
targets.descriptor = sprintf('%d targets found',targets.numtargets);
1;
%at this point, fpredicts = flist + fMatrix * dABC.

function sublines = updatesublines(sublines,fit)
%fit is only needed if stetchindex ~= 0
    sublines.hs = [sublines.line1.(sublines.heighttouse) sublines.line2.(sublines.heighttouse) sublines.line3.(sublines.heighttouse)];
    sublines.hashes = [sublines.line1.hash sublines.line2.hash sublines.line3.hash];
    sublines.minh = min(sublines.hs);
    
    
    sublines.dffromdABC = zeros(3);
    
    if sublines.stretchindex == 0
        line1 = sublines.line1;
        line2 = sublines.line2;
        line3 = sublines.line3;
    else
        line1 = fit.stretchlinesets{sublines.stretchindex}.lineset{sublines.ivals(1)};
        line2 = fit.stretchlinesets{sublines.stretchindex}.lineset{sublines.ivals(2)};
        line3 = fit.stretchlinesets{sublines.stretchindex}.lineset{sublines.ivals(3)};
        sublines.ABCxxxxx = fit.stretchlinesets{sublines.stretchindex}.absABCxxxxx;
    end
    sublines.line1.theoryf = line1.theoryf;
    sublines.line2.theoryf = line2.theoryf;
    sublines.line3.theoryf = line3.theoryf;
    if isfield(sublines.line1,'expf')
        sublines.rawfs = [sublines.line1.expf sublines.line2.expf sublines.line3.expf];
    else
        sublines.rawfs = [0 0 0];
    end
    sublines.linearerrors = [line1.linearerror line2.linearerror line3.linearerror];
    sublines.stretchedfs = [line1.theoryf line2.theoryf line3.theoryf];
    sublines.dffromdABC(1,:) = line1.dfdABC;
    sublines.dffromdABC(2,:) = line2.dfdABC;
    sublines.dffromdABC(3,:) = line3.dfdABC;
        
    sublines.dABCfromdf = sublines.dffromdABC^-1;
    sublines.eigs = eig(sublines.dffromdABC);
    sublines.det = det(sublines.dffromdABC);
    sublines.hscore = sublines.minh / sublines.hthresh;
    sublines.dscore = min(abs(sublines.eigs));
    sublines.linearscore = 1/max(sublines.linearerrors);
    
    sublines.types = [sublines.line1.transitiontype sublines.line2.transitiontype sublines.line3.transitiontype];
    sublines.numtypes = length(unique(sublines.types));
    sublines.netscore = max(sublines.numtypes,2); %sublines.hscore * (sublines.dscore^(1));

    if (sublines.hscore > sublines.minSNR)
        sublines.healthy = 1;
        sublines.descriptor = sprintf('good lineset, hscore %3.1f,dscore %3.1f, netscore %3.2f',sublines.hscore,sublines.dscore,sublines.netscore);
    else
        sublines.healthy = 0;
        sublines.descriptor = sprintf('sick lineset, hscore %3.1f,dscore %3.1f',sublines.hscore,sublines.dscore);
    end
    
function sublines = findasub(fit,exphs,hthresh,minSNR)
    sublines.hthresh = hthresh;
    ivals = pickn(exphs,3);
    sublines.ivals = ivals;
    sublines.minSNR = minSNR;
    sublines.line1 = fit.lines{ivals(1)};
    sublines.line2 = fit.lines{ivals(2)};
    sublines.line3 = fit.lines{ivals(3)};
    if isfield(fit,'fitdescriptor')
        sublines.parentfitdescriptor = fit.fitdescriptor;
    else
        sublines.parentfitdescriptor = 'No parent';
    end
    sublines.ABCxxxxx = fit.ABCxxxxx;
    sublines.stretchindex = 0;
    sublines.heighttouse = fit.heighttouse;
    sublines = updatesublines(sublines);
    
    



