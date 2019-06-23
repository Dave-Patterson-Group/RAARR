function sortedcellarray = sortstructcellarraybyfield(cellarray, fieldname)
if length(cellarray) == 0
    sortedcellarray =  {};
    return
end
to_sort = [];

for i = 1:length(cellarray)
    to_sort(i) = getfield(cellarray{i},fieldname);
end

[sorted, indices] = sort(to_sort);
sortedcellarray = cellarray(indices);

if not(isempty(sortedcellarray))
    if isfield(sortedcellarray{1},'source')
        for i = 1:length(sortedcellarray)
            sortedcellarray{i}.databaseID = i;
        end
    end
end