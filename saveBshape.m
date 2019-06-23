function kit = saveAshape(kit,verbose)
%calculate and plots f_1 and f_2
if nargin < 1
    load('ttfile','kit');
else
    save('ttfile','kit');
end
if nargin < 2
    verbose = 1;
end
    
    f0J = kit.series1.fs; %not using yet..
    f1J = kit.series4.fs;
    J = 1:length(f1J);
    Jforf1 = kit.series4.jvalues;
    Jforf0 = kit.series1.jvalues;
    
    %%aside - explore table 7.11 in Brown and Carrington
    exploreBC(Jforf0,f0J,kit.cheat.molstats);
    
    maxJ = max(J);
    1;
    firstk1 = f1J(end) - f1J(end-1);  
    secondk1 = f0J(end) - f0J(end-1);
    
    k1 = 0.5 * (firstk1 + secondk1);
    %k2 = f1J(1) - k1;
    k2 = 1;
    
%     xvals(1) = 0;
%     f1vals(1) = 1;
%     x1vals = [];
%     x0vals = [];
%     f1vals = [];
%     f0vals = [];
     x1vals = 0;  %enforce f_1(0) = f_2(0) = 0;
    x0vals = 0;
    f1vals = 0;
    f0vals = 0;
    
    for i = 1:maxJ
        
        x1vals(end+1) = Jforf1(i)+1;
        x0vals(end+1) = Jforf0(i) + 1;
        
        f1vals(end+1) = (f1J(i) - (k1 * (Jforf1(i) + 1)))/k2;  %line flexes with above
        f0vals(end+1) = (f0J(i) - (k1 * (Jforf0(i) + 1)))/k2;  %line flexes with above
    end
    %now find the real k2
    k2 = (f1vals(end) + f0vals(end))/2;
    f1vals = f1vals/k2;
    f0vals = f0vals/k2;
    
    bigx1vals = linspace(0,max(x1vals),400);
    bigx0vals = linspace(0,max(x0vals),400);
    
    %find k2 by interpolating backwards..
    
    
    bigf1vals = interp1(x1vals,f1vals,bigx1vals,'spline','extrap');
    bigf0vals = interp1(x0vals,f0vals,bigx0vals,'spline','extrap');
    
    smallx = 0.1;
    k3 = interp1(bigf1vals,bigx1vals,smallx);
    k3 = k3/smallx;
    %sets f1'(0) = 1;
    
    f1table.xvals = bigx1vals / k3;
    f1table.yvals = bigf1vals;
    
    
    f0table.xvals = bigx1vals / k3;
    f0table.yvals = bigf0vals;
    
    f0slope = f0table.yvals(2) / f0table.xvals(2);
    f1slope = f1table.yvals(2) / f1table.xvals(2);
    fprintf('f0 slope is %3.3f, f1 slope is %3.3f\n',f0slope,f1slope);
    
    kit.f1table = f1table;
    kit.f0table = f0table;
    kit.k1 = k1;
    kit.k2 = k2;
    kit.k3 = k3;
    bigJvalues = linspace(0,max(Jforf1),500);
    
    f1outputs = evalf(bigJvalues,k1,k2,k3,1);
    f0outputs = evalf(bigJvalues,k1,k2,k3,0);
    
    if verbose
    figure('Position',[680   200   638   778]);
    subplot(311);
    plot(Jforf1,f1J,'bs');
    hold all;
    plot(Jforf0,f0J,'rs');
    addtext(sprintf('f1: %s\n f0: %s\n',num2str(f1J(1:5)),num2str(f0J(1:5))));
    plot(Jforf1(kit.series4.visibleis),f1J(kit.series4.visibleis),'bs','MarkerFaceColor','b');
    plot(Jforf0(kit.series1.visibleis),f0J(kit.series1.visibleis),'bs','MarkerFaceColor','r');
%     plot(bigJvalues,f1outputs,'b-');
%     hold all;
%     plot(bigJvalues,f0outputs,'r-');
    
    xlabel('J');
    ylabel(sprintf('freq for J_{1J}-> (J+1)_{1(J+1)}'));
    title(sprintf('%s: ka = %d',kit.cheat.molstats.descriptor,kit.ka));
    subplot(312);
    plot(x1vals,f1vals * k2,'bs');
    hold all;
    plot(x0vals,f0vals * k2,'rs');
    plot(x0vals(kit.series1.visibleis+1),f0vals(kit.series1.visibleis+1) * k2,'bs','MarkerFaceColor','r');
    plot(x1vals(kit.series4.visibleis+1),f1vals(kit.series4.visibleis+1) * k2,'bs','MarkerFaceColor','b');
    hold all;
    plot(x0vals,f0vals * k2,'rs');
    plot(bigx1vals,bigf1vals * k2,'b-');
    plot(bigx0vals,bigf0vals * k2,'r-');
    
    legend('high k_a','low k_a','Location','Best');
    xlabel('J+1');
    ylabel('k_2 * f((J+1)/k_3)');
    title(sprintf('k_1 = %3.2f, k_2 = %3.2f, k_3 = %3.2f',k1,k2,k3));
    subplot(313);
    plot(f1table.xvals,f1table.yvals,'b');
    hold all;
    plot(f0table.xvals,f0table.yvals,'r');
    legend('f_1(x)','f_0(x)','Location','Best');
    end
    
    
        

        
    function exploreBC(J,f,molstats)
        A = molstats.a;
        B = molstats.b;
        C = molstats.c;
        
        bcguess = ((A+B) * (J+1)) + ((2*C - A - B)*(J+0.5));
        dpguess = 2*C*J + (A+B);
        
        dperrors = f-dpguess;
        bcerrors = f-bcguess;
        
        dperrors;
        bcerrors;
        1;
    