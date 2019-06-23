function makepaperfigure(kit)

% if isstruct(thisfit) == 0
%     return;
% end
if nargin < 1
    load('figures/terpineolkit','kit')
else
    save('figures/terpineolkit','kit');
end

xlimit = [10000 18500];
figure('Name',kit.molname,'Position',[36   239   965   525]);
kit.fitlist{1} = kit.finalfit;
subplot(1,3,3);
showseriesladderpaper(kit.finalfit.seriessquare);
set(gca,'Position',[0.646632124352332   0.110000000000000   0.258367875647668   0.815000000000000]);


subplot(2,3,[4 5]);
plot(0,0,'b');
hold all;
plot(0,0,'r');
plot(0,0,'c');
if isfield(kit,'freqs1d')
    stickplot(kit.onedpeakfs,kit.onedpeakhs,'c');
    plot(kit.freqs1d,kit.amps1d,'c')
else
    stickplot(kit.onedpeakfs,kit.onedpeakhs,'c');
end
legs{1} = 'all lines';

for n = 1:length(kit.fitlist)
    thisfit = kit.fitlist{n};
    if isfield(thisfit,'allpairs') == 0
        thisfit = add_amplitudes_to_fit(thisfit,kit,0);
    end
    
    
    if n == 1
        a = xlim;
        plotpairs(thisfit.allpairs,'scaledstrength-','b');
        xlim(a);
        if isfield(kit,'molfilename')
            addtext(kit.molfilename,-2);
        end
        legs{2} = litestringfromfit(thisfit);
    end
    stickplot(thisfit.hitfs,thisfit.hiths,thisfit.color);
    legs{end+1} = litestringfromfit(thisfit);
    title(litestringfromfit(thisfit));
   % addtext(thisfit.branchtypestring);
end
legend('theory','assigned lines','unassigned lines');
%set(legend,'Position',[0.525043178850299   0.610793658968002   0.084974092306868   0.289523801349459]);
ylabel('');
fancystickies();
yticks([]);
xlim(xlimit);
    subplot(2,3,[1 2]);

ulines = find(kit.whichspecies == 0);
stickplot(kit.onedpeakfs,kit.onedpeakhs,'c');
hold all;
s = kit.finalfit.seriessquare;
p1 = stickplot(s.column1.realfs,s.column1.realhs,'b');
    p2 = stickplot(s.column2.realfs,s.column2.realhs,'r');
    p3 = stickplot(s.column3.realfs,s.column3.realhs,'m');
    p4 = stickplot(s.column4.realfs,s.column4.realhs,'k');
 
    p1 = stickplot(s.column2.realfs(2),s.column2.realhs(2),'r');
    p2 = stickplot(s.column3.realfs(1),s.column3.realhs(1),'m');
    p3 = stickplot(s.column4.realfs(1),s.column4.realhs(1),'k');
    p4 = stickplot(s.column4.realfs(2),s.column4.realhs(2),'k');
    set(p1,'LineWidth',2);
set(p2,'LineWidth',2);
set(p3,'LineWidth',2);
set(p4,'LineWidth',2);

%title('unassigned lines');
yticks([]);
xlim(xlimit);
try
    addtext(kit.latestfit.trial.descriptor);

    subplot(1,3,3);
    
    showseriesladder(kit.latestfit.seriessquare);
end    