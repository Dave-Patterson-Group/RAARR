function s  = makefitlistreport(kit)
s = sprintf('%s: %d components found\n',kit.molname,kit.numspecies);
for i = 1:length(kit.fitlist)
    thisfit = kit.fitlist{i};
    s = sprintf('%s component %d: %s\n',s,i,thisfit.fitdescriptor);
end

