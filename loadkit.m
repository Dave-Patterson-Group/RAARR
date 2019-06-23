function loadkit(csvfilename)
if nargin == 0
 %    csvfilename = 'Molecules/heptaldehyde/heptaldehyde.csv';
 %     csvfilename = 'Molecules/florol/florol.csv';
  %    csvfilename = 'Molecules/anisaldehyde/anisaldehyde.csv';
 % csvfilename = 'Molecules/Rosemary/Rosemary.csv';
  %    csvfilename = 'Molecules/cedramber/cedramber.csv';
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

end


fname = kitfilename(csvfilename);
load(fname,'kit');
displaykitwithfits(kit);



