function [upferrs downferrs] = polyfitseries(fs)
upferrs = [];
downferrs = [];

maxdegree = 4;
for n = 2:length(fs)-1
    degree = min(maxdegree,n-1);
    x = 1:n;
    y = fs(1:n);
    [p] = polyfit(x,y,degree);
    predictf = polyval(p,n+1);
    ferr = fs(n+1) - predictf;
    upferrs(end+1) = (ferr);

    y = fs(1+end-n:end);
    [p] = polyfit(x,y,degree);
    predictf = polyval(p,0);
    ferr = fs(end-n) - predictf;
    downferrs(end+1) = (ferr);
end