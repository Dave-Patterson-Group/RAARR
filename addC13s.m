function fit = addC13s(fit,kit)
if nargin == 2
    save('tfile','fit','kit')  %'tfile is 
else
    load('tfile','fit','kit');
    kit.tightnesssettings = settingsfromtightness(kit.tightnesssettings.scalartightness); %update tightness
end

fit = applyfittokit(fit,kit,0);
plotlinelist(fit.matches)

kit = addfittokit(kit,fit);
%addC13sfromwithlinelist(fit,kit,linelist)

linestouse.lines = fit.matches;
linestouse.heighttouse = 'predictedh';
linestouse.fitdescriptor = fit.fitdescriptor(6:end);
linestouse.ABCxxxxx = fit.ABCxxxxx;
%addC13swithlinelist 

fit.isotopes = {};
f = 0;
[ABClist,dAdBdC] = getABClist(fit.ABCxxxxx(1:3));

linestouse.ABClist = ABClist;
linestouse.dAdBdC = dAdBdC;

kit.findfitsettings = kit.tightnesssettings.isotopefitting;
allisotopes = findfits(linestouse,kit);

for i = 1:length(allisotopes)
    %rng(i+2);
    newfit = allisotopes{i};
    [frac,count,fracstring] = fitfrac(linestouse,newfit);
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

function [ABClist,dAdBdC] = getABClist(ABC)
    dAdBdC = [.01 .01 .01];
    ABClist = {};
    ABClist{1} = ABC;
    ABClist{end+1} = ABC .* [.99 .99 .99]; %in absolute MHz
    ABClist{end+1} = ABC .* [.98 .99 .99];
    ABClist{end+1} = ABC .* [.98 .98 .98];
    ABClist{end+1} = ABC .* [.97 .97 .97];

function [fitamount numoverlap fracstring] = fitfrac(parentfit,childfit)
fitfracs = [];
for i = 1:length(parentfit.lines)
    for j = 1:length(childfit.lines)
        parentline = parentfit.lines{i};
        childline = childfit.lines{j};
        if parentline.hash == childline.hash
            fitfracs(end+1) = childline.exph / parentline.expheight;
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
