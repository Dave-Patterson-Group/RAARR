function lines = convertlinesetstolines(linesets)

lines = {};

for i = 1:length(linesets)
    thisset = linesets{i};
    for j = 1:length(thisset)
       lines{end + 1} = thisset{j}; 
    end
    lines{end + 1} = makelineforcsvfromstates(); %blank line, nothing special.
end

end