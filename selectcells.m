function newcells = selectcells(oldcells,whichi)
newcells = {};
for i = 1:length(whichi)
    if whichi(i) <= length(oldcells)
        newcells{i} = oldcells{whichi(i)};
    end
end

