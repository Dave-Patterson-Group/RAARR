function [kit] = findallspecies(kit)
    tic;
    bestp = 1;
    while kit.numspecies < kit.tightnesssettings.patternfitting.maxcomponents
        switch kit.method
            case 'scaffold'
                patternlist = findpatternvariant1(kit);  %this line is all that changes between my old code, Lias, and new variants.
                newfit = trypatterns(kit,patternlist);
            case 'atype'
                patternlist = findpatternvariant3(kit);
                newfit = trypatterns(kit,patternlist);
            case 'bowties'
                patternlist = findpatternbowties(kit);
                newfit = trypatterns(kit,patternlist);
            case 'bruteforce'
                newfit = findbruteforcefit(kit);
            otherwise
                error('method %s is unknown\n',kit.method);
        end
        
        
        if isstruct(newfit)
            newfit = improvefit(newfit,kit);
            kit = addfittokit(kit,newfit);
        else
            break
        end
    end
    kit.allReports = makeAllReports(kit);
    
    if length(patternlist) > 0
        bestp = patternlist{1}.pval;
        kit.latestp = bestp;
        kit.latestpattern = patternlist{1};
    end
    

    
function s = makeAllReports(kit)
summary = sprintf('Summary for %s\n',kit.reportfilename);
for i = 1:length(kit.fitlist)
    thisFit = kit.fitlist{i};
    s = sprintf('%s\n%s',summary,thisFit.longdescription);
end
if length(kit.fitlist) > 0
    g = fopen(kit.reportfilename,'w');
    fprintf(g,s);
    fclose(g);

    fprintf(s);
    1;
else
    s = [summary 'NO FIT FOUND'];
end
time_elapsed = toc;
s = sprintf('%s===%3.1f seconds',s,time_elapsed);

