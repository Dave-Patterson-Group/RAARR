function [spfitpath location spfitcmdpath] = getspfitpath()

%returns the name of a safe directory to work in.  Keeps spfit files off
%dropbox, and eventually lets multiple matlab threads coexist

paths{1} = 'C:\Users\Dave\squarefits';  %home computer
paths{2} = 'C:\Users\PattersonGroup\spcatfiles'; %lab computer by printer
paths{3} = 'C:\Users\PattersonGroupSpec\squarefits'; %lab computer by printer
paths{4} = 'C:\Users\PattersonGroup\spcat'; %lab computer by spectrometer

locations{1} = 'home';
locations{2} = 'labprint';
locations{3} = 'labcabinets';
locations{4} = 'labinstrument';

cmdpaths{1} = 'C:\Users\Dave\squarefits';  %home computer
cmdpaths{2} = 'C:\Users\PattersonGroup\spcatfiles'; %lab computer by printer
cmdpaths{3} = 'C:\Users\PattersonGroupSpec\squarefits'; %lab computer by printer
cmdpaths{4} = 'C:\Users\PattersonGroup\spcat'; %lab computer by spectrometer

spfitpath = 'none';
for i = 1:length(paths)
    if isfolder(paths{i})
        spfitpath = paths{i};
        break;
    end
end
location = locations{i};
spfitcmdpath = cmdpaths{i};
if strcmp(spfitpath,'none')
    error ('No hardware spfit path found');
end
