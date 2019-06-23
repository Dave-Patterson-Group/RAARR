function s = updateplainseries(s)
    s = updateseries(s);
    s.numlines = length(s.realfs);
    if isfield(s,'tried') == 0
        s.tried = (s.fs > 0);
        s.lineorder (s.fs > 0) = 1;
        s.tolerance = s.ts.atolerance;
        s.fvsj = zeros(1,20);
    end
    s.updist = abs(s.nextf - s.midf);
    s.downdist = abs(s.prevf - s.midf);
   % s.isoutlawed = 0;
    s.upoutlawed = 0;
    s.downoutlawed = 0;
    s.closedout = 0;
    s.goingup = 0;
    s.goingdown = 0;
    if (s.tried(end) > 0) || (s.nextf > (s.midf + (s.frange/2)))  || (s.tried(s.lasti+1) > 0) 
        s.upoutlawed = 1;
        s.goingdown = 1;
    end
    if (s.tried(1) > 0) || (s.prevf < (s.midf - (s.frange/2))) || (s.tried(s.firsti-1) > 0) 
        s.downoutlawed = 1;
        s.goingup = 1;
    end    
    if (s.upoutlawed && s.downoutlawed)
        s.closedout = 1;
    end
    if (s.goingup == 0) && (s.goingdown == 0)
        if s.updist < s.downdist
            s.goingup = 1;
        else
            s.goingdown = 1;
        end
    end
    if s.goingup
        s.nextrow = s.lasti+1;
        s.predictf = s.nextf;
    else
        s.nextrow = s.firsti - 1;
        s.predictf = s.prevf;
    end
    s.jguess = round((s.realfs(1) / (s.realfs(2) - s.realfs(1))) - 0.1);
    s.inttest = (s.realfs(1) / (s.realfs(2) - s.realfs(1))) - s.jguess;
    if abs(s.inttest) > s.ts.inttestlimit
        s.outlawed = 1; 
    end
    s.fvsj(s.jguess-1:s.jguess+s.numlines-2) = s.realfs;
    s.fthresh = s.tolerance(s.numlines+1);
    s.nextmaxf = s.predictf + s.fthresh;
    s.nextminf = s.predictf - s.fthresh;
    s.pvalprefactor = 1;
    for h = s.realhs
        linecount = countfrommcounttool(s.counttool,h);
        s.pvalprefactor = s.pvalprefactor * (linecount * 1.5);
    end
    s.pval = s.pval * s.pvalprefactor;
%     1;
%     s.netp = s.netp * s.predicterrs(n+1) ./ s.tolerance(n+1);
    s.supertight = 1;
    s.superchar = '!';
    
    for n = 2:(length(s.realfs)-1)
        
        if s.predicterrs(n+1)  > (s.tolerance(n-1) / 2)
            s.supertight = 0;
            s.superchar = '&';
        end
    end
    s.fulldescriptor = sprintf('%s %d lines, p = %3.1e%c',s.originstring,s.numlines,s.pval,s.superchar); 