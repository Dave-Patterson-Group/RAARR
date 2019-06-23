function thisfit = addDerivatives(thisfit,stretchABC)
if nargin < 2
    stretchABC = [0 0 0];
end
delA = 0.1;  %small change in A, B, or C
%baseABC = thisfit.ABC;


basefit = quickspcat(thisfit,stretchABC);
plusAfit = quickspcat(thisfit,stretchABC + [delA 0 0]);
plusBfit = quickspcat(thisfit,stretchABC + [0 delA 0]);
plusCfit = quickspcat(thisfit,stretchABC + [0 0 delA]);
for i = 1:length(thisfit.lines)
    thisline = thisfit.lines{i};
    thisline.theoryf = basefit.lines{i}.stretchedf;
    thisline.dfdA = (plusAfit.lines{i}.stretchedf - basefit.lines{i}.stretchedf)/delA;
    thisline.dfdB = (plusBfit.lines{i}.stretchedf - basefit.lines{i}.stretchedf)/delA;
    thisline.dfdC = (plusCfit.lines{i}.stretchedf - basefit.lines{i}.stretchedf)/delA;
    thisline.dfdABC = [thisline.dfdA thisline.dfdB thisline.dfdC];
    thisfit.lines{i} = thisline;
end
1;