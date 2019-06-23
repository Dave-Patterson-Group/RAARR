function k = pickone(pvals)
%picks a random
if length(pvals) == 0
    error('cannot pick out of zero');
end
    sums = pvals * 0;
    sums(1) = pvals(1);
    for i = 2:length(pvals)
        sums(i) = sums(i-1) + pvals(i);
    end
    p = rand() * sums(end);
    k = find(p < sums,1,'first');
end
