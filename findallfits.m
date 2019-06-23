function kit = findallfits(kit)

    while kit.numspecies < kit.tightnesssettings.maxcomponents
        kit.candidateScaffolds = {};
        kit.bestScaffoldp = 1;  %erase candidates for the new round..
                   
        [kit,foundone] = findfitd(kit);
  
        if foundone == 0
            break;
        end
    end
    if kit.numspecies > 0
        kit.finalfit = kit.fitlist{1};
    end
    kit.allReports = makeAllReports(kit);


function s = makeAllReports(kit)
summary = sprintf('Summary for %s\n',kit.reportfilename);
longwinded = '';
for i = 1:length(kit.fitlist)
    thisFit = kit.fitlist{i};
    thisReport = thisFit.fullReport;
    cutoff = find(thisReport == ',',1,'first');
    smallReport = thisReport(1:cutoff-1);
    longwinded = sprintf('%s\n=======================================\nspecies %d:\n%s',longwinded,i,thisReport);
    summary = sprintf('%s\n%s',summary,smallReport);
    s = sprintf('%s\n+++++++++++++++++++++++++\n%s',summary,longwinded);
    1;
end
g = fopen(kit.reportfilename,'w');
fprintf(g,s);
fclose(g);

fprintf(s);
1;

