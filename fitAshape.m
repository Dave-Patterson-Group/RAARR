function kit = fitAshape(kit,verbose)
%calculate and plots f_1 and f_2
if nargin < 1
    load('ttfile','kit');
else
    save('ttfile','kit');
end
if nargin < 2
    verbose = 1;
end
    s0 = kit.series1;
    Jforf0 = s0.jvalues;
    s0Frequencies = s0.fs;
    s0VisibleFrequencies = s0.visiblefs;
    midp = round(length(s0VisibleFrequencies)/2);
    s0VisibleF = s0VisibleFrequencies(midp);
    
    s1 = kit.series4;
%    J = 1:length(f1J);
    s1Frequencies = s1.fs;
    Jforf1 = s1.jvalues;
    
    s1VisibleFrequencies = s1.visiblefs;
    if length(s1VisibleFrequencies) < 3
        error('cannot do 3 parameter f1-f2 type fit on only two frequencies');
    end
    nextFrequencyDown = s1.fs(max(s1.visibleis(1) - 1,1));
    nextFrequencyUp = s1.fs(s1.visibleis(end) + 1);
    
    [truek trueresiduals predicts J exitflag] = fitf1(s1Frequencies,0,kit.ka);  %second argument is optional
    
    [k residuals predicts J exitflag f0predicts] = fitf1(s1VisibleFrequencies,0,kit.ka);  %second argument is optional
    
    [k2 residuals2 predicts2 J2 exitflag2 f0predicts2] = fitf1f0(s1VisibleFrequencies,s0VisibleFrequencies(2:end),kit.ka);  %second argument is optional
%     f0predicts
%     s0Frequencies(J+1);
hold off
plot(residuals2);
hold all;
plot(residuals);
plot(trueresiduals);
legend('residuals from combined fit,visible lines','residuals from f1 fit,visible lines','residuals from f1 fit,all lines');
addtext(num2str(k2));

% figure;
% plot(trueresiduals);
% hold all;
% plot(residuals2);
% 1;
    f0errors = f0predicts - s0Frequencies(J+1);
    f0errors
    actual = [nextFrequencyDown nextFrequencyUp];
 
    kit.s1PredictNextF = predicts;
    kit.s1ActualNextF = actual;
    kit.absPredictMax = max(abs(predicts - actual));
    kit.absPredictMaxF0 = max(abs(f0errors));
    kit.nextJ = [min(J)-1 max(J)+1];
    kit.s1FitResiduals = residuals;
    kit.s1MeanResidual = norm(residuals);
    kit.s1ExitFlag = exitflag;
    kit.s1FitString = sprintf('f1 fit %d lines within %3.4f MHz\n f1 predicts 2 lines within %3.4f MHz [%3.1f %3.1f]\npredicts f0 to within %3.1f MHz',length(J),kit.s1MeanResidual,kit.absPredictMax,predicts(1),predicts(2),kit.absPredictMaxF0);
    if exitflag == 0
        kit.s1FitString = sprintf('%s\n CURVE FIT DID NOT CONVERGE',kit.s1FitString);
    end
    kit.k1 = k(1);
    kit.k2 = k(2);
    kit.k3 = k(3);
    kit.truek1 = truek(1);
    kit.truek2 = truek(2);
    kit.truek3 = truek(3);
    s = sprintf('f1 type sereis found:\nFOUND k1=%3.2f,k2=%3.2f,k3=%3.2f',kit.k1,kit.k2,kit.k3);
	s = sprintf('%s\nTRUTH k1=%3.2f,k2=%3.2f,k3=%3.2f\n%s',s,kit.truek1,kit.truek2,kit.truek3,kit.a2bendstring);
    kit.verboseFitString = sprintf('%s\n%s\n%s\n',s,s1.polyPredictString,kit.s1FitString);
    
    
   
        