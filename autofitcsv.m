function [numconverged mostvotes bestfit finaltightness] = autofitcsv(csvfilename,forcef1)
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
  %    csvfilename = 'Molecules/heptaldehyde/heptaldehyde.csv';
 %    csvfilename = 'Molecules/menthone/menthonespectrum1.csv';
 % csvfilename = 'Molecules/myrtenal_1d/myrtenal.csv';
 % csvfilename = 'Molecules/annso/ANNSO.csv';
 %csvfilename = 'Molecules/fenugreek/fenugreek.csv';  %doesnt work
 %   csvfilename = 'Molecules/cyclohexanol/cyclohexanol.csv';
%    csvfilename = 'Molecules/cinnamaldehyde/cinnamaldehyde.csv';
% csvfilename = 'Molecules/cinnamyl_alcohol/cinnamyl_alcohol.csv';
 %   csvfilename = 'Molecules/myrtenol/myrtenolspectrum1.csv';  
 %csvfilename = 'Molecules/hexanal/hexanal.csv';  
% csvfilename = 'Molecules/alpha_terpineol/alpha_terpineol.csv'; 
%csvfilename = 'Molecules/cinnamyl_alcohol/cinnamyl_alcohol.csv';  
%csvfilename = 'Molecules/pulegone/pulegone.csv';  
 % csvfilename = 'Molecules/ethylguiacol/ethylguiacolspectrum1.csv'; 
   csvfilename = 'Molecules/BenzOD/BenzOD.csv';
 %    csvfilename = 'Molecules/benzyl_alcohol/benzyl_alcohol.csv';
%     csvfilename = 'Molecules/1-pentanol/1-pentanol.csv';
 %   csvfilename = 'Molecules/betapinene_1d/betapinene.csv';
  %  csvfilename = 'Molecules/benzaldehyde/benzaldehyde.csv';
 %   csvfilename = 'Molecules/Nopinone_1d/Nopinone.csv';
 %   csvfilename = 'Molecules/alpha_pinene_1d/alpha_pinene.csv';
 % csvfilename = 'Molecules/butanol_1d/butanol.csv';  %butanol didnt work 
  explore = 0;
  totalallowedtime = 1000;
startingtightness = 1.0;
%totalallowedtime = 30;
% forcef1 = [1:40];
%  
%forcef1 = 14471.6;

% forcef1 = 4725.534;
%  forcef2 = 5753.5; %pulegone as
  
%   forcef1 = 3890.6;
%   forcef2 = 5122.0; %pulegone as

%  forcef1 = 12753.6;
%  forcef2 = 13809.3; %cinn D
 
%   forcef1 = 10338.7;
%  forcef2 = 11623.9; %cinn slashup
 
%  forcef1 = 14479.7;
%  forcef2 = 15647.4; % menthone a-type
 
%   forcef1 = 13189.4;
%  forcef2 = 14397.8; % menthone b-type
 
%   forcef1 = 14397.8;
%  forcef2 = 15594.4; % menthone b-type
% forcef2 = 14847.1;
 %forcef1 = 14662.2;
 %forcef1 = 13306.3;

%  forcef1 = 14075.8;
%  forcef2 = 15174.8; %guac
% 
%   forcef1 = 12745.1;
%  forcef2 = 15148; %benzOD
%   
 % Dinverted = 1;
  
%  forcef1 = 13121.4;
%  forcef2 = 14719; %benzOD

%   
%   forcef1 = 13374.92;
%   forcef2 = 16144.3; %benzOD
  
%forcef1 = 13731.6; %myrtenal a-type
%forcef1 = 13661.9;  %myrtenal b-type
% forcef2 = 15359.8;

end


kit = kitfromcsvfile(csvfilename);
% displaybarekit(kit);
% 1;

%findquads(fs,hs);

kit.forcef1 = forcef1;
kit.forcef2 = forcef2;
kit.startingtightness = startingtightness;
%kit.Dinverted = Dinverted;
%[kit] = autofitkitb(argsin);
if explore == 1
    exploretightness(kit);
