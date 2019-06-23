function testf1f2

x = linspace(0,4,100);
f1 = evalf1(x,'ftablefilek0.mat');
f11= evalf1(x,'ftablefilek1.mat');

f0 = evalf0(x);


f01= evalf0(x,'ftablefilek1.mat');

figure;
plot(x,f1,'b');
hold all;
plot(x,f11,'c');

plot(x,f0,'r');
plot(x,f01,'m');

legend('f1 k = 0','f1 k = 1','f0 k = 0','f0 k = 1');