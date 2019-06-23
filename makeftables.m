function makeftables() %(A,B,C)



themol = loadmol('test2');
themol.a = 4000;
themol.b = 2000;
themol.c = 1600;
themol = updatemolstats(themol);
kit = presentaseriesladder(themol,0,1);


f1table = kit.f1table; 
f0table = kit.f0table;
save('ftablefilek0','f1table','f0table');
%now make f2

themol.a = 5500;
themol.b = 1650;
themol.c = 1450;
themol = updatemolstats(themol);
kit = presentaseriesladder(themol,1,1);


f1table = kit.f1table; 
f0table = kit.f0table;
save('ftablefilek1','f1table','f0table');