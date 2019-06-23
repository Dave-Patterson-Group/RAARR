function plotdrs(pairlist,showv)
if nargin < 2
    showv = 0;
end

%displays the list, sorted by f.
numpairs = length(pairlist);

nump = 0;
sfi = 1:numpairs;
maxs = 0;
fs = [];
for (i = 1:numpairs)
    thispair = pairlist{i};
    fs(i) = thispair.lowpair.delf;
    if thispair.minmoment > maxs
        maxs = thispair.minmoment;
    end
    
end
momentthresh = maxs / 5;
%comment out the next line to not sort.


[sfs sfi] = sort(fs);
f1 = [];
f2 = [];
%first plot all the V-type
for (i = 1:numpairs)
    thispair = pairlist{sfi(i)};
    %suggestlist{i} = thispair;
    if thispair.ispossible && (thispair.minmoment > momentthresh);
       % fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
        f1(end+1) = thispair.lowpair.delf;
        f2(end+1) = thispair.highpair.delf;
    end
    %fprintf('frequency %3.5f / %3.5f \n',thispair.lowpair.delf,thispair.highpair.delf);
end
fullf1 = [f1 f2];
fullf2 = [f2 f1];
p = plot(fullf1,fullf2,'bs');
a.datatype = 'drlist';
a.drlist = pairlist;
set(p,'UserData',a);
fancystickies();

hold on;
f1 = [];
f2 = [];
for (i = 1:numpairs)
    thispair = pairlist{sfi(i)};
    %suggestlist{i} = thispair;
    if thispair.ispossible && (thispair.minmoment < momentthresh)
       % fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
        f1(end+1) = thispair.lowpair.delf;
        f2(end+1) = thispair.highpair.delf;
    end
    %fprintf('frequency %3.5f / %3.5f \n',thispair.lowpair.delf,thispair.highpair.delf);
end
fullf1 = [f1 f2];
fullf2 = [f2 f1];
p = plot(fullf1,fullf2,'bs','MarkerSize',4);
a.datatype = 'drlist';
a.drlist = pairlist;
set(p,'UserData',a);
fancystickies();

f1 = [];
f2 = [];
for (i = 1:numpairs)
    thispair = pairlist{sfi(i)};
    if showv
        isred = thispair.isV;
    else
        isred = thispair.istriple;
    end
    %suggestlist{i} = thispair;
    if thispair.ispossible && (thispair.minmoment > momentthresh) && (isred == 1);
       % fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
        f1(end+1) = thispair.lowpair.delf;
        f2(end+1) = thispair.highpair.delf;
    end
    %fprintf('frequency %3.5f / %3.5f \n',thispair.lowpair.delf,thispair.highpair.delf);
end
fullf1 = [f1 f2];
fullf2 = [f2 f1];
p = plot(fullf1,fullf2,'rs');
a.datatype = 'drlist';
a.drlist = pairlist;
set(p,'UserData',a);
fancystickies();

hold on;
f1 = [];
f2 = [];
for (i = 1:numpairs)
    thispair = pairlist{sfi(i)};
    if showv
        isred = thispair.isV;
    else
        isred = thispair.istriple;
    end
    %suggestlist{i} = thispair;
    if thispair.ispossible && (thispair.minmoment < momentthresh) && (isred == 1)
       % fprintf('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n');
        f1(end+1) = thispair.lowpair.delf;
        f2(end+1) = thispair.highpair.delf;
    end
    %fprintf('frequency %3.5f / %3.5f \n',thispair.lowpair.delf,thispair.highpair.delf);
end
fullf1 = [f1 f2];
fullf2 = [f2 f1];
p = plot(fullf1,fullf2,'rs','MarkerSize',4);
a.datatype = 'drlist';
a.drlist = pairlist;
set(p,'UserData',a);
fancystickies();
%fprintf('%d out of %d possible',nump,numpairs);

