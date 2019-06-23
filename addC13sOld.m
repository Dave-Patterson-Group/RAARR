function fit = addC13s(fit,kit)
if nargin == 2
    save('tfile','fit','kit')  %'tfile is 
else
    load('tfile','fit','kit');
    kit.tightnesssettings = settingsfromtightness(kit.tightnesssettings.scalartightness); %update tightness
end
kit = addfittokit(kit,fit);
originalkit = kit;
allisotopes = {};
nummisses = 0;
fit.isotopes = {};
f = 0;
for i = 1:kit.tightnesssettings.isotopefitting.numtrials
    sublines = findgoodsub(fit,kit);
    if (isstruct(sublines) == 1)
        sublines.targets = findTargets(fit,kit);
    end
    if (isstruct(sublines) == 1) && (isstruct(sublines.targets) == 1)
      
        [isotopefit kit] = findIsotopeFit(sublines,kit);
        if isstruct(isotopefit)
            fprintf('%s YES\n',sublines.descriptor);
            allisotopes{end+1} = isotopefit;
            %         if f ~= 0
            %             close f
            %         end
            %         f = displaykitwithfits(kit);
            
            allisotopes = sortcellarraybyfield(allisotopes,'A');
            nummisses = 0;
            
            
            fprintf('\n\ntotal of %d isotopologues found\n======\n',length(allisotopes));
        else
            nummisses = nummisses +1;
            fprintf('%s NO\n',sublines.descriptor);
            fprintf('No new isotope found, %d misses in a row\n',nummisses);
        end
    else
        nummisses = nummisses +1;
        fprintf('No targets found, %d misses in a row\n',nummisses);
    end
    if nummisses > kit.tightnesssettings.isotopefitting.maxmisses
        break;
    end
    
end
kit = originalkit;
for i = 1:length(allisotopes)
    newfit = allisotopes{i};
    [frac,count,fracstring] = fitfrac(fit,newfit);
    newfit.C13frac = frac;
    newfit.C13count = count;
    newfit.C13string = fracstring;
    newfit.longdescription = newfit.C13string;
    allisotopes{i} = newfit;
    kit = addfittokit(kit,newfit);
    
end
displaykitwithfits(kit);
fit.isotopes = allisotopes;
1;


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
    df1 = sublines.line1.spurfs(i) - sublines.line1.expf;
    df2 = sublines.line2.spurfs(j) - sublines.line2.expf;
    df3 = sublines.line3.spurfs(k) - sublines.line3.expf;
    df = [df1 df2 df3]';
    dABC = sublines.dABCfromdf * df;
    targetfs = sublines.targets.fList + (sublines.targets.fMatrix * dABC);
    hashes = round(targetfs/kit.tightnesssettings.isotopefitting.freqpixel); %half way between floor and floor+1
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
        for i = 1:numhits
            thisi = whichhits(i);
            foundf = sublines.targets.kitContainer(hashes(thisi));
            thisline = sublines.targets.linelist{thisi};
            thisline.orginalexpf = thisline.expf;
            thisline.orginalexph = thisline.exph;
           
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
    end
    
function sublines = addAllSpurs(sublines,kit)
    sublines.line1 = addSpurs(sublines.line1,kit);
    sublines.line2 = addSpurs(sublines.line2,kit);
    sublines.line3 = addSpurs(sublines.line3,kit);
    sublines.totaltriads = sublines.line1.numspurs * sublines.line2.numspurs * sublines.line3.numspurs;

function [c13fit,kit] = findIsotopeFit(sublines,kit)
sublines = addAllSpurs(sublines,kit);
c13fit = 0;

[ivals,jvals,kvals,hitcounts] = ijkvals(sublines);
bestyet = 0;
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

whichi = significanthits(hitcounts,0);
if length(whichi) > 0
    whichi = whichi(1);  %just pursue best one for now.
end


