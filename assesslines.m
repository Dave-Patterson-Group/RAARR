function thisfit = assesslines(thisfit)
delABC = [20 10 8];  %could make c smaller?
vvals = {[1 1 1],[1 1 -1],[1 -1 1],[1 -1 -1]};
for i = 1:length(vvals)
    dABC =  (delABC .* vvals{i}); 
    linearerrors = testDerivatives(thisfit,dABC,0);
    linearerrors = abs(linearerrors);
    allerrors(i,:) = linearerrors;
end
allerrors = max(allerrors);
for i = 1:length(thisfit.lines)
    thisline = thisfit.lines{i};
    thisline.linearerror = allerrors(i);
    thisfit.lines{i} = thisline;
end
1;


