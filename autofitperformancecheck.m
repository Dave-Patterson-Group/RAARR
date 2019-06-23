function autofitperformancecheck

filenames = {'Molecules/m_anisaldehyde/m_anisaldehyde.csv',...
            'Molecules/Orange Extract/Orange Extract.csv',...
            'Molecules/alpha_terpineol/alpha_terpineol.csv',...
            'Molecules/BenzOD/BenzOD.csv',...
            'Molecules/florol/florol.csv',...
            'Molecules/anisaldehyde/anisaldehyde.csv',...
            'Molecules/menthone/menthonespectrum1.csv',...
            'Molecules/myrtenal_1d/myrtenal.csv',...
            'Molecules/alpha_pinene_1d/alpha_pinene.csv',...
            'Molecules/ethylguiacol/ethylguiacolspectrum1.csv',...
            'Molecules/Nopinone_1d/Nopinone.csv',...
            'Molecules/myrtenol/myrtenolspectrum1.csv',...
            'Molecules/cinnamaldehyde/cinnamaldehyde.csv',...
            'Molecules/betapinene_1d/betapinene.csv',...
            'Molecules/Lemon oil/Lemon oil.csv',...
            'Molecules/benzaldehyde/benzaldehyde.csv'...
            };
reports = {};
allkits = {};
for i = 1:length(filenames)
  %  try
        outputkit = autofitladder(filenames{i});
        allkits{end+1} = outputkit;
        reports{end+1} = reportfromkit(outputkit);
        archivetext(reports{end}.descriptor,'experimentalarchive2.txt');
        disp(reports{end}.descriptor);
        close all;
        displaykitwithfits(outputkit);
        try
            saveas(gcf,outputkit.figfilename);
            saveas(gcf,outputkit.pdffilename);
        catch
            fprintf('cannot save pdf, probably open in narcissistic adobe');
        end
  %  catch
  %      fprintf('%s crashed!\n',filenames{i});
  %  end
end
for i = 1:length(reports)
    disp(reports{i}.descriptor);
    displaykitwithfits(allkits{i},1);
end

function report = reportfromkit(kit)

if kit.foundfit == 1
    report.descriptor = kit.fitlistreport;  %add failure report as well..
else
    report.descriptor = sprintf('%s FAILED in %3.1f seconds %d squares sent to SPFIT\n',kit.molname,kit.fitduration,kit.spfitcount);
end
    report.descriptor = sprintf('%s final phase 1 report: %s\n\n',report.descriptor,kit.phase1report);
    

