function fit = quickseriesextend(fit,kit,recurselevel)
%quickextend decides if the fit has preditive power.  returns fields like
%fit.yesvotes: the number of predicted lines
%fit.novotes: the number of lines it is MISSING

% if (nargin > 0)
%     save('jfile');
%     
% else
%     load('jfile')
% end

fcloseyes = 0.06;
fcloseno = 2.0;
allfs = kit.onedpeakfs;
allhs = kit.onedpeakhs;
if isfield(kit,'allhs')
    thresh = min(kit.allhs) / 4;
    usablei = find(kit.onedpeakhs > thresh);
    fs = kit.onedpeakfs(usablei);
    hs = kit.onedpeakhs(usablei);
end

% fs = kit.usefs;
% hs = kit.usehs;
[fs XI] = sort(fs);
hs = hs(XI);
fmin = min(fs) + 50;
fmax = max(fs) - 50;
meanspacing = (fmax - fmin) / length(fs);

fthreshold = max(fcloseyes,meanspacing / 20);
argsin = fit.info.argsout;
jmin = fit.info.minj - 2;
jmax = fit.info.maxj + 4;
kmin = fit.info.minka - 1;
kmax = fit.info.maxka + 4;
argsin.hasa = 1;
argsin.hasb = 1;
argsin.hasc = 1;

%bestfit = extend_fit_fast(fit,kit,jargsin);
pairlist = spcatjrange(argsin,jmin,jmax,0,jmax);  %just do all k seems more stable
%[~,~,~,fit_info] = runspfit(argsout,testingcsvname,verbose);
hiths = [];
hitfs = [];
yesvotes = 0;
novotes = 0;
seriesnovotes = 0;
candidates = 0;
numinfit = 0;
troublevotes = 0;
[shortstring fulldescription] = stringfromfit(fit);
fit.fulldescription = fulldescription;
fit.shortdescription = shortstring;
description = ['extending ' shortstring];
extendtypestring = 'types:';
extendbranchstring = 'branches:';
pval = 1;
newlines = {};
alltheoryfs = extractfieldsfromcellarray(pairlist,{'delf'});
alltheoryfs = alltheoryfs.delf;
hitis = [];
for i = 1:length(pairlist)
    thispair = pairlist{i};
    testable = 1;
    dangeroustheory = 0;
    thisf = thispair.delf;
    if i == 1
        nearestferror = abs(alltheoryfs(2) - thisf);
    elseif i == length(pairlist)
        nearestferror = abs(alltheoryfs(i-1) - thisf);
    else
        nearestferror = min(abs(alltheoryfs(i+1) - thisf),abs(alltheoryfs(i-1) - thisf));
    end
    
    if nearestferror < (2*fthreshold)
        1;
    end
    if (thispair.delf < fmin) || (thispair.delf > fmax)
        testable = 0;
    end
    if (thispair.startka > kmax) || (thispair.endka > kmax) || (thispair.startka < kmin) || (thispair.endka < kmin)
        testable = 0;
    end
    if (abs(thispair.delj) > 1) || (abs(thispair.delka) > 1) || (abs(thispair.delkc) > 1)
        testable = 0;
    end
%     if ((fit.assigntask.hasa == 0) && (thispair.transitiontype == 'a')) || ...
%             ((fit.assigntask.hasb == 0) && (thispair.transitiontype == 'b')) || ...
%             ((fit.assigntask.hasc == 0) && (thispair.transitiontype == 'c'))
%         testable = 0;
%     end
    if testable
        
        candidates = candidates+1;
%         yesvote = 0;
%         novote = 0;
%         switch thispair.transitiontype
%             case 'a'
%                 s = fit.assigntask.astrength;
%             case 'b'
%                 s = fit.assigntask.bstrength;
%             case 'c'
%                 s = fit.assigntask.cstrength;
%         end
    
        inseries = pairinseries(thispair,fit);
        inclass = pairinclass(thispair,fit);
        infit = pairinfit(thispair,fit);
        
        delfs = abs(fs - thispair.delf);
        besti = find(delfs == min(delfs),1,'first');
        oneunder = max(1,besti-1);
        oneover = min(besti,length(delfs));
        
        delf = delfs(besti);
        dangerousspectrum = 0;
        if (length(oneunder) > 0) && (length(oneover) > 0)
            seconddelf = min(delfs(oneunder),delfs(oneover));
            if seconddelf < (fthreshold * 2)
                dangerousspectrum = 1;
            end
        end
        h = hs(besti);
        %if  (delf < fthreshold) && (dangerousspectrum == 0) && (dangeroustheory == 0)
        if  (delf < fthreshold)% && (dangerousspectrum == 0) && (dangeroustheory == 0)
            
            newline = linedfrompair(thispair,fs(besti));

            hiths(end+1) = h;
            hitfs(end+1) = fs(besti);
            if (thispair.delj == 0)
                extendbranchstring = [extendbranchstring 'Q'];
            else
                extendbranchstring = [extendbranchstring 'R'];
            end
            extendtypestring = [extendtypestring thispair.transitiontype];
            allfs = kit.onedpeakfs;

            newdelfs = abs(allfs - thispair.delf);
            newbesti = find(newdelfs == min(newdelfs),1,'first');
            hitis(end+1) = newbesti;
            yesvotes = yesvotes+1;
            if infit == 1
                numinfit = numinfit+1;
            end
            if inclass == 1
                newlines{end+1} = newline;
            end
            df = max(delf,0.002);
            pval = pval * df / meanspacing;

            

            description = sprintf('%s\n new hit  %s delf=%3.2f from %3.2f',description,thispair.shortdescription,delf,thispair.delf);
            
        end
        if (delf > fcloseno)
            
            if (infit == 0) && (inseries == 1)
                seriesnovotes = seriesnovotes+1;
            end
            if (infit == 0) && (inclass == 1)
                %novote = 1;
                novotes = novotes+1;
                description = sprintf('%s\n new miss %s delf=%3.2f from %3.2f',description,thispair.shortdescription,delf,thispair.delf);
            else
                description = sprintf('%s\n old miss !!!!!! %s delf=%3.2f from %3.2f',description,thispair.shortdescription,delf,thispair.delf);
                troublevotes = troublevotes+1;
            end
        end
    end
