function [candidatePatterns, phase1report] = findpatternvariant1(kit)
%called by findallspecies.  this does the variant 1 described in the RAARR
%paper

    kit.candidateScaffolds = {};
 %   kit.bestScaffoldp = 1;  %erase candidates for the new round..

    starttime = now;
    kit.speciesStarttime = starttime;
    kit.startCensus = kit.totalCensus;
    if kit.cheatCodes.forcef1 == 0
        linestouse = kit.tightnesssettings.lines;
    else
        linestouse = kit.cheatCodes.forcef1;
    end

    for i = 1:length(linestouse)
        linetouse = linestouse(i);
        kit = addsquaresfromline(kit,linetouse);
        elapsedTime = (now - starttime) * 1e5;
        timeToQuit = isItTimeToQuit(elapsedTime,kit.bestScaffoldp,kit.tightnesssettings.ladderSearchtimes);
        if (kit.bogged == 1) || (timeToQuit == 1)
            break;
        end
    end
    candidatePatterns = {};
    for i = 1:length(kit.candidateScaffolds)
        candidatePatterns{i} = patternFromScaffold(kit.candidateScaffolds{i});
    end
    kit.scaffoldEndtime = now;
    if length(kit.candidateScaffolds) == 0
            phase1report = sprintf('no scaffolds found, ran to line %d',i);
    else
            phase1report = sprintf('%d scaffolds, best scaffold %s, quads %s',length(kit.candidateScaffolds),kit.candidateScaffolds{1}.pvalstring,kit.candidateScaffolds{1}.longquadstring);
    end


function pattern = patternFromScaffold(scaffold)
    pattern.fgrid = scaffold.usablefgrid;    %an [nx4] matrix with series1,series2,series3,series4 in it. Can have any offset; zeros are read as 'unknown'
    pattern.pval = scaffold.netpval;    %an estimate of how likely it was this pattern was coincidence.
    pattern.patternType = 'scaffold';   %this would be `doubleBowTie' for variant 2, or 'atypes' for variant 3
    pattern.archive = scaffold;  %the full structure handed down from runvariant1. Keeping this is dangerous - lets me debug, also lets me cheat.
    pattern.descriptor = sprintf('scaffold, %s',scaffold.shortpvalstring); %a one line string to describe the pattern