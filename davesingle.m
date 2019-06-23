function [k1 k2 k3] = davesingle(A,B,C)

%figure('Position',[2054         111        1324         815]);
legs = {};

themol = loadmol('test2');
themol.a = A;
themol.b = B;
themol.c = C;

themol.visiblewindow = [10000 19000];


themol = updatemolstats(themol);
kit = presentaseriesladder(themol,0,1);
k1 = kit.k1;
k2 = kit.k2;
k3 = kit.k3;

R = (2*B - A - C)/(A - C);
BC = ((A+B)/2) - C;
fprintf('A=%3.2f, B=%3.2f, C=%3.2f\n',A,B,C);
fprintf('FOUND k1=%3.2f,k2=%3.2f,k3=%3.2f\n',k1,k2,k3);
fprintf('TRUTH k1=%3.2f,k2=%3.2f,k3=%3.2f\n%s\n',kit.truek1,kit.truek2,kit.truek3,kit.a2bendstring);
fprintf('%s\n',kit.s1FitString);

