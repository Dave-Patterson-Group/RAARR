function output = selectcellarray(database,whichn)
%inefficient but allows for trimming and sorting of cell arrays.
output = {};
for i = 1:length(whichn)
    if whichn(i) <= length(database)
        output{end+1} = database{whichn(i)};
    end
end