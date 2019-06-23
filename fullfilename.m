function fullname = fullfilename(localfilename)
a = dir(localfilename);
if length(a) == 0
    error('file %s is not found',localfilename);
end
fullname = [a.folder '\' a.name];

