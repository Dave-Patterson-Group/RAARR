function [kit] = autofitladder(csvfilename,correctheights,forces,tightnessSetting)
forcef2 = 0;
forcef1 = 0;
if nargin >= 3
    forcef1 = forces(1);
    if length(forces) == 2
        forcef2 = forces(2);
    end
end
if nargin < 4
    tightnessSetting = settingsfromtightness(1);
end

%startingtightness = 1;

if nargin < 2
    correctheights = 1;
end
if nargin == 0 
 % csvfilename = 'Molecules/heptaldehyde/heptaldehyde.csv';
 % csvfilename = 'Molecules/florol/florol.csv';
 % csvfilename = 'Molecules/anisaldehyde/anisaldehyde.csv';
 % csvfilename = 'Molecules/Rosemary/Rosemary.csv';  %didnt work a-c types
 % csvfilename = 'Molecules/cedramber/cedramber.csv';  %didnt work
 %butanol csvfilename = 'Molecules/menthone/menthonespectrum1.csv';
 %csvfilename = 'Molecules/myrtenal_1d/myrtenal.csv';
 csvfilename = 'Molecules/angelicalactonebroad/angelicalactonebroad.csv';
 % csvfilename = 'Molecules/annso/ANNSO.csv';
 % csvfilename = 'Molecules/fenugreek/fenugreek.csv';  %doesnt work
 % csvfilename = 'Molecules/cyclohexanol/cyclohexanol.csv';
 % csvfilename = 'Molecules/cinnamaldehyde/cinnamaldehyde.csv';
 % csvfilename = 'Molecules/cinnamyl_alcohol/cinnamyl_alcohol.csv';
 % csvfilename = 'Molecules/myrtenol/myrtenolspectrum1.csv';  
 % csvfilename = 'Molecules/hexanal/hexanal.csv';  
 % csvfilename = 'Molecules/alpha_terpineol/alpha_terpineol.csv'; 
 % csvfilename = 'Molecules/cinnamyl_alcohol/cinnamyl_alcohol.csv';  
 % csvfilename = 'Molecules/pulegone/pulegone.csv';  
 % csvfilename = 'Molecules/ethylguiacol/ethylguiacolspectrum1.csv'; 
 % csvfilename = 'Molecules/BenzOD/BenzOD.csv';
 % csvfilename = 'Molecules/benzyl_alcohol/benzyl_alcohol.csv';
 % csvfilename = 'Molecules/1-pentanol/1-pentanol.csv';
 % csvfilename = 'Molecules/betapinene_1d/betapinene.csv';
 % csvfilename = 'Molecules/benzaldehyde/benzaldehyde.csv';
%  csvfilename = 'Molecules/Nopinone_1d/Nopinone.csv';
 % csvfilename = 'Molecules/alpha_pinene_1d/alpha_pinene.csv';
 % csvfilename = 'Molecules/butanol_1d/butanol.csv';  %butanol didnt work 
 % csvfilename = 'Molecules/a_isomethyl_ionone/a_isomethyl_ionone.csv';
%   csvfilename = 'Molecules/m_anisaldehyde/m_anisaldehyde.csv'; 
% csvfilename = 'Molecules/benzyl_benzoate/benzyl_benzoate.csv';
 %csvfilename = 'Molecules/Lemon oil/Lemon oil.csv';
% csvfilename = 'Molecules/AngelicaLactoneFull/AngelicaLactoneFull.csv';
% csvfilename = 'Molecules/Orange extract/Orange extract.csv';
%csvfilename = 'Molecules/ethylbutyrate/ethylbutyrate.csv';
% csvfilename = 'Molecules/benzylacetate/benzylacetate.csv'; %didnt work bad spectrum
 %csvfilename = 'Molecules/linalool_oxide/linalool_oxide.csv'; %nice ladder from 15092, also 13860, but poor fit?
 %forcef1 = 13860;
%  csvfilename = 'Molecules/bacdanol/bacdanol.csv'; %15098 lokos good but somehow isn't? 
%  forcef1 = 15098;
end


kit = kitfromcsvfile(csvfilename,correctheights);
 displaybarekit(kit);
kit.forcef1 = forcef1;
kit.forcef2 = forcef2;
kit.tightnesssettings = tightnessSetting;
kit.maxka = kit.tightnesssettings.maxka;
%kit.startingtightness = startingtightness;
tic;

%[kit] = findfitd(kit);
kit = findallfits(kit);
kit.fitduration = toc;
disp(kit.fitlistreport)
kit.spfitcount = getSPFITCOUNT();
save(kit.kitfilename,'kit');

try
    displaykitwithfits(kit);
    saveas(gcf,kit.figfilename);
    saveas(gcf,kit.pdffilename);
catch
    fprintf('cannot save pdf, probably open in narcissistic adobe');
end
1;







