function argsout = prepare_spfit_argsin()

argsout.filename = '.\spfitstuff\tempspfitfile';
argsout.molname = 'Unknown Molecule';
argsout.a = 5000; % in MHz
argsout.b = 3000; % in MHz
argsout.c = 2000; % in MHz
argsout.aerror = 1000;
argsout.berror = 1000;
argsout.cerror = 1000;
argsout.useCD = 0; %use centrifugal distortion or not
argsout.DJ = 0.000;
argsout.DJK = 0.00;
argsout.DK = 0.000;
argsout.deltaJ = 0.0000;
argsout.deltaK = 0.000;
argsout.default = 0;
argsout.nline = 4; %number of lines (will be overwritten)
argsout.ntir = 20; %number of iterations
argsout.nxpar = 0; %number of lines to exclude from end of list when fitting special lines (usually 0, see documentation)
argsout.thresh = 0.01; %initial Marquardt-Levenburg parameter
argsout.errtst = 1e12; %maximum ((obs - calc)/error)
argsout.frac = 1; %fractional importance of variance, see documentation
argsout.cal = 1; %scaling for IR frequencies

end