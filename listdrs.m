function listdrs(pairlist)
%displays the list, sorted by f.
numpairs = length(pairlist);

nump = 0;
sfi = 1:numpairs;
fs = [];
for (i = 1:numpairs)
    thispair = pairlist{i};
    fs(i) = thispair.lowpair.delf;
end
%comment out the next line to not sort.

[sfs sfi] = sort(fs);
for (i = 1:numpairs)
    thispair = pairlist{sfi(i)};
    %suggestlist{i} = thispair;
    if thispair.ispossible
        fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
        disp(thispair.longdescription);
    end
    %fprintf('frequency %3.5f / %3.5f \n',thispair.lowpair.delf,thispair.highpair.delf);
end
%fprintf('%d out of %d possible',nump,numpairs);

