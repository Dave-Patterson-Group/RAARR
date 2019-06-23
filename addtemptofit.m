function newfit = addtemptofit(fit,kit)
if nargin == 2
    save('tfiletemps','fit','kit')  %'tfile is 
else
    load('tfiletemps','fit','kit');
    kit.tightnesssettings = settingsfromtightness(kit.tightnesssettings.scalartightness); %update tightness
end
fit = applyfittokit(fit,kit,0);

[atemp numapairs] = findtemp(fit.matches,'a');
[atemp numapairs] = findtemp(fit.matches,'b');
newfit = fit;

function [atemp numapairs] = findtemp(linelist,type)
atemp = 0;
numapairs = 0;
tempvals = [];
linelist = selectlinetypes(linelist,type);
ediffs = [];
impliedTs = [];
for i = 1:length(linelist)
    for j = i+1:length(linelist)
        thisline = linelist{i};
        thatline = linelist{j};
        thisimpliedpop = impliedpop(thisline);
        thatimpliedpop = impliedpop(thatline);
        popratio = thisimpliedpop/thatimpliedpop;
        ediff = thisline.minenergy - thatline.minenergy;
        impliedT = -ediff/log(popratio);
        fdiff = thisline.delf - thisline.delf;
        if (impliedT > 0) && (impliedT < 20) && (abs(ediff) > 3) && (abs(fdiff) < 2000)
            ediffs(end+1) = ediff;
            impliedTs(end+1) = impliedT;
            ediff
            popratio
            impliedT
            1;
        end
    end
end
ediffs
impliedTs

bigdiff = find(abs(ediffs) > 10)
1;
        
% fit = applyfittokit(fit,kit,0);
% plotlinelist(fit.matches)
% 
% kit = addfittokit(kit,fit);
% %addC13sfromwithlinelist(fit,kit,linelist)
% 
% linestouse.lines = fit.matches;
% linestouse.heighttouse = 'predictedh';
function p = impliedpop(thisline)
    p = thisline.expheight * (thisline.transmoment^-2) * (thisline.delf^-4);
function newlinelist = selectlinetypes(linelist,type)
newlinelist = {};
for i = 1:length(linelist)
    if strcmp(linelist{i}.transitiontype,type) == 1
        newlinelist{end+1} = linelist{i};
    end
end