else
    numconverged = 0;
    kit.skipspfit = 0;
    [kit foundone bestpval finaltightness] = findfitb(kit,totalallowedtime);
    if isstruct(kit.latestfit) == 0
        mostvotes = 0;
    else
        mostvotes = kit.latestfit.yesvotes;
        bestfit = kit.latestfit;
        
        numconverged = 1;
        %look for more conformers
        if conformers == 1
            foundone = 1;
            while foundone
                foundone = 0;
                kit.latestfit = 0;

                [kit foundone2 bestpval2 finaltightness2] = findfitx(kit,totalallowedtime);
                pause(.001);
                if isstruct(kit.latestfit)
                    foundone = 1;
                    mostvotes = [mostvotes kit.latestfit.yesvotes];
                    numconverged = numconverged+1;
                end
            end
        end
    end
    fprintf('%s %d species  with  %s upvotes\n',csvfilename,numconverged,num2str(mostvotes));
end


function [fs hs] = spectralcorrection(fs,rawhs)
[fs XI] = sort(fs);
rawhs = rawhs(XI);
if max(fs) < 10000
    hs = rawhs;
    return;
end


envfreqs = 1000 * ...
    [7 7.5 8  8.5 9  9.5 10  10.5 11  11.5 12  12.5  13  13.5 14  14.5 15  15.5 16  16.5 17  17.5 18  18.5 19  19.5 20   20.5];

envamps = ...
   [6 6  6 4  3  2   1.5  1.5   1.5   1.5    1  1    1    1    1    1   1    1    1   1   1    2   3   4   3  4    5  5];

ampenv = interp1(envfreqs,envamps,fs);
hs = rawhs .* ampenv;
hs = hs * mean(rawhs) / mean(hs);

function kit = kitfromcsvfile(csvfilename)
try
    M = csvread(csvfilename);
    freqs = M(:,1);
    amps = M(:,2);
catch
    
    M = dlmread(csvfilename,' ');
    freqs = M(:,1);
    amps = M(:,2) * 1000;
end

peakresults = findpeaksd(freqs,amps,7,.050);
fs = peakresults.exactfs;
hs = peakresults.exacths;
[fs hs] = spectralcorrection(fs,hs);

lastslash = find(csvfilename == '/',1,'last') + 1;
lastdot = find(csvfilename == '.',1,'last') - 1;
kit.kitfilename = [csvfilename(1:end-4) 'kit'];
kit.molfilename = csvfilename(lastslash:lastdot);
kit.onedpeakfs = fs;
kit.onedpeakhs = hs;
kit.numspecies = 0;
kit.fitlist = {};
kit.Dinverted = 1;
kit.experimental = 1;
kit.csvfilename = csvfilename;
kit.whichspecies = zeros(1,length(kit.onedpeakfs));
kit.templateabsolute = zeros(1,50);
kit.templatenorm = zeros(1,50);
kit.forcecorners = 0;
kit.cornermap = 0;
%kit.tightmode = tightmode;
kit.breakmode = 1;
kit.maxka = 2;
kit.flexibletightness = 1;
kit.flextights = 0;
kit.skipfit = 0;

% menthonespectrum1 CONVERGED 1 times in 605.750810 seconds with 33 upvotes
% myrtenal CRASHED    in 49.416529 seconds 
% alpha_pinene CONVERGED 1 times in 56.215933 seconds with 46 upvotes
% Nopinone CONVERGED 1 times in 96.898292 seconds with 43 upvotes
% myrtenolspectrum1 FAILED    in 225.594102 seconds 
% cinnamaldehyde CONVERGED 1 times in 65.343996 seconds with 59 upvotes
% betapinene CONVERGED 1 times in 82.440154 seconds with 45 upvotes
% benzaldehyde CONVERGED 1 times in 57.030277 seconds with 40 upvotes
% BenzOD FAILED    in 113.083143 seconds 

