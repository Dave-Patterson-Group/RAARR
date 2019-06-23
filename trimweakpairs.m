function outpairs = trimweakpairs(pairlist,heightthresh)
%displays the list, sorted by f.
outpairs = {};
if nargin < 2
    heightthresh = 0.05;
end
heights = extractfieldsfromcellarray(pairlist,{'sixKweakpulsestrength'});
heights = heights.sixKweakpulsestrength;
minheight = heights * heightthresh;

for i = 1:length(heights)
    if heights(i) >= minheight
        
        outpairs{end+1} = pairlist{i};
    end
    
end
%comment out the next line to not sort.

