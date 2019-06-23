function clearspfitpath()

%returns the name of a safe directory to work in.  Keeps spfit files off
%dropbox, and eventually lets multiple matlab threads coexist
[path location cmdpath] = getspfitpath;

a = dir(path);


for i = 1:length(a)
    thisfile = a(i);
    fullname = [thisfile.folder '\' thisfile.name];
    if (contains(fullname(end-4:end),'exe') == 0) && (thisfile.isdir == 0)
        disp(fullname);
        delete(fullname);
    end
end
