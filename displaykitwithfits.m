function f = displaykitwithfits(kit,nada)

% if isstruct(thisfit) == 0
%     return;
% end

%figure('Name',kit.molname,'Position',[36   239   965   525]);

numfits = length(kit.fitlist);
figname = sprintf('%s with %d fits',kit.molname,numfits);
f = figure('Name',figname,'Position',[36   239   965   525]);

if isfield(kit,'finalfit') && isstruct(kit.finalfit) 
%    kit.fitlist{end+1} = kit.finalfit;
    
    switch kit.finalfit.patternType
        case 'scaffold'
            subplot(1,3,3);
            s = kit.finalfit.pattern.archive;
            showseriesladder(s,kit.finalfit.trial.lineset);
            subplot(3,3,[7 8]);
            hold all;
            p1 = stickplot(s.column1.realfs,s.column1.realhs,'b');
            p2 = stickplot(s.column2.realfs,s.column2.realhs,'r');
            p3 = stickplot(s.column3.realfs,s.column3.realhs,'m');
            p4 = stickplot(s.column4.realfs,s.column4.realhs,'k');
            % else
            %     p1 = stickplot(s.series1.realfs,s.series1.realhs,'r');
            %     p2 = stickplot(s.series2.realfs,s.series2.realhs,'b');
            %     p3 = stickplot(s.series3.realfs,s.series3.realhs,'k');
            %     p4 = stickplot(s.series4.realfs,s.series3.realhs,'m');
            % end
            
            set(p1,'LineWidth',1);
            set(p2,'LineWidth',1);
            set(p3,'LineWidth',1);
            set(p4,'LineWidth',1);
            
            plot(s.flatsquare.fs(1),s.flatsquare.hs(1),'X','MarkerSize',6);
             title('scaffold fit');
        case 'aTypes'
            subplot(3,3,[7 8]);
            s = kit.finalfit.pattern.archive;

            p1 = stickplot(s.f0RealFreqs,s.f0RealHeights,'b');
            hold all;
            p4 = stickplot(s.f1RealFreqs,s.f1RealHeights,'k');
            set(p1,'LineWidth',1);
            set(p4,'LineWidth',1);
            addtext(s.originString,1);
            title('a-series fit');
    end
end


subplot(3,3,[1 2 4 5]);

hold all;

if isfield(kit,'freqs1d')
  %  stickplot(kit.onedpeakfs,kit.onedpeakhs,'c');
    plot(kit.freqs1d,kit.amps1d,'k')
else
    stickplot(kit.onedpeakfs,kit.onedpeakhs,'c');
end
legs{1} = [kit.molname ' all lines'];


 for n = 1:length(kit.fitlist)
    thisfit = kit.fitlist{n};
    if isfield(thisfit,'allpairs') == 0
        thisfit = add_amplitudes_to_fit(thisfit,kit,0);
    end
    
    
   
    a = xlim;
    plotpairs(thisfit.allpairs,'scaledstrength-',thisfit.color);
    ylabel('');
    yticks([]);
    xlim(a);
    if isfield(kit,'molfilename')
        addtext(kit.molfilename,-2);
    end
    legs{end+1} = litestringfromfit(thisfit);
    
    if n == 1
        title(sprintf('%s - %d species found',kit.molname,kit.numspecies));
     %   addtext(sprintf('%s\n%s',thisfit.shortstring,thisfit.shortextendstring);
    end
    %addtext(thisfit.branchtypestring);
 end

for n = 1:length(kit.fitlist)
    thisfit = kit.fitlist{n};    
    stickplot(thisfit.hitfs,thisfit.hiths,thisfit.color);
    %addtext(thisfit.branchtypestring);
end
if kit.numspecies >= 1
    legend(legs);
end

fancystickies();
a = xlim;
sexyaxis();
subplot(3,3,[7 8]);
xlim(a);
b = ylim;
b(1) = .00001;
yticks([]);
ylim(b);
if isfield(kit,'finalfit')
    if isfield(kit.finalfit,'trial')
        addtext(sprintf('%s\n%s\n%s',kit.csvfilename,date,kit.finalfit.trial.lineset{1}.descriptor));
    else
        addtext(sprintf('%s\n%s\n%s',kit.csvfilename,date,kit.finalfit.fitdescriptor));
    end
else
    addtext(sprintf('%s\n%s\nNONE FOUND',kit.csvfilename,date));
end
sexyaxis();

% 
% ulines = find(kit.whichspecies == 0);
% stickplot(kit.onedpeakfs(ulines),kit.onedpeakhs(ulines),'k');
% title('unassigned lines');
 