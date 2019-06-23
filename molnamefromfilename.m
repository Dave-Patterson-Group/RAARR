function [molname,directoryname] = molnamefromfilename(filename)
lastslash = find(filename == '/',1,'last') + 1;
lastdot = find(filename == '.',1,'last') - 1;
molname = filename(lastslash:lastdot);
directoryname = filename(1:lastslash-1);