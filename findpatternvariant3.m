function [candidatePatterns, phase1report] = findpatternvariant3(kit)
%called by findallspecies.  this does the original a-series algorithm. to
%my knowledge it only works on hexanal.
candidatePatterns = {};
allseriespairs = findSeriesPairsFromSpectrum(kit);
numtotry = findNumToTry(allseriespairs);

if numtotry == 0
    phase1report = 'No candidate a-series patterns found';
    return
end
phase1report = sprintf('found total of %d series from %3.1e, trying %d\n',length(allseriespairs), allseriespairs{1}.pval,numtotry);
disp(phase1report);

for i = 1:numtotry
    candidatePatterns{end+1} = patternFromSeriesPair(allseriespairs{i});
    1;
end


function pattern = patternFromSeriesPair(s)
    pattern.fgrid(:,1) = s.fgrid(:,1);    %an [nx4] matrix with series1,series2,series3,series4 in it.
    pattern.fgrid(:,4) = s.fgrid(:,2); 
    pattern.pval = s.pval;    %an estimate of how likely it was this pattern was coincidence.
    pattern.patternType = 'aTypes';   %this would be `doubleBowTie' for variant 2, or 'atypes' for variant 3
    pattern.archive = s;  %the full structure handed down from runvariant1. Keeping this is dangerous - lets me debug, also lets me cheat.
    pattern.descriptor = sprintf('seriesPair, %s',s.residualString); %a one line string to describe the pattern
    
function n = findNumToTry(thisSeriesList)
if length(thisSeriesList) == 0
    n = 0;
    return
end
ts = thisSeriesList{1}.ts;
pvals = extractonefieldfromcellarray(thisSeriesList,'pval');

qualified = length(find(pvals < ts.maxPval));
n = min(ts.maxPatterns,qualified);


        