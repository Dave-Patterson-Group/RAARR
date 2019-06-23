function listpairs(pairlist)
%displays the list, sorted by f.
numpairs = length(pairlist);

nump = 0;
sfi = 1:numpairs;
for (i = 1:numpairs)
    thispair = pairlist{i};
    fs(i) = thispair.delf;
end
%comment out the next line to not sort.

[sfs sfi] = sort(fs);
for (i = 1:numpairs)
    thispair = pairlist{sfi(i)};
    %suggestlist{i} = thispair;
    fprintf('line description: \n');
    disp(thispair.description);
   % fprintf('frequency %3.5f\n',thispair.delf);
end
%fprintf('%d out of %d possible',nump,numpairs);

