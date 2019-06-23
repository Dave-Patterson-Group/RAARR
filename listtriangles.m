function singlelines = listtriangles(trianglelist)
numpairs = length(trianglelist);

nump = 0;
singlelines = {};
for i = 1:numpairs
    thist = trianglelist{i};
    if (thist.ispossible)
        singlelines{end+1} = thist.midpair;
        singlelines{end+1} = thist.highpair;
        disp(thist.longdescription);
        disp(thist.shortdescription);
        fprintf('\n===============================\n');
        nump = nump + 1;
    end
    
end
fprintf('%d out of %d possible',nump,numpairs);

