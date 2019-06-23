function [spfitpath location spfitcmdpath] = getspfitpath(uselocal)
if nargin == 0
    uselocal = 1;
end
%returns the name of a safe directory to work in.  Keeps spfit files off
%dropbox, and eventually lets multiple matlab threads coexist
%to set up on a new computer: copy the contents of the folder ./local_files
%into a local (non-dropbox) directory, such as
%'C:\Users\PattersonGroup\spcatfiles'.

%specifically, your new directory should contain:
%pgo.exe
%spcat_64bit_zk.eke
%spfit_64bit_zk.eke

%Then edit the 3 lists below, to add
%your new location The

paths{1} = 'C:\Users\Dave\squarefits';  %home computer
paths{end+1} = 'C:\Users\PattersonGroup\spcatfiles'; %lab computer by printer
paths{end+1} = 'C:\Users\PattersonGroupSpec\squarefits'; %lab computer by printer
paths{end+1} = 'C:\Users\PattersonGroup\spcat'; %lab computer by spectrometer
paths{end+1} = 'C:\Users\lia.LIA-SURFACE\spfitspcat'; % lia's laptop
paths{end+1} = 'C:\SPFIT'; % 2nd lab computer by printer
paths{end+1} = 'C:\Users\davep\spfit';

locations{1} = 'remoteinstall';
locations{end+1} = 'home';
locations{end+1} = 'labprint';
locations{end+1} = 'labcabinets';
locations{end+1} = 'labinstrument';
locations{end+1} = 'liaslaptop';
locations{end+1} = 'labprint2';
locations{end+1} = 'daveasus';

cmdpaths{1} = '.\local_files';
cmdpaths{end+1} = 'C:\Users\Dave\squarefits';  %home computer
cmdpaths{end+1} = 'C:\Users\PattersonGroup\spcatfiles'; %lab computer by printer
cmdpaths{end+1} = 'C:\Users\PattersonGroupSpec\squarefits'; %lab computer by printer
cmdpaths{end+1} = 'C:\Users\PattersonGroup\spcat'; %lab computer by spectrometer
cmdpaths{end+1} = 'C:\Users\lia.LIA-SURFACE\spfitspcat'; % lia's laptop
cmdpaths{end+1} = 'C:\SPFIT'; % 2nd lab computer by printer
cmdpaths{end+1} = 'C:\Users\davep\spfit';


spfitpath = 'none';
spfitcmdpath = 'none';


    for i = 1:length(paths)
        if isfolder(paths{i})
            spfitpath = paths{i};
             location = locations{i};
             spfitcmdpath = cmdpaths{i};
            break;
        end
    end
   

if strcmp(spfitpath,'none') || uselocal == 1
    location = 'remote install';
    spfitcmdpath = [pwd '\local_files'];
    spfitpath = [pwd '\local_files'];
end
%     
%     fprintf ('WARNING: No hardware spfit path found');
% end
