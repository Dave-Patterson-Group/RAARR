function playwithsort

Ns = [];
for i = 1:1000
    rands = sort(rand(1,3));

    Ns(end+1) = 10 * rands(1) / mean(rands);
end
figure;
hist(Ns,25);
mean(Ns)
