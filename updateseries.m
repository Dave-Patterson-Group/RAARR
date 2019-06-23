function s = updateseries(s)

s = seriesbasics(s);


s.firsti = find(s.fs > 0,1,'first');
s.lasti = find(s.fs > 0,1,'last');
s.realfs = s.fs(find(s.fs>0));
s.realhs = s.hs(find(s.fs>0));

s = settolerance(s);
s = updatepval(s);
s = updatepredictions(s);


function s = seriesbasics(s)
s.predictstring = 'empty series';
    s.poly = 0;
    s.nextf = 0;
    s.prevf = 0;
    s.predicts = [];
    s.predecterrs = [];
s.outlawed = 0;
s.outlawchar = 'O';
s.predicts = [0 0];
s.predicterrs = [0 0];
s.maxdegree = 3;
s.pval = 1;
if length(s.fs) == 2  %new series
    s.fs = [0 0 s.fs 0 0 0 0];
    s.hs = [0 0 s.hs 0 0 0 0];
end

function s = settolerance(s)
switch s.whichcolumn 
    case 1
        s.tolerance = s.lowsidetolerance;
    case 2
        s.tolerance = [0 0 0 0 0];
    case 3
        s.tolerance = [0 0 0 0 0];
    case 4
        s.tolerance = s.highsidetolerance;
end

function s = updatepredictions(s)
    if length(s.realfs) >= 2
        n = min(length(s.realfs),s.maxdegree+1);

        x = 1:n;
        y = s.realfs(1:n);
        s.poly = polyfit(x,y,n-1);
        s.prevf = polyval(s.poly,0);
        s.prevfspread = guessquality(y,s,0);
        
        y = s.realfs(end+1-n:end);
        s.poly = polyfit(x,y,n-1);
        s.nextf = polyval(s.poly,n+1);
        s.nextfspread = guessquality(y,s,1);
        s.predictstring = sprintf('%s next %3.1f prev %3.1f\n',num2str(s.predicterrs),s.nextf,s.prevf);
    end
    
function fspread = guessquality(fs,s,upordown)
    degree = min(s.maxdegree,length(fs));
    fspread = s.tolerance(degree);
    minj = fs(1) / (fs(2) - fs(1));
    maxj = fs(end) / (fs(end) - fs(end-1));
    if upordown == 1
        jtouse = maxj;
    else
        jtouse = minj;
    end
    if jtouse < s.lowjthresh
        fspread = fspread * 2;
    end
    1;
    
function s = updatepval(s)
    s.pval = 1;
    for n = 1:(length(s.realfs)-2)
        %   n = min(length(s.realfs),maxdegree+1);
        numabove = length(s.realfs) - n;
        numtouse = min(s.maxdegree,numabove);
        x = 1:numtouse;
        y = s.realfs(n+1:n+numtouse);
        [p] = polyfit(x,y,numtouse-1);
        predictf = polyval(p,0);
        ferr = s.realfs(n) - predictf;
        s.predicts(end+1) = predictf;
        s.predicterrs(end+1) = abs(ferr);


        thisp = abs(ferr) / s.frange;
        if thisp < 1
            s.pval = s.pval * thisp;
        end

    end
    
