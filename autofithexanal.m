function [numconverged mostvotes bestfit finaltightness] = autofithexanal(csvfilename,forcef1)
forcef2 = 0;
explore = 0;
forcef1 = 0;
startingtightness = 1;
%confo
totalallowedtime = 200;
conformers = 0;
Dinverted = 1;
bestfit = 0;
if nargin == 0 

 csvfilename = 'Molecules/hexanal/hexanal.csv';  
 % csvfilename = 'Molecules/heptaldehyde/heptaldehyde.csv'; 
%  csvfilename = 'Molecules/1-pentanol/1-pentanol.csv';
%  csvfilename = 'Molecules/cinnamyl_alcohol/cinnamyl_alcohol.csv';
%  forcef1 = [15160.8 13293.4];
 % forcef2 = [16838.7 14953.8];
 forcef1 = [1:40];
  explore = 0;
  totalallowedtime = 1000;
startingtightness = 1.1;


end


kit = kitfromcsvfile(csvfilename);


% displaybarekit(kit);
% 1;

%findquads(fs,hs);

kit.forcef1 = forcef1;0
kit.forcef2 = forcef2;

kit.startingtightness = startingtightness;
kit = autofitseries(kit);

if length(kit.fitlist) > 0
   % try
        fprintf('%s a-type fit SUCCESS: %s\n%s',csvfilename,kit.finalfit.shortstring,kit.finalfit.shortextendstring)
        displaykitwithfits(kit);
        saveas(gcf,kit.figfilename);
        saveas(gcf,kit.pdffilename);
   % catch
   %     fprintf('cannot save pdf, probably open in narcissistic adobe');
   % end
else
    fprintf('%s a-type fit FAILED: no fit found. best series %d lines, pval %3.1g',csvfilename,kit.allseries{1}.numlines,kit.allseries{1}.pval);
end
1;


% 
% function [fs hs] = spectralcorrection(fs,rawhs)
% if max(fs) < 10000
%     hs = rawhs;
%     return;
% end
% [fs XI] = sort(fs);
% rawhs = rawhs(XI);
% 
% envfreqs = 1000 * ...
%     [7 7.5 8  8.5 9  9.5 10  10.5 11  11.5 12  12.5  13  13.5 14  14.5 15  15.5 16  16.5 17  17.5 18  18.5 19  19.5 20   20.5];
% 
% envamps = ...
%    [6 6  6 4  3  2   1.5  1.5   1.5   1.5    1  1    1    1    1    1   1    1    1   1   1    2   3   4   3  4    5  5];
% 
% ampenv = interp1(envfreqs,envamps,fs);
% hs = rawhs .* ampenv;
% hs = hs * mean(rawhs) / mean(hs);

% function kit = kitfromcsvfile(csvfilename)
% try
%     M = csvread(csvfilename);
%     freqs = M(:,1);
%     amps = M(:,2);
% catch
%     
%     M = dlmread(csvfilename,' ');
%     freqs = M(:,1);
%     amps = M(:,2) * 1000;
% end
% 
% peakresults = findpeaksd(freqs,amps,7,.050);
% fs = peakresults.exactfs;
% hs = peakresults.exacths;
% [fs hs] = spectralcorrection(fs,hs);
% 
% % lastslash = find(csvfilename == '/',1,'last') + 1;
% % lastdot = find(csvfilename == '.',1,'last') - 1;
% % kit.kitfilename = [csvfilename(1:end-4) 'kit'];
% % kit.molfilename = csvfilename(lastslash:lastdot);
% kit.molname = molnamefromfilename(csvfilename);
% kit.onedpeakfs = fs;
% kit.onedpeakhs = hs;
% kit.numspecies = 0;
% kit.fitlist = {};
% kit.Dinverted = 1;
% kit.experimental = 1;
% kit.csvfilename = csvfilename;
% kit.whichspecies = zeros(1,length(kit.onedpeakfs));
% kit.templateabsolute = zeros(1,50);
% kit.templatenorm = zeros(1,50);
% kit.forcecorners = 0;
% kit.cornermap = 0;
% %kit.tightmode = tightmode;
% kit.breakmode = 1;
% kit.maxka = 2;
% kit.flexibletightness = 1;
% kit.flextights = 0;
% kit.skipfit = 0;

% menthonespectrum1 CONVERGED 1 times in 605.750810 seconds with 33 upvotes
% myrtenal CRASHED    in 49.416529 seconds 
% alpha_pinene CONVERGED 1 times in 56.215933 seconds with 46 upvotes
% Nopinone CONVERGED 1 times in 96.898292 seconds with 43 upvotes
% myrtenolspectrum1 FAILED    in 225.594102 seconds 
% cinnamaldehyde CONVERGED 1 times in 65.343996 seconds with 59 upvotes
% betapinene CONVERGED 1 times in 82.440154 seconds with 45 upvotes
% benzaldehyde CONVERGED 1 times in 57.030277 seconds with 40 upvotes
% BenzOD FAILED    in 113.083143 seconds 

