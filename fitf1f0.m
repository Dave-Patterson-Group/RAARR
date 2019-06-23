 function [k residuals f1predicts f0predicts J1 J0 exitflag] = fitf1f0(f1,f0,ka,startk)
        %f1s are frequencies for series 1.  there must be at least 3
        %f0s are frequencies for sereies 0.  I think if there's none just
        %drop through to fitf1.
        
        %finds k1,k2,k3,k4 such that k1(J+1) + k2(f1((J+1)/k3) \approx f. J is
        %optional - if not included, this uses the integer test
        
        %following the rather poorly coded example at
        %https://www.mathworks.com/help/optim/ug/nonlinear-data-fitting-example.html
        % they (awfully) use x for their fit parameters (and data!!)
        %we will use the vector k
        %k(1) = k1
        if nargin < 3
            ka = 0;
        end
        if nargin < 4
            startk = [];
        end

        
        
        [J1,J0,errorcode] = guessJ(f1,f0);
        if errorcode < 0
            k = 0;
            exitflag = -10;
            residuals = [];
            f1predicts = [0 0];
            f0predicts = [0 0];
            J1 = 0;
            J0 = 0;
            
            return
        end
        
        if length(startk) == 4
            startk(3) = startk(3) * 100;
            [k,residuals,f1predicts,f0predicts,exitflag] = rawftf1f0(f1,f0,J1,J0,ka,startk);
        else
            z0fracs = [2 8];
            bestResidual = Inf;
            for i = 1:length(z0fracs)
                [k1,residuals1,f1predicts1,f0predicts1,exitflag1] = rawftf1f0(f1,f0,J1,J0,ka,[z0fracs(i) 0]);
                if norm(residuals1) < bestResidual
                    bestResidual = norm(residuals1);
                    k = k1;
                    residuals = residuals1;
                    f1predicts = f1predicts1;
                    f0predicts = f0predicts1;
                    exitflag = exitflag1;
                    
                end
            end
        end
                
     function [k,residuals,f1predicts,f0predicts,exitflag] = rawftf1f0(f1,f0,J1,J0,ka,startk)
        switch ka %'ftablefilek1.mat'
            case 0
                F1F0 = @(k,xdata) k(1)*abs(xdata) + (k(2)*evalf1((xdata)/(k(3)/(100)))) + (k(2)*evalf0((-xdata)/(k(3) * (1-(k(4)/1000))/100)));
            case 1
                F1F0 = @(k,xdata) k(1)*abs(xdata) + (k(2)*evalf1((xdata)/(k(3)/(100)),'ftablefilek1.mat')) + (k(2)*evalf0((-xdata)/(k(3) * (1-(k(4)/1000))/100),'ftablefilek1.mat'));
            case 2
                F1F0 = @(k,xdata) k(1)*abs(xdata) + (k(2)*evalf1((xdata)/(k(3)/(100)),'ftablefilek1.mat')) + (k(2)*evalf0((-xdata)/(k(3) * (1-(k(4)/1000))/100),'ftablefilek1.mat'));
        end
        %   F0 = @(k,xdata) k(1)*(xdata+1) + k(2)*evalf0((xdata+1)/(k(3)/100));
        if length(startk) == 4
            k0 = startk;
        else
            k1zero = mean(diff(f1));
            if length(startk) == 2
                k2zero = k1zero/startk(1);  %this is shaky a.f.
            else
                k2zero = k1zero/2;
            end
            %k2zero = k1zero/8;  %this is shaky a.f.
            k3zero = 800;
            k4zero = 0;
            k0 = [k1zero k2zero k3zero k4zero];
        end
        kUpperBound = [k0(1)*2, k0(2)*2, 5000,200]; %bounds make it much more stable. In particular, f1(-1) is super sketchily defined - best avoided.
        kLowerBound = [100,0,200,-200];
        if (ka == 1) && (length(f0) == 1)
            kUpperBound(4) = 20;
            kLowerBound(4) = -20;
        end
        %opts = options.FunctionTolerance = 1.000000e-06
        opts = optimoptions('lsqcurvefit','FunctionTolerance',1.000000e-07,'MaxFunctionEvaluations',300,'Display','off');

          allf = [f1 f0];
        allJ = [J1+1 -(J0+1)];  %negative J means effectively call f0
%         [allJ XI] = sort(allJ);
%         allf = allf(XI);
        [k,resnorm,~,exitflag,output] = lsqcurvefit(F1F0,k0,allJ,allf,kLowerBound,kUpperBound,opts);

        
        residuals = F1F0(k,allJ)-allf;
        %k
        f1predicts = F1F0(k,[J1(1),J1(end)+2]);
        f0predicts = F1F0(k,[-J0(1),-(J0(end)+2)]);
        k(3) = k(3)/100;
% 
%         figure;
%         guessf = abs(allJ)*k0(1);
%         subplot(311);
%         plot(allJ+1,allf,'bs');
%         subplot(312);
%         plot(allJ+1,allf-guessf,'rs');
%         subplot(313);
%         plot(allJ+1,residuals,'bs');
%         %predicts(2) = F1(k,J(end)+1);
%         if exitflag == 0
%             1;
%         end

    function [J1,J0,errorcode] = guessJ(f1,f0)
        errorcode = 0;
        J1 = f1*0;
        J0 = f0 * 0;
        jguess = floor(f1(1)/(f1(2) - f1(1)))-1;
        J1 = (1:length(f1)) + jguess - 1;
        J0 = f0 * 0;
        if length(f0) == 0
            J0 = [];
            errorcode = -1;
            return
        end
        %now find f0 closest to the middle.
        f0errors = abs(f0 - mean(f1));
        besti = find(f0errors == min(f0errors),1);
        thisf0 = f0(besti);
        f1errors = thisf0 - f1;  %f0 always higher than f1 for this
        bestj = find(f1errors > 0,1,'last');
        if length(bestj) == 0
            errorcode = -1;
            return;
        end
        J0(besti) = J1(bestj);
        for i = 1:length(f0)
            if i ~= besti
                J0(i) = (i-besti) + J0(besti);
            end
        end
        1;


