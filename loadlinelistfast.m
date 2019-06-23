function [ fs intens hs alltransitions] = loadlinelistfast(filename,howmany,molstats)
if (nargin < 1)
    filename = 'tempfile4.csv';
end
if (nargin < 2)
    howmany = -1;
end
f = fopen(filename);
fgetl(f);
fgetl(f);
%fgetl(f)
%C = textscan(f,'%s %s %d');
%C = textscan(f,'%s %s %d %s %d %s %d %s %d %f %f %f %f %s %s %f %c %s %c %s %s %d %d %d %c %s %d %d %d');
%                                                                  18
%                                                                                    24
%C = textscan(f,'%s %s %d %s %d %s %d %s %d %f %f %f %f %f %f %f %s %s %d %d %d %c %s %d %d %d');
%the above version works on non-mixtures
C = textscan(f,'%s %s %d %s %d %s %d %s %d %f %f %f %f %f %f %f %s %s %s %d %d %d %c %s %d %d %d');
fclose(f);

species = C{1};
freq = C{10};
intensity = C{11};
Eupper = C{12};
Elower = C{13};

Avalue = C{15};

Jupper = C{20};
Kaupper = C{21};
Kcupper = C{22};

Jlower = C{25};
Kalower = C{26};
Kclower = C{27};
% Jlower = C{24};
% Kalower = C{25};
% Kclower = C{26};


numtrans = length(Kclower);
Jupper = Jupper(1:numtrans);
Kaupper = Kaupper(1:numtrans);
Kcupper = Kcupper(1:numtrans);
Jlower = Jlower(1:numtrans);
Kalower = Kalower(1:numtrans);
Avalue = Avalue(1:numtrans);
if (howmany == -1)
    intensethresh = 0;
else
    sortintense = sort(intensity);
    intensethresh = sortintense(end-howmany);
end
numrecorded = 0;
fs = 1:numrecorded;
intens = fs;
if (isfield(molstats,'conformer') == 0)
    molstats.conformer = 1;
end
hashes = molstats.conformer * 1e13 + (1e10*cast(Jupper,'int64')) + (1e8*cast(Kaupper,'int64')) + ...
    (1e6 *cast(Kcupper,'int64')) + (1e4 * cast(Jlower,'int64')) + ...
    (1e2 * cast(Kalower,'int64')) + cast(Kclower,'int64');
hs = hashes;     
h = waitbar(0,'');
for (i = 1:numtrans)
    if mod(i, 1000) == 0 
        waitbar(i/numtrans, h, sprintf('Making %i of %i transitions especially for you, Dave',i, numtrans))
    end
    if (intensity(i) >= intensethresh)
        speciesname = species(i);
        spec = speciesname{1};
        t = spec(end);
        
        thetrans.type = t;

        if (t == 'a')
            hashes(i) = hashes(i) + 1e12;
        end
        if (t == 'b')
            hashes(i) = hashes(i) + 2e12;
         end
        if (t == 'c')
            hashes(i) = hashes(i) + 3e12;
        end
        thetrans.hashtag = hashes(i);
        %conformer = spec(3);
        %conf = sscanf(conformer,'%d');
        %thetrans.conformer = conf;
        %thetrans.type = 'a';  %obvi need to fix this
        thetrans.molname = molstats.molname;
        thetrans.conformer = molstats.conformer;  %prob leave this one
        thetrans.freq = freq(i);
        thetrans.intensity = intensity(i);
        thetrans.Eupper = Eupper(i);
        thetrans.Elower = Elower(i);
        
        thetrans.Jupper = double(Jupper(i));
        thetrans.Kaupper = double(Kaupper(i));
        thetrans.Kcupper = double(Kcupper(i));
        
        thetrans.Jlower = double(Jlower(i));
        thetrans.Kalower = double(Kalower(i));
        thetrans.Kclower = double(Kclower(i));
        thetrans.Avalue = Avalue(i);
        thetrans.labelstring = sprintf('%i %i %i=>%i %i %i %s type',thetrans.Jupper, thetrans.Kaupper, thetrans.Kcupper, thetrans.Jlower, thetrans.Kalower, thetrans.Kclower, thetrans.type);
        
        if (isfield(molstats,'kalimit') == 0) || ((thetrans.Kaupper <= molstats.kalimit) && (thetrans.Kaupper <= molstats.kalimit))
            numrecorded = numrecorded+1;
            fs(numrecorded) = freq(i);
            hs(numrecorded) = hashes(i);
            intens(numrecorded) = intensity(i);
            alltransitions(numrecorded) = thetrans;
        end
    end
end
hs = hs(1:numrecorded);
fs = fs(1:numrecorded);
intens = intens(1:numrecorded);

delete(h);
