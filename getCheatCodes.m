function cheatCodes = getCheatCodes(molname,cheatLevel)
cheatCodes = defaultCheatCodes();

switch molname
    case 'myrtenal'
        cheatCodes.forcef1 = 13700;
        cheatCodes.forcef2 = 15380; %13700 is myrtenal 818->717. 15380 is 919->818
    case 'nopinone'
        cheatCodes.forcef1 = 14256.36;%16598.1 is nopinone 616->717
        cheatCodes.forcef2 = 16598.1;%
    case 'hexanal'
        cheatCodes.forcef1 = 9971.5; %9971.5, height 283 rank 23, is strngest hexanal f1 line %14953.65;
        cheatCodes.forcef2 = 11632.6;
    case 'angelica'
        cheatCodes.forcef1 = 14381.5; %14381.5; is angelica lactone 414->313
        cheatCodes.forcef2 = 17889; %17889 is angelica lactone 515->414 next is 21354.8 then 24783.6 low J barely works 
    case 'm_anisaldehyde'
        cheatCodes.forcef1 = 14674.4;
        
%         cheatCodes.forcef1 = 14700.358;% 10 1 10 -> 9 1 9
%         cheatCodes.forcef2 = 16100.998;
    case 'benzaldehyde'
        cheatCodes.forcef1 = 12846.731;%
        cheatCodes.forcef2 = 15362.489;
    case 'cinnamaldehyde'
        cheatCodes.forcef1 = 11696.5;% 11 1 11 -> 10 1 10
        cheatCodes.forcef2 = 12753.7;% room for improvement - doesn't perform as well with cheats.
    case 'betapinene'  %didn't work with original settings. scaffold has only 3.
        cheatCodes.forcef1 = 14110.9;% 15 1 15 0=>14 1 14 0 next line 18734. line is there.. 
        cheatCodes.forcef2 = 16425.4;% room for improvement - doesn't perform as well with cheats.
    case 'ethylguiacol'  %didn't work with original settings. scaffold has only 3.
        cheatCodes.forcef1 = 15114.4;% 11 2 10-> 10 2 9  must use ka = 1. not yet.
        cheatCodes.forcef2 = 15133.6;% room for improvement - doesn't perform as well with cheats.
        cheatCodes.forceka = 1;
    case 'florol'  %quite slow - 15 minutes or so
        cheatCodes.forcef1 = 14162.70;%16 1 16 0=>15 1 15 0 a
        cheatCodes.forcef2 = 15044.828;
    case 'cinnamyl_alcohol'  %something weird, f1 lines 13 and 14 are very weak. heights barely work
        cheatCodes.forcef1 = 9453.0;% 9 1 9 -> 8 1 8
        cheatCodes.forcef2 = 10500.1;%16 1 16 0=>15 1 15 0 a
    case 'alpha_terpineol'  %very slow, maybe 20 minutes
        cheatCodes.forcef1 = 10313.04;% 
        cheatCodes.forcef2 = 11450.19;%   
    case 'eucalyptus'  %very slow, maybe 20 minutes
        cheatCodes.forcef1 = 15529.94; %17726.15 is 8 1 8 -> 7 1 7 eucalyptus unknown component;% 
        cheatCodes.forcef2 = 17726.15;%  
    case 'dioxolane'  
        cheatCodes.forcef1 = 17675.49; %17675.49 is 8 1 8 -> 7 1 7 dioxolane 1;% 
        cheatCodes.forcef2 = 19848.49;% 19848.49 is 9 1 9 -> 8 1 8 dioxolane 2;% 
    case '../squareassign/Molecules/fakes/fakeMyrtenalac.csv'
        cheatCodes.forcef1 = 12068.7; % 15428.3 17831.3 is strong c-types
        cheatCodes.forcef2 = 13731.6;%  9405.01 10372 is weak c-types
    otherwise
        if cheatLevel > 0
            fprintf('molecule %s has unknown cheats, setting cheat level to 0',molname);
        end
end
cheatCodes.correctf1 = cheatCodes.forcef1;
cheatCodes.correctf2 = cheatCodes.forcef2;

switch cheatLevel
    case 0
        cheatCodes = defaultCheatCodes();
        
        
    case 1
        
        cheatCodes.forcef2 = 0;
        cheatCodes.cheatString = 'one cheat armed';
        
end
        
function codes = defaultCheatCodes()
	codes.correctf1 = 0;
    codes.correctf2 = 0;
    codes.forcef1 = 0;
    codes.forcef2 = 0;
    codes.cheatString = 'No cheats armed';
    codes.forceka = [];