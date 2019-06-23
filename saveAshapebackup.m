function saveAshape(kit)
%calculate and plots f_1 and f_2
if nargin < 1
    load('ttfile','kit');
else
    save('ttfile','kit');
end
    
    f0J = kit.series1.fs; %not using yet..
    f1J = kit.series4.fs;
    J = 1:length(f1J);
    
    maxJ = max(J);
    allk1s = f1J ./ J;
    1;
    firstk1 = f1J(end) - f1J(end-1);  
    secondk1 = f0J(end) - f0J(end-1);
    
    k1 = 0.5 * (firstk1 + secondk1);
    %k2 = f1J(1) - k1;
    k2 = 1;
    
%     xvals(1) = 0;
%     f1vals(1) = 1;
    xvals = [];
    x0vals = [];
    f1vals = [];
    f0vals = [];
    for i = 1:maxJ
        
        xvals(end+1) = J(i)+1;
        x0vals(end+1) = J(i);
        
        f1vals(end+1) = (f1J(i) - (k1 * (J(i) + 1)))/k2;  %line flexes with above
        f0vals(end+1) = (f0J(i) - (k1 * (J(i))))/k2;  %line flexes with above
    end
    %now find the real k2
   % k2 = f1vals(end);
   % f1vals = f1vals/k2;
    
    bigxvals = linspace(0,max(xvals),200);
    bigx0vals = linspace(0,max(x0vals),200);
    
    bigf1vals = interp1(xvals,f1vals,bigxvals,'spline','extrap');
    bigf0vals = interp1(x0vals,f0vals,bigx0vals,'spline','extrap');
    
    f1table.xvals = bigxvals;
    f1table.yvals = bigf1vals;
    
    figure;
    subplot(211);
    plot(J,f1J,'bs');
    xlabel('J');
    ylabel(sprintf('freq for J_{1J}-> (J+1)_{1(J+1)}'));
    title(kit.titlestring);
    subplot(212);
    plot(xvals,f1vals,'bs');
    hold all;
    plot(x0vals,f0vals,'rs');
    plot(bigxvals,bigf1vals,'b-');
    plot(bigx0vals,bigf0vals,'r-');
    xlabel('x');
    ylabel('f_1(x)');
    title(sprintf('k_1 = %3.2f, k_2 = %3.2f',k1,k2));
    
    function freq = evalf(J,k1,k2,k3,ftable)
        x = (J+1)/k3;
        y1 = k2 * interp1(ftable.xvals,ftable.yvals,x);
        freq = ((J+1) * k1) + y1;
        
    