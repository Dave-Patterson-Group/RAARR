function allpairs = runspcat(argsin,toMHz)
    
    if nargin < 1
        argsin = prepare_sp_argsin();
    end
    if nargin < 2
        toMHz = 0;
    end
    filename = makespcatfiles(argsin); % make files for each type of transition
    
    for types = ['a' 'b' 'c']
        filenametouse = [filename types];
        varfilename = [filenametouse '.var'];
        intfilename = [filenametouse '.int'];
        [a b spfitpath] = getspfitpath;
       % cmdline = ['.\spfitstuff\spcat_64bit_zk .\' varfilename ' .\' intfilename]; %uses executables from: http://info.ifpan.edu.pl/~kisiel/asym/asym.htm#64bit
        cmdline = [spfitpath '/spcat_64bit_zk ' varfilename ' ' intfilename]; %uses executables from: http://info.ifpan.edu.pl/~kisiel/asym/asym.htm#64bit

        [status, cmdout] = system(cmdline);

    %    disp(cmdout);

        if not(status == 0)
           error('SPCAT''s FAILED AND LOST HIS NINE LIVES'); 
        end

        catcsvfilename = convertcatfiletocsv(filenametouse);
        strcsvfilename = convertstrfiletocsv(filenametouse);
    end
    
    allpairs = loadlinelistspcat(argsin,filename);
    if toMHz
        allpairs = pairstoMHz(allpairs);
    end
  %  allpairs = addpolarizabilitypairlist(allpairs);
    % allpairs = 'Hello World';
    
end