%returns fraction of child in parent
for i = 1:length(whichi)
    [numhits ijk df dABC thisset] = extrappoint(sublines,whichi(i),ivals,jvals,kvals,kit,1);
    1;  %do I have ABC here?
    %thisfit = quickspfit(thistrial.lineset,thistrial.ABC);
    %newfit = myquickspfit(thisset.triadlines,sublines.ABCxxxxx,0);
  %  newfit = quickspfit(thisset.triadlines,sublines.ABCxxxxx,0);
    fprintf('Parent fit:\n%s\n',sublines.parentfitdescriptor);
    newfit = quickspfit(thisset.c13lines,sublines.ABCxxxxx,0);
    newfit.patterntype = 'C13extension';
    newfit = testfitonkit(newfit,kit);
%    newfit.C13frac = fitfrac(parentfit,childfit);
  %  newerfit2 = evolveFit(newerfit2,kit,'broadpval'); %seems to never help, explore.
%     dABC2 = sublines.ABCxxxxx - newerfit2.ABCxxxxx;
%     dABC
%     dABC2
    
    if newfit.pval < kit.tightnesssettings.isotopefitting.c13pval
        c13fit = newfit;
        kit = addfittokit(kit,newfit);
    end
end

% figure;
% plot(hitcounts);

function [fitamount numoverlap fracstring] = fitfrac(parentfit,childfit)
fitfracs = [];
for i = 1:length(parentfit.lines)
    for j = 1:length(childfit.lines)
        parentline = parentfit.lines{i};
        childline = childfit.lines{j};
        if parentline.hash == childline.hash
            fitfracs(end+1) = childline.exph / parentline.exph;
        end
    end
end
if length(fitfracs) == 0
    fitamount = NaN;
    numoverlap = 0;
    fracstring = 'No overlap, should be impossibles';
else
    fitamount = mean(fitfracs);
    numoverlap = length(fitfracs);
    fracstring = sprintf('%3.3f fraction from %d overlapped lines',fitamount,numoverlap);
end
    

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
    figure;
    subplot(3,1,1);
    plot(hitcounts);
    hold all;
    stickplot(whichi,hitcounts(whichi),'r');
    title(sprintf('%d significant hits found bestp = %3.1e\n',length(whichi),min(pvals)));
    xlabel('attempt');
    ylabel('hit count');
    subplot(3,1,2);
    x = 0:max(hitcounts) + 5;
    y = poisspdf(x,lambda);
    for i = 1:length(x)
        y2(i) = length(find(hitcounts == x(i)))/length(hitcounts);
    end
    plot(x,y,'bs');
    hold all;
    plot(x,y2,'rs');
    legend(sprintf('possion, lambda = %3.2f',lambda),'hitcount');
    subplot(3,1,3);
    x = 0:max(hitcounts) + 5;
    y = poisspdf(x,lambda);
    for i = 1:length(x)
        y2(i) = length(find(hitcounts == x(i)))/length(hitcounts);
    end
    plot(x,y,'bs');
    hold all;
    plot(x,y2,'rs');
    legend(sprintf('possion, lambda = %3.2f',lambda),'hitcount');
    ylim([0 .01]);
end

function line = addSpurs(line,kit)
1;

line.spurhthresh = line.exph / kit.tightnesssettings.isotopefitting.heightratiomax;
line.spurfmin = line.expf * kit.tightnesssettings.isotopefitting.freqmin;
line.spurfmax = line.expf * kit.tightnesssettings.isotopefitting.freqmax;
spurhs = [];
spurfs = [];
for i = 1:length(kit.onedpeakfsunassigned)
    thisf = kit.onedpeakfsunassigned(i);
    thish = kit.onedpeakhsunassigned(i);
    if (thisf > line.spurfmin) && (thisf < line.spurfmax) && (thish > line.spurhthresh) && (abs(thisf - line.expf) > .0001)
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
exphs = extractonefieldfromcellarray(fit.lines,'exph');
hthresh = min(kit.onedpeakhsunassigned);
maxscore = 0;
for i = 1:kit.tightnesssettings.isotopefitting.dicerolls
    sublines = findasub(fit,exphs,hthresh);
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
exphs = extractonefieldfromcellarray(fit.lines,'exph');
[exphs,XI] = sort(exphs,'descend');
hthresh = min(kit.onedpeakhsunassigned) * kit.tightnesssettings.isotopefitting.targetminheight;
possibles = find(exphs > hthresh);
if length(possibles) < min(kit.tightnesssettings.isotopefitting.numtargetmax)
    fprintf('Not enough strong targets');
    return
