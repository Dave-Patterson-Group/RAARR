function lineset = convertspfitlinestocsvlineset(lines)
% takes spfitlines from interpretfitfile.m and the fit object in runspfit.m
% and converts it to a lineset object ready for csv usage (defined through
% makelineforcsvfrompair.m and makelineforcsvfromstate.m)

lineset = {};

for i = 1:length(lines)
   thisline = struct();
   thisline.skip = 0;
   thisline.error = 0;
   thisline.upperstate = makestate(lines{i}.Jupper, lines{i}.Kaupper, lines{i}.Kcupper);
   thisline.lowerstate = makestate(lines{i}.Jlower, lines{i}.Kalower, lines{i}.Kclower);
   thisline.freq = lines{i}.expfreq;
   thisline.shortdescription = sprintf('%i %i %i => %i %i %i',lines{i}.Jupper, lines{i}.Kaupper, lines{i}.Kcupper, lines{i}.Jlower, lines{i}.Kalower, lines{i}.Kclower);
   lineset{end + 1} = thisline;
end

end