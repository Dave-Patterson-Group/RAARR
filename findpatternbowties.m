function candidatePatterns = findpatternbowties(kit)
    kit.tightnesssettings.bowties.weakAorB = false;
    [fgridsf, timesf] = findbowties(kit, 10);
    kit.tightnesssettings.bowties.weakAorB = true;
    [fgridst, timest] = findbowties(kit, 10);
    [times, IX] = sort([timesf timest]);
    fgrids = horzcat(fgridsf, fgridst);
    fgrids = fgrids(IX);
    N = length(times);
    hashes = zeros(1,N);
    for j = 1:N
        hashes(j) = sum(sum(fgrids{j}));
    end
    [~, IH] = unique(hashes, 'stable');
    fgrids = fgrids(IH);
    times = times(IH);
    N = length(times);
    candidatePatterns= cell(1,N);
    for j = 1:N
        candidatePatterns{j}.fgrid = fgrids{j};
        candidatePatterns{j}.pval = times(j) * 1e-9;
        candidatePatterns{j}.patternType = 'bowties';
        candidatePatterns{j}.archive = {};
        candidatePatterns{j}.descriptor = 'copyright 2019 RAARR';
    end
    1;
end