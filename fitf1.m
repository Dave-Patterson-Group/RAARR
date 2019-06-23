 function [k,residuals,predicts,J,exitflag,f0predicts] = fitf1(f,J,ka,startk)
        %finds k1,k2,k3 such that k1(J+1) + k2(f1((J+1)/k3) \approx f. J is
        %optional - if not included, this uses the integer test
        
        %the best part is predicts: this calls what the next and previous
        %frequency in the sequence should be.  The core of series-building.
        
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
        f = makerow(f);
        jguess = floor(f(1)/(f(2) - f(1)))-1;
        homeJ = (1:length(f)) + jguess - 1;
        if (nargin == 1) || (length(J) < length(f))  %guess J's)
            J = homeJ;
        end
        if length(startk) == 3
            [k,residuals,predicts,exitflag,f0predicts] = rawfitf1(f,J,ka,startk);
        else
            z0fracs = [2 8];
            bestResidual = Inf;
            for i = 1:length(z0fracs)
                [k1,residuals1,predicts1,exitflag1,f0predicts1] = rawfitf1(f,J,ka,[z0fracs(i) 0]);
                if norm(residuals1) < bestResidual
                    bestResidual = norm(residuals1);
                    k = k1;
                    residuals = residuals1;
                    predicts = predicts1;
                    exitflag = exitflag1;
                    f0predicts = f0predicts1;
                end
            end
        end
        
        
     function [k,residuals,predicts,exitflag,f0predicts] = rawfitf1(f,J,ka,startk)
        switch ka %'ftablefilek1.mat'
            case 0
                F1 = @(k,xdata) k(1)*(xdata+1) + k(2)*evalf1((xdata+1)/(k(3)/100),'ftablefilek0.mat');
                F0 = @(k,xdata) k(1)*(xdata+1) + k(2)*evalf0((xdata+1)/(k(3)/100),'ftablefilek0.mat');
            case 1
                F1 = @(k,xdata) k(1)*(xdata+1) + k(2)*evalf1((xdata+1)/(k(3)/100),'ftablefilek1.mat');
                F0 = @(k,xdata) k(1)*(xdata+1) + k(2)*evalf0((xdata+1)/(k(3)/100),'ftablefilek1.mat');
        end
        if length(startk) == 3
            k0 = startk;
        else    
            k1zero = mean(diff(f));
            if length(startk) == 2
                k2zero = k1zero/startk(1);  %this is shaky a.f.
            else
                k2zero = k1zero/2;
            end
            k3zero = 800;
            k0 = [k1zero k2zero k3zero];
        end
        kUpperBound = [k0(1)*2, k0(2)*2, 5000]; %bounds make it much more stable. In particular, f1(-1) is super sketchily defined - best avoided.
        kLowerBound = [100,0,200];
        %opts = options.FunctionTolerance = 1.000000e-06
        opts = optimoptions('lsqcurvefit','FunctionTolerance',1.000000e-07,'MaxFunctionEvaluations',300,'Display','off');
      %  opts = optimset('Display','on','FunctionTolerance',1.000000e-07);
        %opts = optimoptions('lsqcurvefit','Algorithm','levenberg-marquardt');
        [k,resnorm,~,exitflag,output] = lsqcurvefit(F1,k0,J,f,kLowerBound,kUpperBound,opts);

        residuals = F1(k,J)-f;
        predicts = F1(k,[J(1)-1,J(end)+1]);
        f0predicts = F0(k,J);
        %predicts(2) = F1(k,J(end)+1);
        if exitflag == 0
            1;
        end

