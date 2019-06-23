function showseriesladderpaper(s,showerrors)
if nargin < 2
    showerrors = 0;
end
hold all;

numlines = length(s.fgrid(:,1));
numlevels = length(s.energies(:,1));
energies = s.energies;
s.ordercutoff = 4;
if showerrors == 0
 for i = 1:numlevels-1
     if s.fgrid(i,1) ~= 0
        p1 = plot([0 0.1],[energies(i,1) energies(i+1,1)],'b','LineWidth',1,'LineStyle','-');
        t1 = text(-1,(energies(i,1) + energies(i+1,1))/2,num2str(s.fgrid(i,1),6));

        if (s.alineorder(i,1) <= s.ordercutoff)
            set(p1,'LineWidth',2);
        end
     end
     if s.fgrid(i,2) ~= 0
        p2 = plot([0 3],[energies(i,1) energies(i+1,2)],'r','LineWidth',1,'LineStyle','-');
        t2 = text(1.7,(0.7 * energies(i,2)+ 0.3 * energies(i+1,2)),num2str(s.fgrid(i,2),6));
        set(t2,'Rotation',35);

        if (s.alineorder(i,2) <= s.ordercutoff)
            set(p2,'LineWidth',2);
        end
     end
     if s.fgrid(i,3) ~= 0
        p3 = plot([3 0],[energies(i,2) energies(i+1,1)],'m','LineWidth',1,'LineStyle','-');
        t3 = text(0.5,(0.3 *energies(i,2) + 0.7* energies(i+1,1)),num2str(s.fgrid(i,3),6));
        set(t3,'Rotation',-35);
  
        if (s.alineorder(i,3) <= s.ordercutoff)
            set(p3,'LineWidth',2);
        end
     end
     if s.fgrid(i,4) ~= 0
        p4 = plot([3 3.1],[energies(i,2) energies(i+1,2)],'k','LineWidth',1,'LineStyle','-');
        t4 = text(3.5,(energies(i,2) + energies(i+1,2))/2,num2str(s.fgrid(i,4),6));
       
        if (s.alineorder(i,4) <= s.ordercutoff)
            set(p4,'LineWidth',2);
        end
     end
  %  title(s.shortpvalstring);

 end
else
    for i = 1:numlines
        
        if s.fgrid(i,1) ~= 0
            ts = sprintf('%d:%3.1f',s.alineorder(i,1),s.fgrid(i,1) - s.allpredicts(i,1));
            p1 = plot([0 0.1],[energies(i,1) energies(i+1,1)],'b','LineWidth',1,'LineStyle','-');
            t1 = text(-1,(energies(i,1) + energies(i+1,1))/2,ts);
            if islegal(s.fgrid(i,1))
                set(p1,'LineWidth',3);
            end
        end
        if s.fgrid(i,2) ~= 0
            ts = sprintf('%d:%3.1f',s.alineorder(i,2),s.fgrid(i,2) - s.allpredicts(i,2));
            p2 = plot([0 3],[energies(i,1) energies(i+1,2)],'r','LineWidth',1,'LineStyle','-');
            t2 = text(1.7,(0.7 * energies(i,2)+ 0.3 * energies(i+1,2)),ts);
            set(t2,'Rotation',35);
            if islegal(s.fgrid(i,2))
                set(p2,'LineWidth',3);
            end
        end
        if s.fgrid(i,3) ~= 0
            ts = sprintf('%d:%3.1f',s.alineorder(i,3),s.fgrid(i,3) - s.allpredicts(i,3));
            p3 = plot([3 0],[energies(i,2) energies(i+1,1)],'m','LineWidth',1,'LineStyle','-');
            t3 = text(0.5,(0.3 *energies(i,2) + 0.7* energies(i+1,1)),ts);
            set(t3,'Rotation',-35);
            if islegal(s.fgrid(i,3))
                set(p3,'LineWidth',3);
            end
        end
        if s.fgrid(i,4) ~= 0
            ts = sprintf('%d:%3.1f',s.alineorder(i,4),s.fgrid(i,4) - s.allpredicts(i,4));
            p4 = plot([3 3.1],[energies(i,2) energies(i+1,2)],'k','LineWidth',1,'LineStyle','-');
            t4 = text(3.5,(energies(i,2) + energies(i+1,2))/2,ts);
            if islegal(s.fgrid(i,4))
                set(p4,'LineWidth',3);
            end
        end
        title(s.shortpvalstring);
        
    end
end
for i = 1:numlevels
    if energies(i,1) ~= 0
        plot([-1 1],[energies(i,1) energies(i,1)],'g');
        plot([0],[energies(i,1) ],'bo','MarkerSize',8,'MarkerFaceColor','k');
    end
    if energies(i,2) ~= 0
        plot([2 4],[energies(i,2) energies(i,2)],'g');
        plot([3],energies(i,2),'bo','MarkerSize',8,'MarkerFaceColor','k');
    end
    %         text(-2,series1.ploth(i+1),series1.cheat.pairseries{i}.startshortstring(1:end-1));
    %         text(4.5,series4.ploth(i+1),series4.cheat.pairseries{i}.startshortstring(1:end-1));
end


%legend('series 1','series 2','series 3','series 4');
xlim([-2 4]);
b = ylim;
b(2) = b(2) * 1.4;
%addtext(s.errorstring);
set(gca,'ytick',[]);
set(gca,'xtick',[]);
% if showerrors == 0
%     addtext(s.tightdescriptor,1);
%     ylim(b);
% end
figure1 = gcf;
annotation(figure1,'textbox',...
    [0.136751295336787 0.841904761904762 0.0342331606217618 0.0819047619047619],...
    'String','A',...
    'LineStyle','none',...
    'FontSize',18,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.65281347150259 0.849523809523809 0.0342331606217617 0.0819047619047619],...
    'String','B',...
    'LineStyle','none',...
    'FontSize',18,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

% Create textbox
annotation(figure1,'textbox',...
    [0.128461139896372 0.379047619047619 0.0342331606217617 0.0819047619047619],...
    'String','C',...
    'LineStyle','none',...
    'FontSize',18,...
    'FitBoxToText','off',...
    'EdgeColor',[1 1 1]);

pause(.001);


function yesorno = islegal(f)
yesorno = 0;
if (f > 10500) && (f < 18800)
    yesorno = 1;
end