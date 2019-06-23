function [k1 k2 k3] = demonstratef1(A,B,C)

%figure('Position',[2054         111        1324         815]);
legs = {};

themol = loadmol('myrtenal');
if nargin > 1
    themol.a = A;
    themol.b = B;
    themol.c = C;
end
themol.visiblewindow = [10000 15000];


themol = updatemolstats(themol);
themol.molname = themol.descriptor;
kit = presentaseriesladder(themol,0,1);
% k1 = kit.k1;
% k2 = kit.k2;
% k3 = kit.k3;

fprintf('A=%3.2f, B=%3.2f, C=%3.2f\n',themol.a,themol.b,themol.c);
fprintf('FOUND k1=%3.2f,k2=%3.2f,k3=%3.2f\n',kit.k1,kit.k2,kit.k3);
fprintf('TRUTH k1=%3.2f,k2=%3.2f,k3=%3.2f\n%s\n',kit.truek1,kit.truek2,kit.truek3,kit.a2bendstring);
fprintf('%s\n',kit.s1FitString);

