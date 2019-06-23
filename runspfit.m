function [filename, argsout, new_params, spfit_info] = runspfit(argsin,csvfilename,VERBOSE)
global SPFITCOUNT
if length(SPFITCOUNT) == 0
    SPFITCOUNT = 0;
end
%runs spfit, guesses for initial parameters should be in argsin
%csvfile contains assignments in format,
%(Jupper,Kaupper,Kcupper,Jlower,Kalower,Kclower,freq (MHz), error(MHz)
% outputs include a filename without extension, argsout that can be used
% with another spfit run and a list of parameters in new_params

if nargin < 1
   argsin = prepare_spfit_argsin; %prepares argsin for par file
   csvfilename = [getspfitpath() '/test2.csv']; %test runs a working version, test2 is for messing around.
   VERBOSE = 1;
end

[linfilename, numoflines] = convertcsvtolin(csvfilename); %prepares lin file
argsin.nline = numoflines;

%filename = sprintf('argsin.filename%d',floor(rand() * 200));
%filename = argsin.filename;
[parfilename filename] = makeparfile(argsin);
try
    [a b cmdpth] = getspfitpath;
    cmdline = [cmdpth '/spfit_64bit_zk.exe ' parfilename ' ' linfilename];
    SPFITCOUNT = SPFITCOUNT + 1;
    [status, cmdout] = system(cmdline);

    if VERBOSE
        disp(cmdout);
    end

    if not(status == 0)
        argsin
        cmdline
       error('SPFIT''s FAILED AND IS LOOKING SQUIDDY'); 
    end
catch
    pause(25 + 5* rand());
    cmdline = [getspfitpath '/spfit_64bit_zk.exe ' parfilename ' ' linfilename];
    [status, cmdout] = system(cmdline);

    if VERBOSE
        disp(cmdout);
    end
end
new_params = interpretvarfile(filename);

argsout = argsin;

argsout.a = new_params.a;
argsout.b = new_params.b;
argsout.c = new_params.c;

if argsout.useCD
    argsout.DJ = new_params.DJ;
    argsout.DJK = new_params.DJK;
    argsout.DK = new_params.DK;
    argsout.deltaJ = new_params.deltaJ;
    argsout.deltaK = new_params.deltaK;
end

% display info in nice table
parameter_names = {'A' 'B' 'C'};
old_values = [argsin.a argsin.b argsin.c];
new_values = [argsout.a argsout.b argsout.c];
errors = [new_params.aerror new_params.berror new_params.cerror];

if argsin.useCD
   CD_names = {'DK' 'DJK' 'DJ' 'deltaK' 'deltaJ'};
   CD_old_values = [argsin.DK argsin.DJK argsin.DJ argsin.deltaK argsin.deltaJ];
   CD_new_values = [argsout.DK argsout.DJK argsout.DJ argsout.deltaK argsout.deltaJ];
   CD_errors = [new_params.DKerror new_params.DJKerror new_params.DJerror new_params.deltaKerror new_params.deltaJerror];
   parameter_names = horzcat(parameter_names, CD_names);
   old_values = horzcat(old_values, CD_old_values);
   new_values = horzcat(new_values, CD_new_values);
   errors = horzcat(errors, CD_errors);
end

format long;

parameter_names = transpose(parameter_names);
old_values = transpose(old_values);
new_values = transpose(new_values);
errors = transpose(errors);

t = table(parameter_names, old_values, new_values, errors);
if VERBOSE
    t(:,:)
end

% store fit files into strings
spfit_info = struct();
spfit_info.bak = fileread([filename '.bak']);
spfit_info.par = fileread([filename '.par']);
spfit_info.fit = fileread([filename '.fit']);
spfit_info.var = fileread([filename '.var']);

%obtain info from fit file and display
%try
    fit_info = interpretfitfile(filename); 
    if VERBOSE
        fprintf('Number of Iterations: %i, RMS Error: %f\nNumber of Rejected Lines: %i out of %i, Fit Diverging: %i\n', fit_info.num_iterations, fit_info.rms_error, fit_info.rejection_counter, numoflines, fit_info.fit_diverging);
    end
    %cowcow break here, go into details on fit_info.
    lineinfo = fit_info.lines;

    output = extractfieldsfromcellarray(lineinfo, {'shortdescription','expfreq','calcfreq','diff'}); % also in function displayspfitlines

    transition = transpose(output.shortdescription);
    EXP_FREQ = transpose(output.expfreq);
    CALC_FREQ = transpose(output.calcfreq);
    difference = transpose(output.diff);

    t2 = table(transition, EXP_FREQ, CALC_FREQ, difference);
    if VERBOSE
        t2(:,:)
    end

    fit_info.myrms_error = sum(output.diff.^2)/length(output.diff);
% catch
%     output
%     lineinfo
%     fprintf('Number of Iterations: %i, RMS Error: %f\nNumber of Rejected Lines: %i out of %i, Fit Diverging: %i\n', fit_info.num_iterations, fit_info.rms_error, fit_info.rejection_counter, numoflines, fit_info.fit_diverging);
% 
%     output.diff
%     1;
% end
    
fit_info.truerms_error = sqrt(sum(output.diff.^2)/length(output.diff));
 
fit_info.params = new_params;
fit_info.argsin = argsin;
fit_info.argsout = argsout;
maxj = 0;
minj = 1000;
maxka = 0;
minka = 1000;
for i = 1:length(fit_info.lines)
    l = fit_info.lines{i};
    if l.Jupper > maxj
        maxj = l.Jupper;
    end
    if l.Jlower < minj
        minj = l.Jlower;
    end
    if l.Kaupper > maxka
        maxka = l.Kaupper;
    end
    if l.Kalower < minka
        minka = l.Kalower;
    end
end
fit_info.maxj = maxj;
fit_info.minj = minj;
fit_info.maxka = maxka;
fit_info.minka = minka;
% if islegalABC(fit_info.params) == 0
%     fit_info.truerms_error = 1e10;
% end
spfit_info.info = fit_info;



function a = islegalABC(params)

a = 1;
if (params.a < 0) || (params.b < 0) || (params.c < 0) || (params.b > params.a) || (params.c > params.b)
    a = 0;
end