else
    clear targets;
    numTargets = length(possibles);
    exphs = exphs(1:numTargets);
    XI = XI(1:numTargets);
    
end
   
%numTargets = min(kit.tightnesssettings.isotopefitting.numtargetmax,length(exphs));
fMatrix = zeros(numTargets,3);
flist = zeros(numTargets,1);
linelist = {};
for i = 1:length(exphs) %use as many targets as possibple
    j = XI(i);
    thisline = fit.lines{j};
    flist(i) = thisline.expf;
    fMatrix(i,:) = thisline.dfdABC;
    linelist{i} = thisline;
end
c = containers.Map({0},{0});
for i = 1:length(kit.onedpeakfsunassigned)
    thishash = floor(kit.onedpeakfsunassigned(i)/kit.tightnesssettings.isotopefitting.freqpixel);
    c(thishash) = kit.onedpeakfsunassigned(i);
    c(thishash+1) = kit.onedpeakfsunassigned(i);
end

targets.fList = flist;
targets.fMatrix = fMatrix;
targets.kitContainer = c;
targets.numtargets = length(flist);
targets.linelist = linelist;
targets.descriptor = sprintf('%d targets found',targets.numtargets);
1;
%at this point, fpredicts = flist + fMatrix * dABC.

function sublines = findasub(fit,exphs,hthresh)
    sublines.hthresh = hthresh;
    ivals = pickn(exphs,3);
    sublines.line1 = fit.lines{ivals(1)};
    sublines.line2 = fit.lines{ivals(2)};
    sublines.line3 = fit.lines{ivals(3)};
    sublines.hs = [sublines.line1.exph sublines.line2.exph sublines.line3.exph];
    sublines.hashes = [sublines.line1.hash sublines.line2.hash sublines.line3.hash];
    sublines.minh = min(sublines.hs);
    sublines.ABCxxxxx = fit.ABCxxxxx;
    sublines.parentfitdescriptor = fit.fitdescriptor;
    sublines.dffromdABC = zeros(3);
    sublines.dffromdABC(1,:) = sublines.line1.dfdABC;
    sublines.dffromdABC(2,:) = sublines.line2.dfdABC;
    sublines.dffromdABC(3,:) = sublines.line3.dfdABC;
    sublines.dABCfromdf = sublines.dffromdABC^-1;
    sublines.eigs = eig(sublines.dffromdABC);
    sublines.det = det(sublines.dffromdABC);
    sublines.hscore = sublines.minh / sublines.hthresh;
    sublines.dscore = min(abs(sublines.eigs));
    sublines.types = [sublines.line1.transitiontype sublines.line2.transitiontype sublines.line3.transitiontype];
    sublines.numtypes = length(unique(sublines.types));
    sublines.netscore = sublines.numtypes; %sublines.hscore * (sublines.dscore^(1));

    if (sublines.hscore > 200)
        sublines.healthy = 1;
        sublines.descriptor = sprintf('good lineset, hscore %3.1f,dscore %3.1f, netscore %3.2f',sublines.hscore,sublines.dscore,sublines.netscore);
    else
        sublines.healthy = 0;
        sublines.descriptor = sprintf('sick lineset, hscore %3.1f,dscore %3.1f',sublines.hscore,sublines.dscore);
    end
    

