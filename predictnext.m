function coords = predictnext(fullsquare,whichcorner)
coords.islegal = 1;
coords.isrecommended = 0;
coords.inrange = 0;
coords.fdist = 1e10;
coords.whichcorner = whichcorner;
energiesknown = abs(fullsquare.energies(:,1) .* fullsquare.energies(:,2));
energiesknown = find(energiesknown > 1e-10);
toprow = max(energiesknown);
bottomrow = min(energiesknown);
switch whichcorner
    case 'ur'
        r1 = toprow;
        c1 = 4;
        c2 = 2;
    case 'ul'
        r1 = toprow;
        c1 = 1;
        c2 = 3;
    case 'dr'
        r1 = bottomrow - 1;
        c1 = 4;
        c2 = 3;
    case 'dl'
        r1 = bottomrow - 1;
        c1 = 1;
        c2 = 2;
end
r2 = r1;
% error('whichcorner not yet implemented');

if r1 == 0
    1;
end
if (r1 == 0) || (fullsquare.fgrid(r1,c1) ~=  0) || (fullsquare.fgrid(r2,c2) ~= 0)
    coords.islegal = 0;
    coords.isrecommended = 0;
    return
end

nextcolumn = c1;
nextrow = r1;
nextline = fullsquare.nextline;

correction = fullsquare.templatenorm(nextline) * fullsquare.f1;
%uses a polynomial fit to extend the series f.
%this thing explodes when extending series of length one.  In this mode, if
%tightmode is turned on, it uses fs(1) + bplusc as a first guess
%if nothing is found, returns [[] []];
newseriesset = {};

switch nextcolumn
    case 1
        s = fullsquare.column1;
    case 2
        s = fullsquare.column2;
    case 3
        s = fullsquare.column3;
    case 4
        s = fullsquare.column4;
end
upordown = -1;
if (nextrow <= length(s.fs)) && (nextrow > 0) && (s.fs(nextrow) ~= 0)
    1;
    error('looking for a line I already have!');
end
if (nextrow > 1) && (s.fs(nextrow-1) ~= 0)
    upordown = 1;
end
if (nextrow < length(s.fs)) && (s.fs(nextrow+1) ~= 0)
    upordown = 0;
end

%f_allowed = s.tolerance; 

if ((c1 == 4)  && (c2 == 2)) || ((c1 == 1)  && (c2 == 3)) 
    energydiff = fullsquare.energies(r1,1) - fullsquare.energies(r1,2);
    if (fullsquare.energies(r1,1) == 0) || (fullsquare.energies(r1,2) == 0)
        1;
        error('energies below are not known');
    end
end
if ((c1 == 4)  && (c2 == 3)) || ((c1 == 1)  && (c2 == 2)) 
    energydiff = fullsquare.energies(r1+1,2) - fullsquare.energies(r1+1,1);
    if (fullsquare.energies(r1+1,1) == 0) || (fullsquare.energies(r1+1,2) == 0)
        1;
        error('energies above are not known');
    end
end
if c1 == 1
    energydiff = -1 * energydiff;
end


if upordown == -1  %empty series, use column 1 or 3
    if fullsquare.column1.fs(nextrow) ~= 0 
        predictf = fullsquare.column1.fs(nextrow);  %theres a f1f4 tweak here possible..
    else
        predictf = fullsquare.column4.fs(nextrow); 
    end
    if (nextcolumn == 2) || (nextcolumn == 3)
        fthresh = fullsquare.abtolerance;
    else
        fthresh = fullsquare.aatolerance;
    end
else
    n = length(s.realfs);
    

    if n == 1
        if upordown == 1
            predictf = s.realfs(1) + fullsquare.bpluscguess;  %more tweaks here cowcow
        else
            predictf = s.realfs(1) - fullsquare.bpluscguess;
        end
        if (nextcolumn == 2) || (nextcolumn == 3)
            fthresh = fullsquare.bpluscerror * 4;
        else
            fthresh = fullsquare.bpluscerror * 2;
        end
    else
%         x = 1:n;
%         y = s.realfs;
%         polydegree = min(2,n-1);
%         [p] = polyfit(x,y,polydegree);
    %    fthresh = f_allowed(n);
        if upordown == 1
            predictf = s.nextf;
            fthresh = s.nextfspread;
       %     predictf2 = s.nextf;
        else
            
            predictf = s.prevf;
            fthresh = s.prevfspread;
%             fthresh = f_allowed(n);
%         %    predictf2 = s.prevf;
        end
    end
end
%if n == 0  %first line in a series..
if fullsquare.usecorrection == 1
    predictf = predictf + correction;
end
predictf2 = predictf - energydiff;
minf = predictf - fthresh;
maxf = predictf + fthresh;

meanf = mean([predictf predictf2]);
if (predictf < fullsquare.frecommendedmax) && (predictf > fullsquare.frecommendedmin) && ...
    (predictf2 < fullsquare.frecommendedmax) && (predictf2 > fullsquare.frecommendedmin) 
    coords.inrange = 1;
    coords.isrecommended = 1;  %perhaps rank based on distance from mean?
    meanrange = mean([fullsquare.frecommendedmax fullsquare.frecommendedmin]);
    coords.fdist = abs(meanf - meanrange);
end
coords.r1 = r1;
coords.r2 = r2;
coords.c1 = c1;
coords.c2 = c2;
coords.f1 = predictf;
coords.f2 = predictf2;
coords.energydiff = energydiff;
coords.minf = minf;
coords.maxf = maxf;
