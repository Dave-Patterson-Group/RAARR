function addtextright(tstring,ABOVE)
if (nargin == 1)
    ABOVE = 0;
end
%adds text to the current plot.
if length(tstring) > 0
    a = xlim;
    b = ylim;
    xstart = a(1) + 0.6 * (a(2) - a(1));
    ystart = b(1) + 0.5 * (b(2) - b(1));
    if ABOVE == 1
        ystart = b(1) + 0.8 * (b(2) - b(1));
    end
    if ABOVE == -1
        ystart = b(1) + 0.2 * (b(2) - b(1));
        text(xstart,ystart,tstring,'FontSize',10,'FontWeight','normal','color','g');
    else
        text(xstart,ystart,tstring,'FontSize',10,'FontWeight','normal');
    end

end