function newfit = improvefit(fit,kit)
%    broadfit = addDerivatives(broadfit);
%     broadfit = addHeights(broadfit,kit);
    if kit.tightnesssettings.evolveFit == 1
            fprintf('Evolving fit and CD\n');
            fit = evolveFit(fit,kit,'pvaledge',[10 5]);
            1;
            fprintf('\n==HiFi fit %s %d====\n',fit.scorefitdescriptor);
            fit = evolveFit(fit,kit,'broadpval',[8 4]);
            fprintf('\n+++DeepFi fit %s+++n',fit.scorefitdescriptor);
    end
    %newfit = addtemptofit(fit,kit);
    if kit.tightnesssettings.addisotopes == 1
        newfit = addC13s(fit,kit);
        newfit.quality = newfit.yesvotes; 
        newfit.longdescription = sprintf('FIT: %s %d C13s',newfit.shortdescriptor,length(newfit.isotopes));
    else
        newfit = fit;
        newfit.quality = newfit.yesvotes; 
        newfit.longdescription = sprintf('FIT: %s',newfit.shortdescriptor);
    end
    
    
        

