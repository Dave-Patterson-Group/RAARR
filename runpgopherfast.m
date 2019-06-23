function [fs intensities hashes alltransitions] = runpgopherfast(molstats,temperature,VERBOSE,numlines,types,pgofilename)
if (nargin < 3)
    VERBOSE = 1;
end
if (nargin < 4)
    numlines = -1;
end
if (nargin < 5)
    types = 'abc';
    if isfield(molstats,'mua')
        types = '';
        if molstats.mua ~= 0
            types(end+1) = 'a';
        end
        if molstats.mub ~= 0
            types(end+1) = 'b';
        end
        if molstats.muc ~= 0
            types(end+1) = 'c';
        end
        
    end
end
if (nargin < 6)
    pgofilename  = [getspfitpath '/trial2.pgo'];
end
temperature;
%moldescription carries A,B,C, dipole, temp, all that.
%first, create a .pgo file.  This will take some work, essentially copy an
%existing one. Then run it:

%pgofilename  = 'basicrigidabc.pgo';
%temperature = 1;
tempfilename = [getspfitpath '/trial12.pgo'];
%pgofilename  = 'trial2.pgo';
%         molstats.a = 8.5721;
%         molstats.b = 3.6401;
%         molstats.c = 2.7909;  %this is 1-2 propanediol
%         
%         molstats.mua = 1.21;
%         molstats.mub = 2.10;
%         molstats.muc = 0.45;  %1-2 propanediol; quite a bit of uncertainty here.
%         molstats.molname = '1-2 propanediol';
%         
if  (molstats.b < 50) %working in GHz
    molstats.a = molstats.a * 1000;
    molstats.b = molstats.b * 1000;
    molstats.c = molstats.c * 1000;
    molstats.DK = molstats.DK * 1000;
    molstats.DJK = molstats.DJK * 1000;
    molstats.DJ = molstats.DJ * 1000;
    molstats.deltaK = molstats.deltaK * 1000;
    molstats.deltaJ = molstats.deltaJ * 1000;
end
molstats.forcemaxj = molstats.maxj * 2;
makepgofile(molstats,tempfilename,temperature,types)
copyfile(tempfilename,pgofilename,'f');
csvfile = [getspfitpath 'tempfile4.csv'];
%cmdline = [wd '\pgopher Mixture.PrintLevel=CSV ' wd '\' pgofilename ' >' wd '\' csvfile];

cmdline = [getspfitpath '/pgo Mixture.PrintLevel=Text Mixture.OThreshold=1e-10 ' pgofilename ' >' csvfile];


system(cmdline);


[fs intensities hashes alltransitions] = loadlinelistfast(csvfile,numlines,molstats);
1;
%[thesetrans fs] = loadlinelist(csvfile,numlines);
% fs;
% hashes;
% alltransitions;
% if (VERBOSE == 1)
% figure;
% plotpgospec(alltransitions);
% end
