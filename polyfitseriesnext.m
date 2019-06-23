function [uppredict downpredict] = polyfitseriesnext(fs,maxdegree)
if length(fs) < 2
    uppredict = fs(1);
    downpredict = fs(1);
    return
end
if nargin < 2
    maxdegree = 2;
end

n = min(maxdegree,length(fs)-1);

x = 1:n+1;
y = fs(end-n:end);
[p] = polyfit(x,y,n);
uppredict = polyval(p,n+2);

y = fs(1:n+1);
[p] = polyfit(x,y,n);
downpredict = polyval(p,0);

end