function p = stickplot(xvals,yvals,linespec1, linespec2)
%makes a spectum-ish plot.  typical use is stickplot(freqs,amps,'q');  this
%uses native 'hold all' coloring
xv = [];
yv = [];
for (i = 1:length(xvals))
    xv((3*i) - 2) = xvals(i);
    xv((3*i) - 1) = xvals(i);   
    xv(3*i) = xvals(i);
    yv((3*i)-2) = 0;
    yv((3*i)-1) = yvals(i);
    yv(3*i) = 0;
end

if (nargin == 3) && (strcmp(linespec1,'q') == 0)
    p = plot(xv,yv,linespec1);
elseif (nargin == 4)
    p = plot(xv,yv,linespec1,linespec2);
else
    p = plot(xv,yv);
end

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


end

