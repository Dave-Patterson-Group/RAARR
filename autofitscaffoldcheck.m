function autofitscaffoldcheck

molnames = {'myrtenal','nopinone','benzOD'};
reports = {};
allkits = {};
for i = 1:length(molnames)
  %  try
        outputkit = autofit(molnames{i},'scaffold');
        allkits{end+1} = outputkit;
        reports{end+1} = allkits{end}.allReports;
        archivetext(reports{end},'experimentalarchive2.txt');
        close all;
end
for i = 1:length(reports)
    fprintf('\n%s\n=====================\n', reports{i});
    displaykitwithfits(allkits{i},1);
end
