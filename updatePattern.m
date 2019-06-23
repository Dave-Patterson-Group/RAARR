function s = updatePattern(s,kit)

fgrid = s.fgrid;
hgrid = fgrid * 0;
allfs = [];
allhs = [];
for i = 1:length(fgrid(:,1))
    for j = 1:4
        thisf = fgrid(i,j);
        if thisf > 0
            thish = findHeight(thisf,kit);
            hgrid(i,j) = thish;
            allfs(end+1)= thisf;
            allhs(end+1) = thish;
        end
    end
end
[allfs,XI] = sort(allfs);
s.allfs = allfs;
s.allhs = allhs(XI);


function h = findHeight(f,kit)
i = find(kit.onedpeakfs == f,1,'first');
h = kit.onedpeakhs(i);

