function linearerrors = testDerivatives(thisfit,stretchABC,verbose)
if nargin < 2
    stretchABC = [0 0 0];
end
if nargin < 3
    verbose = 1;
end
basefit = quickspcat(thisfit,stretchABC);
% plusAfit = quickspcat(thisfit,stretchABC + [delA 0 0]);
% plusBfit = quickspcat(thisfit,stretchABC + [0 delA 0]);
% plusCfit = quickspcat(thisfit,stretchABC + [0 0 delA]);
normABC = norm(stretchABC);
%fprintf('\n==============\ntesting stretch = %s, norm %3.1f\n',num2str(stretchABC),normABC);
for i = 1:min(length(thisfit.lines))
    thisline = thisfit.lines{i};
    exactf = basefit.lines{i}.stretchedf;
    exactdelf = exactf - thisline.delf;
    dfdABC = [thisline.dfdA thisline.dfdB thisline.dfdC];
    
    approxdelf = dfdABC * stretchABC';
    linearerror = exactdelf - approxdelf;
    if (i <= 8) && verbose
        fprintf('line %d %c, f = %3.3f, exact Df = %3.3f, approx Df = %3.3f, linear errs by %3.3f\n',i,thisline.transitiontype,thisline.delf,exactdelf,approxdelf,linearerror);
    end
    linearerrors(i) = linearerror;
end
