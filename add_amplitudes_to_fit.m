function [newfit] = add_amplitudes_to_fit(smallfit,kit,showheights,forcealltypes)
%add_amplitudes_to_fit runs the fit via spcat, and adds a category 'scaledstength' to pairlist.
%it also returns the following in newfit
%forcealltypes 
%structures:
%newfit.atheoryfreqs
%newfit.btheoryheights
%and so on

%forcealltypes makes it consider at least weak lines of all types.  without
%this an initial fit on types a and b will never expand..

if nargin < 3
    showheights = 0;
end

if nargin < 4
    forcealltypes = 0;
end

%[types hasa hasb hasc alltypes] = findtypesinfit(smallfit);

%typical call is runspfit_from_fit(good_fits{1});
argsin = prepare_sp_argsin();
molstats = argsin.molstats;
mol_info = smallfit.info.argsout;
%now massage molstats to fit mol_info
molstats.a = mol_info.a/1000;
molstats.b = mol_info.b/1000;
molstats.c = mol_info.c/1000;
molstats.DJ = mol_info.DJ/1000;
molstats.DJK = mol_info.DJK/1000;
molstats.DK = mol_info.DK/1000;
molstats.deltaJ = mol_info.deltaJ/1000;
molstats.deltaK = mol_info.deltaK/1000;
molstats.mua = 1;
molstats.mub = 1;
molstats.muc = 1;
Js = extractfieldsfromcellarray(smallfit.info.lines,{'Jupper','Jlower'});

%  add jmax stuff extractfieldsfromcellarray
% argsout.jmin = max(jmin,0);
%     argsout.jmax = jmax;
%     argsout.kmin = max(kmin,0);
%     argsout.kmax = kmax;
argsin.jmax = max([Js.Jupper Js.Jlower]) + 4;
argsin.jmin = min([Js.Jupper Js.Jlower]) - 4;
argsin.jmin = max(argsin.jmin,0);
argsin.molstats = molstats;
allpairs = runspcat(argsin,1);

[atheoryfreqs atheoryheights aexpfreqs aexpheights afactor] = checkheights(smallfit,allpairs,kit,'a');
[btheoryfreqs btheoryheights bexpfreqs bexpheights bfactor] = checkheights(smallfit,allpairs,kit,'b');
[ctheoryfreqs ctheoryheights cexpfreqs cexpheights cfactor] = checkheights(smallfit,allpairs,kit,'c');
if forcealltypes
    meanfactor = mean([afactor bfactor cfactor]);
    afactor = max(afactor,meanfactor/5);
    bfactor = max(bfactor,meanfactor/5);
    cfactor = max(cfactor,meanfactor/5);
end
if max([afactor bfactor cfactor]) == 0
    afactor = 0.1;
    bfactor = 0.1;
    cfactor = 0.1;
end
newfit = smallfit;
newfit.afactor = afactor;
newfit.bfactor = bfactor;
newfit.cfactor = cfactor;
newfit.aexpheights = aexpheights;
newfit.bexpheights = bexpheights;
newfit.cexpheights = cexpheights;

newfit.aexpfreqs = aexpfreqs;
newfit.bexpfreqs = bexpfreqs;
newfit.cexpfreqs = cexpfreqs;

newfit.atheoryheights = atheoryheights * afactor;
newfit.btheoryheights = btheoryheights * bfactor;
newfit.ctheoryheights = ctheoryheights * cfactor;
newfit.atheoryfreqs = atheoryfreqs;
newfit.btheoryfreqs = btheoryfreqs;
newfit.ctheoryfreqs = ctheoryfreqs;
newfit.linetypes = '';
if length(newfit.atheoryheights) > 0
    newfit.linetypes(end+1) = 'a';
end
if length(newfit.btheoryheights) > 0
    newfit.linetypes(end+1) = 'b';
end
if length(newfit.ctheoryheights) > 0
    newfit.linetypes(end+1) = 'c';
end

newfit.alltheoryheights = [newfit.atheoryheights newfit.btheoryheights newfit.ctheoryheights];
newfit.alltheoryfreqs = [newfit.atheoryfreqs newfit.btheoryfreqs newfit.ctheoryfreqs];
newfit.numlines = length(newfit.alltheoryfreqs);
newfit.meantheoryheight = mean(newfit.alltheoryheights);
if length(newfit.alltheoryheights) == 0
    sixk = extractfieldsfromcellarray(allpairs,{'sixKweakpulsestrength'});
    newfit.meantheoryheight = mean(sixk.sixKweakpulsestrength);
end
strongpairs = {};
allstrengths = zeros(1,length(allpairs));
for i = 1:length(allpairs)
    thispair = allpairs{i};
    switch thispair.transitiontype
        case 'a'
            thispair.scaledstrength = thispair.sixKweakpulsestrength * afactor;
        case 'b'
            thispair.scaledstrength = thispair.sixKweakpulsestrength * bfactor;
        case 'c'
            thispair.scaledstrength = thispair.sixKweakpulsestrength * cfactor;
    end
    thispair.fitscaledstrength = 0;
    allstrengths(i) = thispair.scaledstrength;
    thispair.infit = 0;
    allpairs{i} = thispair;
