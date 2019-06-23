function [fs,errs,is] = closestf(f,flist,n)
%returns the closes f and the error. if you want the closest and
%nextclosest, n= 2. for example
%closestf(12,[10 11 11.5 14],2) returns fs = [11.5 11] and errs = [0.5 1.0]
%and is = [3 2]
if nargin < 3
    n = 1;
end
ferrors = abs(flist -f);
n = min(n,length(flist));
for i = 1:n
    besti = find(ferrors == min(ferrors),1,'first');
    fs(i) = flist(besti);
    errs(i) = ferrors(besti);
    is(i) = besti;
    ferrors(besti) = Inf;
end

