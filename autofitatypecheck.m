function autofitatypecheck(method,cheatLevel)
if nargin < 2
    cheatLevel = 2;
end
molnames = {'myrtenal','nopinone','m_anisaldehyde','angelica','benzaldehyde',...
            'betapinene','florol','cinnamyl_alcohol','eucalyptus'}; %'1-pentanol' and angelicalactone doesnt work 
reports = {};
allkits = {};
numfound = 0;
for i = 1:length(molnames)
  %  try
        outputkit = autofit(molnames{i},'atype',cheatLevel);
        allkits{end+1} = outputkit;
        reports{end+1} = allkits{end}.allReports;
        if length(outputkit.fitlist) > 0
            numfound = numfound+1;
        end
        archivetext(reports{end},'experimentalarchive2.txt');
        close all;
end
for i = 1:length(reports)
    fprintf('\n%s\n=====================\n', reports{i});
    displaykitwithfits(allkits{i},1);
end
fprintf('TOTAL: %d molecules, %d found\n',length(molnames),numfound);