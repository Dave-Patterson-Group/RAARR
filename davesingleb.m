function [k1 k2 k3] = davesingleb(A,B,C)

%figure('Position',[2054         111        1324         815]);
legs = {};

themol = loadmol('test2');
themol.a = A;
themol.b = B;
themol.c = C;

themol.visiblewindow = [10000 19000];

presentaseriesladder(themol,1,0)

