function plotscaffold(kit)
if kit.fourseriesmode == 0
    return
end
    series1 = kit.series1;
    series2 = kit.series2;
    series3 = kit.series3;
    series4 = kit.series4;
    
    gvalues = [10000 3000 abs(kit.f1f3) 0.03 series1.polyerrors(1) kit.f3error 0.03 0.03 series1.polyerrors(2) series2.polyerrors(1) series1.polyerrors(3) series2.polyerrors(2)];
    gvalues = abs(gvalues);
    texstring = kit.fakemolname;
    for i = 1:length(gvalues)
        texstring = sprintf('%s & %3.0f ',texstring,gvalues(i));
    end
    texstring = [texstring '\\'];
    
    descriptor = sprintf('g3 error [flatsquare] %3.1f\n g6 error [degree 1] %3.1f\n',kit.f1f3,kit.f3error);
    descriptor = sprintf('%s b+c %3.1f,predict J %3.1f, actual J %d\n\n',descriptor,kit.bplusc,kit.predictj,kit.actualj);
    descriptor = sprintf('%s series 1 polys [g5 g9 g13] %s\n series 2 polys [g10 g14] %s \n series 4 polys %s \n',descriptor,series1.polystring,series2.polystring,series4.polystring);
    
    if kit.plotaonly
        validlines = [];
        for i = 1:kit.numlines
            thisrow = [series1.fs(i) series4.fs(i)];
            if (min(thisrow) > kit.minwindow) && (max(thisrow) < kit.maxwindow)
                validlines(end+1) = i;
            end
        end
    else
        validlines = 1:kit.numlines;
    end
    hold all;
    for i = validlines
        p1 = plot([0 0.1],[series1.ploth(i) series1.ploth(i+1)],'b','LineWidth',1,'LineStyle','--');
        p2 = plot([0 3],[series2.ploth(i) (series2.ploth(i) + series2.fs(i))],'r','LineWidth',1,'LineStyle','--');
        p3 = plot([3 0],[series3.ploth(i) (series3.ploth(i) + series3.fs(i))],'m','LineWidth',1,'LineStyle','--');
        p4 = plot([3 3.1],[series4.ploth(i) (series4.ploth(i) + series4.fs(i))],'k','LineWidth',1,'LineStyle','--');
        
        if i == 2
            set(p1,'LineWidth',8','LineStyle','-');
            set(p2,'LineWidth',4','LineStyle','-');
        end
        if i == 3
            set(p1,'LineWidth',4','LineStyle','-');
            set(p2,'LineStyle','-');
            set(p3,'LineWidth',4','LineStyle','-');
            set(p4,'LineStyle','-');
        end
        if i == 4
            set(p1,'LineStyle','-');
            set(p3,'LineStyle','-');
        end
        plot([-1 1],[series1.ploth(i) series1.ploth(i)],'k');
        plot([0],[series1.ploth(i)],'bo','MarkerSize',8,'MarkerFaceColor','k');
        if i == kit.numlines
            plot([-1 1],[series1.ploth(i+1) series1.ploth(i+1)],'g');
            plot([0],[series1.ploth(i+1)],'bo','MarkerSize',8,'MarkerFaceColor','k');
            plot([2 4],[series4.ploth(i+1) series4.ploth(i+1)],'g');
            plot([3],[series4.ploth(i+1)],'bo','MarkerSize',8,'MarkerFaceColor','k');
            text(-2,series1.ploth(i+1),series1.cheat.pairseries{i}.startshortstring(1:end-1));
            text(4.5,series4.ploth(i+1),series4.cheat.pairseries{i}.startshortstring(1:end-1));
        end
        text(-2,series1.ploth(i),series1.cheat.pairseries{i}.endshortstring(1:end-1));
        
        
        plot([2 4],[series4.ploth(i) series4.ploth(i)],'k');
        plot([3],[series4.ploth(i)],'bo','MarkerSize',8,'MarkerFaceColor','k');
        
        text(4.5,series4.ploth(i),series4.cheat.pairseries{i}.endshortstring(1:end-1));
        
        t4 = text(3.5,(series4.ploth(i) + series4.ploth(i+1))/2,num2str(series4.fs(i),6));
        t1 = text(-1,(series1.ploth(i) + series1.ploth(i+1))/2,num2str(series1.fs(i),6));
        t3 = text(0.5,(0.3 * series3.ploth(i)) + (0.7 * (series3.ploth(i) + series3.fs(i))),num2str(series3.fs(i),6));
        t2 = text(1.7,(0.5 * series2.ploth(i)) + (0.5 * (series2.ploth(i) + series2.fs(i))),num2str(series2.fs(i),6));
        
        set(t3,'Rotation',-25);
        set(t2,'Rotation',25);
        set(t3,'Color','m');
        set(t1,'Color','b');
        set(t2,'Color','r');
    end
    disp(texstring);
    %text(5.5,mean(series1.ploth),kit.tightdescriptor);
    
    legend('series 1','series 2','series 3','series 4');
    xlim([-4 6]);
    b = ylim;
    b(2) = b(2) * 1.05;
    ylim(b);
    set(gca,'ytick',[]);
    set(gca,'xtick',[]);
    
    
    title(kit.titlestring);
