function plottwoserieskit(kit)
% figure('Name',kit.cheat.molstring,'Position',[74          95        1013         843]);
% subplot(4,1,[1 2 3]);
% 
% 
% 
% plotvisible(kit.series1,kit,'b');
% plotvisible(kit.series4,kit,'k');
% 
% legend(['series 1: ' kit.series1.cheat.pairseries{2}.shortdescription],' ',['series 4: ' kit.series4.cheat.pairseries{2}.shortdescription]);
% title(['A series behavior: ' kit.fakemolname]);
% %addtext(kit.abendstring,1);
% b = ylim;
% b(2) = b(2) * 2.05;
% ylim(b);    
% try
%     addtext(sprintf('%s\n\n\n%s',kit.fullerrorstring,kit.highlowstring ));
% end
% subplot(4,1,4);
% hold all;
% stickplot(kit.onedpeakfs,kit.onedpeakhs);
% plotvisible(kit.series1,kit,'b');
% plotvisible(kit.series4,kit,'k');
% xlim(kit.visiblewindow);
% precisestickies;
% if isfield(kit,'verboseFitString')
%     addtext(kit.verboseFitString); 
% end

figure('Position',[606    86   566   880],'Name',kit.cheat.molstring);
plotseriesc(kit.series1,'b');

plotseriesc(kit.series4,'k');
subplot(4,1,[1]);
title(kit.cheat.molstring);
if isfield(kit,'verboseFitString')
    addtext(kit.verboseFitString); 
end

function plotvisible(series,kit,color)
fs = series.fs;
hs = series.hs;
usedfs = [];
usedhs = [];
for i = 1:length(fs)
    if isfield(kit,'aasignedfs')
        if ismember(fs(i),kit.aassignedfs)
            usedfs(end+1) = fs(i);
            usedhs(end+1) = hs(i);
        end
    else
        if (fs(i) > kit.visiblewindow(1)) && (fs(i) < kit.visiblewindow(2))
            usedfs(end+1) = fs(i);
            usedhs(end+1) = hs(i);
        end
    end
end
stickplot(series.fs,series.hs,color);
hold on;
p = stickplot(usedfs,usedhs,color);
set(p,'LineWidth',2);


