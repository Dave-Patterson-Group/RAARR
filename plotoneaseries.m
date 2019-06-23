function plotoneaseries(kit)
fs = kit.series1.fs;
hs = kit.series1.hs;
usedfs = [];
usedhs = [];
for i = 1:length(fs)
    if isfield(kit,'aasignedfs')
        if ismember(fs(i),kit.aassignedfs)
            usedfs(end+1) = fs(i);
            usedhs(end+1) = hs(i);
        end
    else
        if (fs(i) > kit.visiblewindow(1)) && (fs(i) < kit.visiblewindow(2))
            usedfs(end+1) = fs(i);
            usedhs(end+1) = hs(i);
        end
    end
end
stickplot(kit.series1.fs,kit.series1.hs,'b');
hold on;
p = stickplot(usedfs,usedhs,'b');
set(p,'LineWidth',2);

fs = kit.series4.fs;
hs = kit.series4.hs;
usedfs = [];
usedhs = [];
for i = 1:length(fs)
    if isfield(kit,'visibleafs')
        if ismember(fs(i),kit.visibleafs)
            usedfs(end+1) = fs(i);
            usedhs(end+1) = hs(i);
        end
    end
    if isfield(kit,'aasignedfs')
        if ismember(fs(i),kit.aasignedfs)
            usedfs(end+1) = fs(i);
            usedhs(end+1) = hs(i);
        end
    end
  
end

stickplot(kit.series4.fs,kit.series4.hs,'k');
p = stickplot(usedfs,usedhs,'k');
set(p,'LineWidth',2);

title(['A series behavior' kit.fakemolname]);
%addtext(kit.abendstring,1);
b = ylim;
b(2) = b(2) * 2.05;
ylim(b);    
try
    addtext(sprintf('%s\n\n\n%s',kit.fullerrorstring,kit.highlowstring ));
end
precisestickies;
1;
end

