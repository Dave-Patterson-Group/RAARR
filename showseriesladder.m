function showseriesladder(s,lineset)
labelled = 0;
if nargin == 2
    %lineset = s.trial.lineset;
    line1 = lineset{1};
    labelled = 1;
    line1toplabel = sprintf('|%d,%d,%d>',line1.Jupper,line1.Kaupper,line1.Kcupper);
    line1bottomlabel = sprintf('|%d,%d,%d>',line1.Jlower,line1.Kalower,line1.Kclower);
    line1f = line1.expfreq;
    
    line2 = lineset{2};
    line2toplabel = sprintf('|%d,%d,%d>',line2.Jupper,line2.Kaupper,line2.Kcupper);
    line2bottomlabel = sprintf('|%d,%d,%d>',line2.Jlower,line2.Kalower,line2.Kclower);
    line2f = line2.expfreq;
%    s = s.seriessquare;
end

    showerrors = 0;

hold all;

numlines = length(s.fgrid(:,1));
numlevels = length(s.energies(:,1));
energies = s.energies;
 for i = 1:numlevels-1
     if s.fgrid(i,1) ~= 0
        p1 = plot([0 0.1],[energies(i,1) energies(i+1,1)],'b','LineWidth',1,'LineStyle','-');
        if islegal(s.fgrid(i,1))
            set(p1,'LineWidth',3);
        end
%        if (s.alineorder(i,1) <= s.ordercutoff)
        if s.usablefgrid(i,1) > 0
            set(p1,'LineWidth',5);
        end
        
     end
     if s.fgrid(i,2) ~= 0
        p2 = plot([0 3],[energies(i,1) energies(i+1,2)],'r','LineWidth',1,'LineStyle','-');
        
        if islegal(s.fgrid(i,2))
            set(p2,'LineWidth',3);
        end
%        if (s.alineorder(i,2) <= s.ordercutoff)
        if s.usablefgrid(i,2) > 0
            set(p2,'LineWidth',5);
        end
     end
     if s.fgrid(i,3) ~= 0
        p3 = plot([3 0],[energies(i,2) energies(i+1,1)],'m','LineWidth',1,'LineStyle','-');
        
        if islegal(s.fgrid(i,3))
            set(p3,'LineWidth',3);
        end
        if s.usablefgrid(i,3) > 0
        %if (s.alineorder(i,3) <= s.ordercutoff)
            set(p3,'LineWidth',5);
        end
     end
     if s.fgrid(i,4) ~= 0
        p4 = plot([3 3.1],[energies(i,2) energies(i+1,2)],'k','LineWidth',1,'LineStyle','-');
        
        if islegal(s.fgrid(i,4))
            set(p4,'LineWidth',3);
        end
        if s.usablefgrid(i,4) > 0
        %if (s.alineorder(i,4) <= s.ordercutoff)
            set(p4,'LineWidth',5);
        end
     end
     
     if s.fgrid(i,1) ~= 0
        
        t1 = text(-1,(energies(i,1) + energies(i+1,1))/2,num2str(s.fgrid(i,1),6));
        
     end
     if s.fgrid(i,2) ~= 0
        
        t2 = text(1.7,(0.7 * energies(i,2)+ 0.3 * energies(i+1,2)),num2str(s.fgrid(i,2),6));
        set(t2,'Rotation',35);
        
%        
     end
     if s.fgrid(i,3) ~= 0
        
        t3 = text(0.5,(0.3 *energies(i,2) + 0.7* energies(i+1,1)),num2str(s.fgrid(i,3),6));
        set(t3,'Rotation',-35);
        
     end
     if s.fgrid(i,4) ~= 0
        
        t4 = text(3.5,(energies(i,2) + energies(i+1,2))/2,num2str(s.fgrid(i,4),6));
        
     end
    title(s.shortpvalstring);

 end

for i = 1:numlevels
    if energies(i,1) ~= 0
        plot([-1 1],[energies(i,1) energies(i,1)],'g');
        plot([0],[energies(i,1) ],'bo','MarkerSize',8,'MarkerFaceColor','k');
    end
    
    if (labelled == 1) && (i < numlevels)
        linef = abs(energies(i,1)-energies(i+1,1));
            if (abs(linef - line1f) < 0.1 )
               text(-3, energies(i+1,1),line1toplabel);
               text(-3, energies(i,1),line1bottomlabel);
               text(4, energies(i+1,2),line2toplabel);
            end
    end
                    
    if energies(i,2) ~= 0
        plot([2 4],[energies(i,2) energies(i,2)],'g');
        plot([3],energies(i,2),'bo','MarkerSize',8,'MarkerFaceColor','k');
    end
    %         text(-2,series1.ploth(i+1),series1.cheat.pairseries{i}.startshortstring(1:end-1));
    %         text(4.5,series4.ploth(i+1),series4.cheat.pairseries{i}.startshortstring(1:end-1));
end



%legend('series 1','series 2','series 3','series 4');
xlim([-4 6]);
b = ylim;
b(1) = b(1) - 1000;
ylim(b);
%addtext(s.errorstring);
set(gca,'ytick',[]);
set(gca,'xtick',[]);
% if showerrors == 0
%     addtext(s.tightdescriptor,1);
%     ylim(b);
% end
pause(.001);


function yesorno = islegal(f)
yesorno = 0;
if (f > 10500) && (f < 18400)
    yesorno = 1;
end