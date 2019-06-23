function p = marktime(tt,stylestring,lite)
hold all;
a = ylim;
if (nargin >= 3) && (lite == 1)
    a(1) = a(2) - (a(2) - a(1))/10;
end
if (nargin >= 3) && (lite == 2)
    a(1) = -a(2)/10;
    a(2) = 0;
   % a(1) = a(2) - (a(2) - a(1))/10;
end
if (nargin < 2)
    p = plot([tt tt],a);
else
    p = plot([tt tt],a,stylestring);
end
    
end
