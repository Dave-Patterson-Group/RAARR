function [kit] = autofit(molname,method,cheatLevel,numSpecies,ts)
%see https://docs.google.com/document/d/1NTClfHyvc3e374pUXlpBboRVQP3lmLa1WBqpqHNoN94/edit?usp=sharing
%to add a new method, like 'atype' or 'scaffold':
%update settingsfromtightness to include constraints for new method.

if nargin == 0
    %molname = 'myrtenal';
    molname = 'nopinone';
 %   molname = 'angelica';
   % molname = 'hexanal';  %hexanal is having trouble with the f1->f0 jump
  %  molname = 'BenzOD';
   numSpecies = 1;
end
if nargin < 2
    method = 'scaffold';
%   method = 'bowties';
%    method = 'atype';
end
if nargin < 3
    cheatLevel = 0;
end
csvfilename = completeFilename(molname);

if nargin < 5
    tightnesssettings = settingsfromtightness(1);
else
    tightnesssettings = ts;
end

kit = kitfromcsvfile(csvfilename,tightnesssettings);
kit.cheatLevel = cheatLevel;
kit.cheatCodes = getCheatCodes(molname,cheatLevel);

kit.method = method;
kit.tightnesssettings = tightnesssettings;

if (nargin >= 4) || (nargin == 0)
    kit.tightnesssettings.patternfitting.maxcomponents = numSpecies;
end
displaybarekit(kit);

%[kit] = findfitd(kit);
[kit] = findallspecies(kit);
savekit(kit);

%hexanal f1s: 11632.55 13293.32 14953.67 16613.57 18272.99
%hexanal f0s: 11799.56 13480.96 15160.66 16838.49 18514.24
%these lead to A being rather wrong, but the fit should converge.



function makepgos(kit)
    
    for i = 1:length(kit.fitlist)
        thisfit = kit.fitlist{i};
        pgofilename = sprintf('%s%s_comp%d.pgo',kit.directoryname,kit.molname,i);
        makepgofile(thisfit.molstats,pgofilename,6,'abc');
       % pgofilename =
    end
    

function savekit(kit)
    
    save(kit.kitfilename,'kit');
    displaykitwithfits(kit);
    
    if length(kit.fitlist) > 0
        makepgos(kit);
        try
            if (kit.cheatLevel <= 1)
                launchpgopher(kit.molname);
            end
        end
        try
            saveas(gcf,kit.figfilename);
            saveas(gcf,kit.pdffilename);
        catch
            fprintf('cannot save pdf, probably open in narcissistic adobe');
        end
    end
    disp(kit.fitlistreport);
    pause(0.001);




