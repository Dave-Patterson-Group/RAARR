function makemyrtenal

ts = settingsfromtightness(1);
ts.maxcomponents = 1;
ts.numjguess = 2;
ts.ladderSearchtimes = {[20, 1e-30],[100,1e-20],[500,1e-8],[2000,100]};
ts.maxka = 1;
        kit = autofitladder('Molecules/myrtenal_1d/myrtenal.csv',1,11,ts);
        makepaperfigure(kit);
        fprintf('%s CONVERGED in %3.1f seconds with %d upvotes %d flat\n',kit.molname,kit.fitduration,kit.numvotes,kit.totalflatsquares);



