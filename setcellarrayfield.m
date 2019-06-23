function cellarray = setcellarrayfield(cellarray,fieldname,fieldvalue)

for i = 1:length(cellarray)
    thisp = cellarray{i};
    thisp = setfield(thisp,fieldname,fieldvalue);
    cellarray{i} = thisp;
end
    
