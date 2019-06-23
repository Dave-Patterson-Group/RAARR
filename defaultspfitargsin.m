function argsin = defaultspfitargsin

    argsin = 0;
    clear('argsin');
    argsin.filename = [getspfitpath '\tempspfitfilemany'];
    argsin.molname = 'Unknown Molecule';
    argsin.a = 8000; % in MHz
    argsin.b = 5000; % in MHz
    argsin.c = 3000; % in MHz
    argsin.aerror = 1000;
    argsin.berror = 500;
    argsin.cerror = 200;
    argsin.useCD = 0; %use centrifugal distortion or not
    argsin.DJ = 0;
    argsin.DJK = 0;
    argsin.DK = 0;
    argsin.deltaJ = 0;
    argsin.deltaK = 0;
    argsin.default = 0;
    argsin.nline = 4; %number of lines (will be overwritten)
    argsin.ntir = 20; %number of iterations
    argsin.nxpar = 0; %number of lines to exclude from end of list when fitting special lines (usually 0, see documentation)
    argsin.thresh = 0; %initial Marquardt-Levenburg parameter
    argsin.errtst = 1e12; %maximum ((obs - calc)/error)
    argsin.frac = 1; %fractional importance of variance, see documentation
    argsin.cal = 1; %scaling for IR frequencies

end