end

fit.pval = pval;
fit.extendtypestring = extendtypestring;
fit.extendbranchstring = extendbranchstring;
fit.extendstring = sprintf('extend %3.1e with %d upvotes, %d downvotes\n %s, %s\n',pval,yesvotes,novotes,fit.extendtypestring,fit.extendbranchstring);
fit.shortextendstring = sprintf('extend %3.1e with %d upvotes, %d downvotes\n',pval,yesvotes,novotes);
fit.hitis = hitis;
fit.candidates = candidates;
fit.numinfit = numinfit;
fit.yesvotes = yesvotes;
fit.novotes = novotes;
fit.seriesnovotes = seriesnovotes;
fit.troublevotes = troublevotes;
fit.numlines = length(fit.info.lines);
fit.extendeddescription = description;
if (length(newlines) > 12) && (recurselevel > 0)
    newfit = fit;
    newfit.info.lines = newlines;
    newfit = quickspfit(newlines,[fit.info.params.a fit.info.params.b fit.info.params.c]);
%    newfit = runspfit_from_fit(newfit,0);
    newfit = quickseriesextend(newfit,kit,recurselevel-1);
    newfit.originallines = fit.info.lines;
    fit = newfit;
end
   
% figure;
% subplot(1,1,1);
% stickplot(kit.onedpeakfs,kit.onedpeakhs,'r');
% hold all;
% plot(kit.freqs1d,kit.amps1d,'b');
%  stickplot(hitfs,-hiths,'m');
% addtext(fit.extendeddescription);
% 1;

function inclass = pairinclass(pair,fit)
%returns 1 if pair is in a class - that is, same branch and type - with
%part of a fit.  downvotes on these are pretty bad.
inclass = 0;
for i = 1:length(fit.info.lines)
    thisline = fit.info.lines{i};
    thistype = findtype(thisline);
    thisbranch = findbranch(thisline);
    if pair.delj == 0
        pairbranch = 'Q';
    else
        pairbranch = 'R';
    end
    if (thistype == pair.transitiontype) && (thisbranch == pairbranch)
           inclass = 1;
           break;
    end
    
end

function inseries = pairinseries(pair,fit)
 inseries = pairinseriesa(pair,fit) || pairinseriesa(flippair(pair),fit);
 
function inseries = pairinseriesa(pair,fit)
%returns 1 if pair is in a series with part on the fit. downvotes on these
%are super bad.

inseries = 0;
for i = 1:length(fit.info.lines)
    thisline = fit.info.lines{i};
    deltaJ = thisline.Jupper - pair.startj;
    if (thisline.Jupper == (pair.startj + deltaJ)) && ...
       (thisline.Jlower == (pair.endj + deltaJ)) && ...
       (thisline.Kaupper == pair.startka) && ...
       (thisline.Kalower == pair.endka) && ...
       (thisline.Kcupper == (pair.startkc + deltaJ)) && ...
       (thisline.Kclower == (pair.endkc + deltaJ))
           inseries = 1;
           break;
    end
end

function newline = linedfrompair(pair,expf)
    newline.Jupper = pair.startj;
    newline.Kaupper = pair.startka;
    newline.Kcupper = pair.startkc;

    newline.Jlower = pair.endj;    
    newline.Kalower = pair.endka;
    newline.Kclower = pair.endkc;
    newline.expfreq = expf;

function infit = pairinfit(pair,fit)
 infit = pairinfita(pair,fit) || pairinfita(flippair(pair),fit);


function infit = pairinfita(pair,fit)
%returns 1 if pair is already part of the fit
infit = 0;
for i = 1:length(fit.info.lines)
    thisline = fit.info.lines{i};
    if (thisline.Jupper == pair.startj) && ...
       (thisline.Jlower == pair.endj) && ...
       (thisline.Kaupper == pair.startka) && ...
       (thisline.Kalower == pair.endka) && ...
       (thisline.Kcupper == pair.startkc) && ...
       (thisline.Kclower == pair.endkc) 
           infit = 1;
           break;
    end
end

function pairout = flippair(pairin)
%pairout = pairin;
pairout.startj = pairin.endj;
pairout.startka = pairin.endka;
pairout.startkc = pairin.endkc;
pairout.endj = pairin.startj;
pairout.endka = pairin.endka;
pairout.endkc = pairin.endkc;




