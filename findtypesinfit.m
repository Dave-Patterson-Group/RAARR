function [types hasa hasb hasc ltypes] = findtypesinfit(fit)

% selection rules
% a type: deltaKa = 0; delta Kc = +/- 1
% b type: deltaKa = +/- 1 deltaKc = +/- 1
% c type: deltaKa = +/- 1 deltaKc = 0
lines = fit.info.lines;
numlines = length(lines);
ltypes = '';
for i = 1:length(lines)
    ltypes(end+1) = findtype(lines{i});
end

types = '';
hasa = 0;
hasb = 0;
hasc = 0;
if contains(ltypes,'a')
    types = [types 'a'];
    hasa = 1;
end
if contains(ltypes,'b')
    types = [types 'b'];
    hasb = 1;
end
if contains(ltypes,'c')
    types = [types 'c'];
    hasc = 1;
end


