function newfit = quickspfit(lines,ABC,useCD)

if (nargin == 1) && isstruct(lines)
    trial = lines;
    lines = trial.lineset;
    ABC = trial.ABC;
end
if nargin < 3
    useCD = 0;
end
if (length(ABC) > 0) && (useCD == 0)
    1;
end

testingcsvname = sprintf('%s/fittesting%d.csv',getspfitpath,floor(rand() * 5));
f = fopen(testingcsvname,'w');
for i = 1:length(lines)
    fassignline(f,lines{i});
end
fclose(f);

try
    newfit = dospfit(testingcsvname,ABC,useCD);
catch
    
    fprintf('dospfit crashed');
    lines
    lines{1}
    pause(5.0);
    newfit = dospfit(testingcsvname,ABC);
end
jupper = extractfieldsfromcellarray(lines,{'Jupper'});
jupper = jupper.Jupper;
[shortstring,fulldescription] = stringfromfit(newfit);
switch useCD
    case 0
        newfit.numparams = 3;
    case 1
        newfit.numparams = 8;
end
if isfield(newfit.info.params,'DJ')
    newfit.ABCxxxxx = [newfit.info.params.a newfit.info.params.b newfit.info.params.c ...
        newfit.info.params.DJ newfit.info.params.DJK newfit.info.params.DK newfit.info.params.deltaJ newfit.info.params.deltaK];
else
    newfit.ABCxxxxx = [newfit.info.params.a newfit.info.params.b newfit.info.params.c 0 0 0 0 0];
end
newfit.A = newfit.info.params.a;
newfit.B = newfit.info.params.b;
newfit.C = newfit.info.params.c;
newfit.lines = lines;
newfit.useCD = useCD;
newfit.maxj = max(jupper);
newfit.minj = min(jupper)-1;
newfit.shortstring = shortstring;
newfit.fulldescription = fulldescription;
newfit.ABC = [newfit.info.params.a newfit.info.params.b newfit.info.params.c]; 
newfit.molstats = molstatsfromwhatever(newfit.ABCxxxxx);

function newfit = dospfit(csvname,ABC,useCD)
argsin = prepare_spfit_argsin;
argsin.filename = sprintf('%s/tempspfitfilemany%d',getspfitpath,floor(rand() * 5));

argsin.a = ABC(1);
argsin.b = ABC(2);
argsin.c = ABC(3);  %figure out useCD stuff
argsin.useCD = useCD;
if length(ABC) == 8
    argsin.DJ = ABC(4);
    argsin.DJK = ABC(5);
    argsin.DK = ABC(6);
    argsin.deltaJ = ABC(7);
    argsin.deltaK = ABC(8);
else
    argsin.DJ = 0;
    argsin.DJK = 0;
    argsin.DK = 0;
    argsin.deltaJ = 0;
    argsin.deltaK = 0;
end
    
if argsin.useCD == 1
   % fprintf('trying fit with CD');
    
end
% if length(lines) >= 60
%     argsin.useCD = 1;  %turn it off for now
% else
%     argsin.ucsCD = 0;
% end

[~,~,~,newfit] = runspfit(argsin,csvname,0);

function fassignline(f,thisline)
        thisfreq = thisline.expfreq;
        thiserror = 0; %I think this is ok? 
        upper_J = thisline.Jupper;
        upper_Ka = thisline.Kaupper;
        upper_Kc = thisline.Kcupper;
        lower_J = thisline.Jlower;
        lower_Ka = thisline.Kalower;
        lower_Kc = thisline.Kclower;
        fprintf(f, '%i,%i,%i,%i,%i,%i,%f,%f\n', upper_J, upper_Ka, upper_Kc, lower_J, lower_Ka, lower_Kc, thisfreq, thiserror); 

