function newarray = firstn(cellarray,n)
newarray = {};
for i = 1:min(n,length(cellarray))
    newarray{end+1} = cellarray{i};
end
    
