function branch = findbranch(line)

% selection rules
% a type: deltaKa = 0; delta Kc = +/- 1
% b type: deltaKa = +/- 1 deltaKc = +/- 1
% c type: deltaKa = +/- 1 deltaKc = 0
deltaJ = line.Jupper - line.Jlower;

if abs(deltaJ) == 1
    branch = 'R';
end
if abs(deltaJ) == 0
    branch = 'Q';
end

end

