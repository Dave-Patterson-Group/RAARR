   function outputfit = trypatterns(kit,patternlist)
    outputfit = 0;
    bestqualityyet = 0;
    if isfield(kit,'tightnesssettings') == 0
        kit.tightnesssettings = settingsfromtightness(1);
    end
    numtotry = min(length(patternlist),kit.tightnesssettings.patternfitting.maxpatterns);
 
    resetSPFITCOUNT();
    
    for j = 1:numtotry   
        thisPattern = patternlist{j};
        fprintf('trying %d/%d patterns, starting with %s\n',j,numtotry,thisPattern.descriptor);
        thisPattern.attemptIndex = j;

        foundFit = tryPattern(thisPattern,kit);   %horrible flow. what does tryss return? a kit?   No, return just a finalfit
 
        quality = foundFit.quality;
        if quality > bestqualityyet  %good hit
            outputfit = foundFit;
            bestqualityyet = quality;
        
            if foundFit.yesvotes > kit.tightnesssettings.greathitvotecount  %great hit - put this into tightness though.
                break; %we're done. could also keep looking
            end
        end
    end
    if isstruct(outputfit)
        outputfit.spfitcount = getSPFITCOUNT();
    end