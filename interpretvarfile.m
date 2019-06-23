function parameters = interpretvarfile(varfilename)

%varfilename = [filename '.var'];

f = fopen([varfilename '.var']);

%first extract number of parameters. Skip first line
fgetl(f);

%now extract very first number
C = textscan(f, '%s');
numlines = str2num(C{1}{1}); 

%move back to the right spot, since file pointer is now at eof (end of
%file)
fseek(f,0,'bof'); %goes to beginning of file
fgetl(f); % skip title line
fgetl(f); % skip line 2
fgetl(f); % skip line 3

D = textscan(f, '%f %f %f', numlines);

paramID = D{1}; % parameter IDs are first
paramvalues = D{2}; % then the values
paramerrors = D{3}; % then errors

% now find all appropiate parameters
parameters = struct();
parameters.unknownparams = [];

for i = 1:numlines
    thisparam = paramID(i);
    thisvalue = paramvalues(i);
    thiserror = paramerrors(i);
    if thisparam == 10000
      parameters.a = thisvalue;
      parameters.aerror = thiserror;
    elseif thisparam == 20000
      parameters.b = thisvalue;
      parameters.berror = thiserror;
    elseif thisparam == 30000
        parameters.c = thisvalue;
        parameters.cerror = thiserror;
    elseif thisparam == 200
        parameters.DJ = -thisvalue;
        parameters.DJerror = thiserror;
    elseif thisparam == 1100
        parameters.DJK = -thisvalue;
        parameters.DJKerror = thiserror;
    elseif thisparam == 2000
        parameters.DK = -thisvalue;
        parameters.DKerror = thiserror;
    elseif thisparam == 40100
        parameters.deltaJ = -thisvalue;
        parameters.deltaJerror = thiserror;
    elseif thisparam == 41000
        parameters.deltaK = -thisvalue;
        parameters.deltaKerror = thiserror;
    else
        thisunknownparam = struct();
        thisunknownparam.value = thisvalue;
        thisunknownparam.error = thiserror;
        thisunknownparam.ID = thisparam;
        parameters.unknownparams(end + 1) = thisunknownparam;
    end
end



fclose(f);

end