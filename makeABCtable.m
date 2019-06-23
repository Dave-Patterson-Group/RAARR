function [k1 k2 k3] = makeABCtable(A,B,C)

%figure('Position',[2054         111        1324         815]);
legs = {};

M = [];
for (i = 1:35)
    try
        themol = loadmol('test1');
        themol.a = 2500 + rand() * 8000;
        themol.b = 1780;
        themol.c = 1320;
%         themol.c = themol.c + rand() * 500;




        themol = updatemolstats(themol);
        kit = presentaseriesladder(themol,0,0);
        k1 = kit.k1
        k2 = kit.k2
        k3 = kit.k3
%         R = (2*B - A - C)/(A - C);
%         BC = ((A+B)/2) - C;
%         fprintf('Rays is %3.3f, BCterm is %3.4f\n\n',R,BC);
%         fprintf('k1 = %3.1f, 2C = %3.1f\n',kit.k1,2*C);
%         fprintf('k2/k3 = %3.2f, (B-C)/1.925 = %3.1f\n',kit.k2/kit.k3,(B-C)/1.925);
%         fprintf('k2 = %3.2f, A*kappa = %3.1f\n',kit.k2,2*A*(1+R)^2);

        M(end+1,1) = themol.a;
        M(end,2) = themol.b;
        M(end,3) = themol.c;
        M(end,4) = k1;
        M(end,5) = k2;
        M(end,6) = k3;
    end
end
dlmwrite('ABCk1k2k3.csv',M,'precision','%.6f');
