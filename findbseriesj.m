function j = findbseriesj(fs,verbose)
if nargin < 2
    verbose = 0;
end
ivals = 0:(length(fs)-1);
[p] = polyfit(ivals,fs,2);

allvals = -8:length(fs)+8;
predictf = polyval(p,allvals);

ji = find(predictf < 0,1,'last');
j = -allvals(ji);
1;

if verbose
    figure;
    plot(ivals,fs,'ks','MarkerFaceColor','k');
    hold all;
    plot(allvals,predictf,'bs');
    plot(-j,predictf(ji),'rs');
    
end
    
