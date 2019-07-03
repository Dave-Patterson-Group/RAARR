function TEST_ALL_BLIND_SPFIT
    csvfiles = dir('molecules/**/*.csv');
    molecules = string(zeros(1,length(csvfiles)));
    for i = 1:length(csvfiles)
        if strcmp('molecules\fakes',csvfiles(i).folder(end-14:end)) || ...
                strcmp('molecules\theory templates',csvfiles(i).folder(end-25:end))
            continue;
        end
        molecules(i) = string([csvfiles(i).folder '\' csvfiles(i).name]);
    end
    molecules = unique(molecules);
    molecules = molecules(3:end);
    nummolecules = length(molecules);
    
    ts = settingsfromtightness(0);
    fp = ts.bowties;
    
    for i = 1:nummolecules
        fprintf('\ni = %d, Testing %s:\n', i, molecules(i));
        tic
        try
            kit = kitfromcsvfile(molecules(i));
        catch
            "Sorry, this file can't be opened.\n"
            continue;
        end
        molstr = regexprep(molecules(i), '\\', '\\\\');
        plotlinelist(kit,0,molstr);
        component = 1;
        savept = [0 0 0];
        failedOne = false;
        consts = zeros(0,3);
        for j = 1:6
            if mod(j,2)
                fp.weakAorB = false;
            else
                fp.weakAorB = true;
            end
            try
                if component == 1
                    [bestfit,kit,~] = quadsearchSPFIT_refactored(molecules(i), fp, 60);
                elseif ~all(savept == 0)
                    [bestfit,kit,~] = quadsearchSPFIT_refactored(kit, fp, component*60, savept);
                else
                    [bestfit,kit,~] = quadsearchSPFIT_refactored(kit, fp, component*60);
                end
            catch
                break;
            end
            if ~isstruct(bestfit)
                if failedOne
                    break;
                else
                    failedOne = true;
                    component = component + 1;
                    savept = [0 0 0];
                    continue;
                end
            end
            bestfit = testfitonfshs(bestfit,kit.onedpeakfs,kit.onedpeakhs);
            if bestfit.yesvotes < 8
                savept = bestfit.savept;
                continue;
            else
                failedOne = false;
                savept = [0 0 0];
                dashIdx = strfind(bestfit.shortstring,'-');
                plotlinelist(bestfit, component, bestfit.shortstring(1:dashIdx(1)-1));

                kit.onedpeakfs = bestfit.onedpeakfs;
                kit.onedpeakhs = bestfit.onedpeakhs;
                component = component + 1;

                if j == 6
                    "LOOKED THROUGH ALL LINES IN SPECTRUM"
                end
            end
        end
    end
end

function plotlinelist(outputs, component, txtstr)
    if component == 0
        fig = figure('units', 'normalized', 'OuterPosition', [0 0 1 0.95]);
        hold all;
        title(txtstr);
        expfs = outputs.onedpeakfs;
        exphs = outputs.onedpeakhs;
        freqs = outputs.freqs1d;
        amps = outputs.amps1d;
        stickplot(freqs,amps,'b','experiment');
%         stickplot(expfs,exphs,'b','experiment');
    else
        theoryfs = outputs.unstretchedpredictedf;
        theoryhs = outputs.predictedh * mean(outputs.hiths) / mean(outputs.predictedh);
        alltheoryfs = outputs.allpredictedf;
        alltheoryhs = outputs.allpredictedh * mean(outputs.hiths) / mean(outputs.predictedh);
        xl = xlim();
        idxs = find(alltheoryfs > xl(1) & alltheoryfs < xl(2));
        alltheoryfs = alltheoryfs(idxs);
        alltheoryhs = alltheoryhs(idxs);
        stickplot(alltheoryfs,-alltheoryhs,fliplr(colorHash(outputs.fit,component)),['all theory ' txtstr]);
%         stickplot([theoryfs outputs.hitfs],[-theoryhs theoryhs],colorHash(outputs.fit,component),['theory ' txtstr]);
        stickplot(theoryfs,-theoryhs,colorHash(outputs.fit,component),['fit theory ' txtstr]);
        legend(gca,'show');
    end
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
