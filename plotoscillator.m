function plotoscillator
[t, x, v] =  dampedoscillator(-1,0.2);
[t, x2, v2] =  dampedoscillator(-1,1.6);

thalf = interp1(x,t,-0.5);
t = t/thalf;
x = x+1;
x2 = x2+1;
%figure;
plot(t,x,'b--','LineWidth',2);
hold all;
plot(t,x2,'r--','LineWidth',2);
%plot(t,v,'r');

function [tvals xvals vvals] = dampedoscillator(x0,v0)

omega = 1;
damping = 2.0;
dt = .001;

x = x0;
v = v0;
nump = 16000;
xvals = zeros(1,nump);
vvals = xvals;
tvals = dt*(1:nump);
for i = 1:nump
    x = x + (v * dt);
    v = v + ((-damping * v)*dt) - (x*dt);
    xvals(i) = x;
    vvals(i) = v;
end
1;