end
newfit.allstrengths = allstrengths;

%fprintf('afactor %3.3f, bfactor %3.3f, cfactor %3.3f\n',afactor,bfactor,cfactor);

for i = 1:length(smallfit.info.lines)
    thisline = smallfit.info.lines{i};
    
    [thispair thisi] = pullpair(allpairs,thisline);
    if thisi > 0
        thispair.infit = 1;
        thispair.fitscaledstrength = thispair.scaledstrength;
        allpairs{thisi} = thispair;
    else
        fprintf('warning!  a fit pair is missing from spcat run\n');
    end
end

if showheights
    figure('Name','heights adjust');
    plot(kit.freqs1d,-kit.amps1d,'c')
    hold all;
    plotpairs(allpairs,'scaledstrength','b');
    
    plot(newfit.atheoryfreqs,-newfit.atheoryheights,'rd');
    plot(newfit.btheoryfreqs,-newfit.btheoryheights,'bs');
    plot(newfit.ctheoryfreqs,-newfit.ctheoryheights,'cs');
    
    plot(newfit.aexpfreqs,-newfit.aexpheights,'rs','MarkerSize',3);
    plot(newfit.bexpfreqs,-newfit.bexpheights,'bs','MarkerSize',3);
    plot(newfit.cexpfreqs,-newfit.cexpheights,'cs','MarkerSize',3);
    
    legend('data','scaled factor','atype','btype');
    title(sprintf('afactor %3.1f, bfactor %3.1f, cfactor %3.1f\n',afactor,bfactor,cfactor));
end

% 
% newpairlist = allpairsnewmu;
% newfit = smallfit;
% newfit.concentration = concentration;
% newfit.mua = newmua;
% newfit.mub = newmub;
% newfit.muc = newmuc;
% newfit.aheights = aheights;
% newfit.bheights = bheights;
% newfit.cheights = cheights;
% newfit.afreqs = afreqs;
% newfit.bfreqs = bfreqs;
% newfit.cfreqs = cfreqs;
% newfit.meanheight = meanheight;
% newfit.spcatargsin = argsin;
%put in code here to only keep reasonable pairs??
newfit.allpairs = allpairs;

%displayspfit(newfit,kit);
% figure;
% hold all;
% plot(kit.freqs1d,kit.amps1d,'c')
% plot(afreqs,aheights,'rs');
% plot(bfreqs,bheights,'ks');
% plot(cfreqs,cheights,'os');
% a = xlim;
% plotpairs(allpairsnewmu,'sixKweakpulsestrength-','b',concentration);
% xlim(a);
% fancystickies();


function [atheoryfreqs atheoryheights aexpfreqs aexpheights afactor] = checkheights(smallfit,allpairs,kit,whichtype)
%returns the freqs and heights of the lines within smallfit of type
%whichtype
[types hasa hasb hasc alltypes] = findtypesinfit(smallfit);
atheoryheights = [];
atheoryfreqs = [];
aexpfreqs = [];
aexpheights = [];
if contains(types,whichtype)
    atypeindex = find(alltypes == whichtype);
    
    for ai = atypeindex
        %expheight = kit.predicths(ai);  %no! index directly to 
      %  disp(smallfit.info.lines{ai});
        if length(smallfit.info.lines{ai}.Jupper) > 1
            1;
        end
        atypepair = pullpair(allpairs,smallfit.info.lines{ai}); %this finds the line
     
        [expheight expfreq] = pullheight(smallfit.info.lines{ai}.calcfreq,kit);
        theoryheight = atypepair.sixKweakpulsestrength;
        spcattheoryfreq = atypepair.delf;
        spfittheoryfreq = smallfit.info.lines{ai}.calcfreq;
      %  fprintf('spfit says %3.6f MHz,spcat says %3.6f MHz, experiment %3.6f MHz\n',spfittheoryfreq,spcattheoryfreq,expfreq);
        aexpheights(end+1) = expheight;
        aexpfreqs(end+1) = expfreq;
        atheoryfreqs(end+1) = smallfit.info.lines{ai}.calcfreq;
        atheoryheights(end+1) = theoryheight;
    end
%     meanaheight = mean(aheights);
%     meanatheoryheight = mean(atheoryheights);
  
   % fprintf('%d %c-type lines; new mu%c %3.2f\n',length(atypeindex),whichtype,whichtype,newmua);
    afactor = mean(aexpheights) / mean(atheoryheights);
else
    
    afactor = 0;
end

function [height freq ferror] = pullheight(f,kit)
%returns h
ferrors = abs(kit.onedpeakfs - f);
besti = find(ferrors == min(ferrors));
height = kit.onedpeakhs(besti);
freq = kit.onedpeakfs(besti);
ferror = ferrors(besti);

% 
