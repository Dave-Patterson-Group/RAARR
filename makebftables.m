function makebftables() %(A,B,C)



themol = loadmol('test2');
themol.a = 4000;
themol.b = 1540;
themol.c = 1500;
themol = updatemolstats(themol);
kit = presentbseriesladder(themol,0,1);


f1table = kit.f1table; 
f0table = kit.f0table;
save('fbtablefilek0','f1table','f0table');
%now make f2

