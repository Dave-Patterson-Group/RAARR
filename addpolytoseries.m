function series = addpolytoseries(series)

n = 3;
errors = [];
predicts = [];
p = 0;
while n <= length(series.fs)
    x = 1:n-1;
    y = series.fs(1:n-1);
    p = polyfit(x,y,min(n-2,5));
    ys = polyval(p,[1:n]);
    errors(end+1) = ys(n) - series.fs(n);
    predicts(end+1) = ys(n);
    %         subplot(211);
    %         hold off;
    %         plot([1:n],ys,'bs','MarkerSize',10);
    %         hold all;
    %         plot(fs,'rs');
    %
    %         plot(allx,polyval(p,allx));
    %         subplot(212);
    %         plot(fs(1:n) - ys,'ms');
    n = n+1;
    1;
    
end
errors(end+1:end+4) = [0 0 0 0 ];
series.poly = p;
series.polyerrors = errors;

series.polystring = sprintf('tightness [%3.1f %3.1f %3.1f]',series.polyerrors(1),series.polyerrors(2),series.polyerrors(3)); 
series.predicts = predicts;
     