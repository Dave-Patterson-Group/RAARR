function k = pickn(pvals,n)

if n < 0
    n = length(pvals) - 1;
end
if n > length(pvals)
    error('cannot pick %d from %d\n',n,length(pvals));
end
k = zeros(length(n));
for i = 1:n
    k(i) = pickone(pvals);
    pvals(k(i)) = 0;
end

