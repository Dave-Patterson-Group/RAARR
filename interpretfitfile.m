function fit_info = interpretfitfile(filename)
% goal of this: return desired information from fit file. Namely, line list
% and RMS errors

fitfilename = [filename '.fit'];

f = fopen(fitfilename);
tline = fgetl(f);
byte_loc = 0; % stores location of the start of a line list
while ischar(tline)
    if ismember('EXP.FREQ.', tline)
       byte_loc = ftell(f); %store location
    end
    tline = fgetl(f);
end

fit_info = struct();
fit_info.lines = {};

% go to last line position
fseek(f,byte_loc,'bof');

tline = fgetl(f);

rejection_counter = 0; % count number of rejected lines
fit_diverging = 0;

while isempty(strfind(tline,'NORMALIZED')) && isempty(strfind(tline, 'rejected'))
    if not(isempty(strfind(tline, 'Fit Diverging')))
        fit_diverging = 1;
        break;
    end
    if isempty(strfind(tline, 'NOT USED'))
        C = textscan(tline, '%s %u %u %u %u %u %u %f %f %f %f %f %f %f'); %extract line. last 2 are added by Dave to correct some weird spfit behavior.
        thisline = struct();
        thisline.Jupper = double(C{2});
        thisline.Kaupper = double(C{3});
        thisline.Kcupper = double(C{4});
        thisline.Jlower = double(C{5});
        thisline.Kalower = double(C{6});
        thisline.Kclower = double(C{7});
        thisline.expfreq = C{8};
        thisline.calcfreq = C{9};
        thisline.diff = C{10};
        thisline.hashes = (1e10*cast(thisline.Jupper,'int64')) + (1e8*cast(thisline.Kaupper,'int64')) + ...
        (1e6 *cast(thisline.Kcupper,'int64')) + (1e4 * cast(thisline.Jlower,'int64')) + ...
        (1e2 * cast(thisline.Kalower,'int64')) + cast(thisline.Kclower,'int64');
        thisline.shortdescription = sprintf('%i %i %i => %i %i %i',thisline.Jupper, thisline.Kaupper, thisline.Kcupper, thisline.Jlower, thisline.Kalower, thisline.Kclower); 
        fit_info.lines{end +1} = thisline;
        if length(thisline.Jupper) > 1
            1;
        end
    else
        rejection_counter = rejection_counter + 1;
    end
    tline = fgetl(f);
end

%now to extract RMS
while isempty(strfind(tline,'RMS ERROR'))
   tline = fgetl(f);
end

D = textscan(tline, '%s %s %s %u %s %s %s %s %f %f');
fit_info.num_iterations = double(D{4}); 
if isempty(D{10})
    fit_info.rms_error = D{9};
else
    fit_info.rms_error = D{10};
end
fit_info.rejection_counter = rejection_counter;
fit_info.fit_diverging = fit_diverging;


%now manipulate line with error

fclose(f);

end