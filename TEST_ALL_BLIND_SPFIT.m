function TEST_ALL_BLIND_SPFIT
    csvfiles = dir('molecules/**/*.csv');
    molecules = string(zeros(1,length(csvfiles)));
    for i = 1:length(csvfiles)
        if strncmp('molecules/fakes/',csvfiles(i).name,16)
            continue;
        end
        molecules(i) = string([csvfiles(i).folder '\' csvfiles(i).name]);
    end
    molecules = unique(molecules);
    nummolecules = length(molecules);
    
    ts = settingsfromtightness(0);
    fp = ts.bowties();
    for i = 1:nummolecules
        fig = figure('units', 'normalized', 'OuterPosition', [0 0 1 0.95]);
        hold all;
        title(molecules(i));
        tic
        fprintf('\nTesting %s:\n', molecules(i));
        
        component = 1;
        savept = [0 0 0];
        for j = 1:5
            try
                if component == 1
                    [bestfit,kit,~] = quadsearchSPFIT_refactored(molecules(i), fp, 30);
                elseif ~all(savept == 0)
                    [bestfit,kit,~] = quadsearchSPFIT_refactored(molecules(i), fp, component*30, savept);
                else
                    [bestfit,kit,~] = quadsearchSPFIT_refactored(kit, fp, component*30);
                end
            catch
                continue;
            end
            if ~isstruct(bestfit)
                continue;
            end
            bestfit = testfitonfshs(bestfit,kit.onedpeakfs,kit.onedpeakhs);
            if bestfit.yesvotes < 8
                continue;
            end
            plotlinelist(bestfit, component, bestfit.ABC);

            kit.onedpeakfs = bestfit.onedpeakfs;
            kit.onedpeakhs = bestfit.onedpeakhs;
            component = component + 1;
        end
    end
end

function plotlinelist(outputs, component, conststr)
    if component == 1
        expfs = outputs.expfreq;
        exphs = outputs.expheight;
        stickplot(expfs,exphs,'b','experiment');
    end
    theoryfs = outputs.unstretchedpredictedf;
    theoryhs = outputs.predictedh * mean(outputs.hiths) / mean(outputs.predictedh);
    stickplot(theoryfs,-theoryhs,colorHash(outputs.fit,component),['theory ' num2str(conststr)]);
    legend(gca,'show');
    drawnow;
end

function stickplot(xvals,yvals,color,displayname)
    xv = [];
    yv = [];
    for (i = 1:length(xvals))
        xv((3*i) - 2) = xvals(i);
        xv((3*i) - 1) = xvals(i);   
        xv(3*i) = xvals(i);
        yv((3*i)-2) = 0;
        yv((3*i)-1) = yvals(i);
        yv(3*i) = 0;
    end
    plot(xv,yv,'Color',color,'DisplayName',displayname);
end

function rgb = colorHash(str,component)
    str = str(1:length(str)-2*component);
    hash = 0;
    for i = 1:32
        hash = hash + double(str(length(str)-i+1)) * 2^i;
    end
    hash = mod(hash, 2^64);
    rgb(1) = bitshift(bitand(hash, hex2dec('FF0000')), -16) / 255.0;
    rgb(2) = bitshift(bitand(hash, hex2dec('00FF00')), -8) / 255.0;
    rgb(3) = bitand(hash, hex2dec('0000FF')) / 255.0;
end
