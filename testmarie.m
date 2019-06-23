function [summary allreports] = testmarie(method,cheatLevel)
if nargin < 1
    method = 'scaffold';%'atype';%'scaffold'
end
if nargin < 2
    cheatLevel = 0;
end
molnames = {'mariealine'};


reports = {};
allkits = {};
numfound = 0;
ts = settingsfromtightness(1);
ts.correctheights = 0;
for i = 1:length(molnames)
  %  try
        fprintf('\n starting %s method %s  cheat level %d\n',molnames{i},method,cheatLevel);
        outputkit = autofit(molnames{i},method,cheatLevel,1,ts);
        allkits{end+1} = outputkit;
        reports{end+1} = allkits{end}.allReports;
        if length(outputkit.fitlist) > 0
            numfound = numfound+1;
        end
        archivetext(reports{end},'experimentalarchive2.txt');
        close all;
end
allreports = '';
for i = 1:length(reports)
    fprintf('\n%s\n=====================\n', reports{i});
    allreports = sprintf('%s\n%s\n=====================\n', allreports,reports{i});
    displaykitwithfits(allkits{i},1);
end
summary = sprintf('TOTAL %s: %d molecules, %d found\n',method,length(molnames),numfound);
allreports = sprintf('%s\nTOTAL: %d molecules, %d found\n',allreports,length(molnames),numfound);
disp(summary);