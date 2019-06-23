function s = stripcellarray(cellarray)

s = zeros(1,length(cellarray));
for i = 1:length(s)
    s(i) = cellarray{i};
end
end

