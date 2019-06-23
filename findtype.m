function type = findtype(line)

% selection rules
% a type: deltaKa = 0; delta Kc = +/- 1
% b type: deltaKa = +/- 1 deltaKc = +/- 1
% c type: deltaKa = +/- 1 deltaKc = 0

deltaKa = line.Kaupper - line.Kalower;
deltaKc = line.Kcupper - line.Kclower;
deltaJ = line.Jupper - line.Jlower;

if deltaKa == 0
    type = 'a';
else
    if abs(deltaKc) == 1
        type = 'b';
    else
        type = 'c';
    end
end
if abs(deltaJ) > 1
    type = 'X';
end
end

