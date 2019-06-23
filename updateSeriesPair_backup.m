function s = updateSeriesPair(s)


if isfield(s,'fgrid') == 0  %new series.
    s = seriesBasics(s);
end

s = updateColumns(s);
s = updateDisplays(s);
s = updatePredictions(s);
s = updatePvals(s);


1;


function s = seriesBasics(s)
s.f0Freqs = [];
s.f0Heights = [];
startingJ = predictJ(s.f1Freqs(1),s.f1Freqs(2));
maxJ = floor(1.5 * startingJ * (s.maxf/s.f1Freqs(1)));
s.Jvalues = 1:maxJ;
s.fgrid = zeros(maxJ,2);
s.hgrid = s.fgrid;
s.fgrid(startingJ:startingJ+1,2) = s.f1Freqs';
s.hgrid(startingJ:startingJ+1,2) = s.f1Heights';
s.numf = 2;
s.closedf0 = 0;
s.closedAbove = 0;
s.closedBelow = 0;
s.closedAbovef0 = 0;
s.closedBelowf0 = 0;

s.closedOut = 0;
s.outlawed = 0;
s.outlawChar = 'O';
s.predicts = [0 0];
s.predictErrs = [0 0];
s.allResiduals = [];
s.maxDegree = 2;
s.midp = (s.maxf + s.minf)/2;
s.pval = 1;

function s = updateDisplays(s)
    s.blockString = [blockCharFromFlag(s.closedBelow) blockCharFromFlag(s.closedAbove) blockCharFromFlag(s.closedf0)  blockCharFromFlag(s.closedBelowf0) blockCharFromFlag(s.closedAbovef0)];
    s.blockInt = (s.closedBelow * 10000) + (s.closedAbove * 1000) + (s.closedf0 * 100) + (s.closedBelowf0 * 10) + (s.closedAbovef0 * 1);
    s.hashInt = round(sum(s.f1vals*1000) + sum(s.f0vals * 10000)) + s.blockInt;
    s.gridString = '';
    for j = 1:length(s.fgrid(:,1))
        i = 1 + (length(s.fgrid(:,1))-j);
        if (s.fgrid(i,1) > 0) || (s.fgrid(i,2) > 0)
            if (s.fgrid(i,1) == 0)
                s.gridString = sprintf('%s\nJ = %d, f0 = 00000.0, f1 = %3.1f',s.gridString,s.Jvalues(i),s.fgrid(i,2));
            else
                s.gridString = sprintf('%s\nJ = %d, f0 = %3.1f, f1 = %3.1f',s.gridString,s.Jvalues(i),s.fgrid(i,1),s.fgrid(i,2));
            end
        end
    end
   %s.fullString = sprintf('%d lines,%d pval = %3.2e\n%s',s.totalLines,s.blockInt,s.pval,s.gridString);
    
function c = blockCharFromFlag(f)
    switch f
        case 0
            c = '-';
        case 1
            c = 'X';
        otherwise
            c = '?';
    end
    
function s = updateColumns(s)
s.f1vals = s.fgrid(:,2);
s.f0vals = s.fgrid(:,1);


s.f1HighestJ = find(s.f1vals > 0,1,'last');
s.f1LowestJ = find(s.f1vals > 0,1,'first');

s.f1RealFreqs = s.f1vals(s.f1LowestJ:s.f1HighestJ)'; 
s.f1RealHeights = s.hgrid(s.f1LowestJ:s.f1HighestJ,2)';
s.f0HighestJ = find(s.f0vals > 0,1,'last');
if length(s.f0HighestJ) > 0
    s.f0LowestJ = find(s.f0vals > 0,1,'first');
    s.f0RealFreqs = s.f0vals(s.f0LowestJ:s.f0HighestJ)'; 
    s.f0RealHeights = s.hgrid(s.f0LowestJ:s.f0HighestJ,1)';
    s.nextf0J = s.f0HighestJ+1;
    s.prevf0J = s.f0LowestJ-1;

else
    s.f0RealFreqs = []; 
    s.f0RealHeights = [];
end
if length(s.f0RealFreqs) > 0
    s.closedf0 = 1;
end

s.allfs = [s.f1RealFreqs s.f0RealFreqs];
s.allhs = [s.f1RealHeights s.f0RealHeights];

s.totalLines = length(s.f1RealFreqs) + length(s.f0RealFreqs);
s.f1RealJs = s.Jvalues(s.f1LowestJ:s.f1HighestJ);
s.nextf1J = s.f1HighestJ+1;
s.prevf1J = s.f1LowestJ-1;

function s = updatePvals(s)
%each line falls within a residual of perfect.  pvalprefactor is ``how 
%num
if length(s.allResiduals >= 4)
    s.meanResidual = mean(abs(s.allResiduals));
    s.numConstraints = length(s.allResiduals) - length(s.k);  %e.g. 3 parameters, n constraints
    s.rawP = (s.meanResidual / (s.maxf - s.minf))^s.numConstraints;
    s.pvalprefactor = 1; %pvalprefactor basically counts how many ways to pick, say, 5 lines this high or higher. generally much bigger than 1
    for h = s.allhs
        linecount = countfrommcounttool(s.countTool,h);
        s.pvalprefactor = s.pvalprefactor * (linecount * 1.5);
    end  
    s.pval = s.rawP * s.pvalprefactor;
    s.residualString = sprintf('%d lines,%d constraints, %3.1f kHz residuals,p=%3.1g',s.totalLines,s.numConstraints,s.meanResidual*1000,s.pval);
    s.fullString = sprintf('%s\n%d blocked\n%s',s.residualString,s.blockInt,s.gridString);
else
    s.residualString = sprintf('%d lines, no residuals');
    s.fullString = sprintf('%d lines,%d no residuals\n%s',s.totalLines,s.blockInt,s.gridString);
end

function s = updatePredictions(s)
    %first do a polynomial prediction - either linear or quadratic using
    %last few points
    s.nextf0 = 0;
    s.prevf0 = 0;
    s = updatePolyPredictions(s);
    s = updateFancyPredictions(s);   
    s = chooseCorner(s);
    s.predictString = sprintf('next ftoseek %s,%3.1f-%3.1f\n',s.nextCorner,s.minftoseek,s.maxftoseek);
    
function s = updateFancyPredictions(s)
    exitFlag = 0;
    if length(s.f1RealFreqs) > 2
        if length(s.f0RealFreqs) == 0
            [s,exitFlag] = addfitf1(s);
        else
            [s,exitFlag] = addfitf1f0(s);
        end
    end
        
    if exitFlag <= 0
        s.nextf1 = s.polyNextf1;
        s.prevf1 = s.polyPrevf1;
        degree = min(length(s.f1RealFreqs),3)-1;
      %  s.f1Spread = s.ts.bendTolerance(degree);
        s.f1Spread = guessQuality(s);      
        s.fittype = 'polynomial';
    end
    
function [s,exitFlag] = addfitf1f0(s)
    [k,residuals,f1predicts,f0predicts,J1,J0,exitFlag] = fitf1f0(s.f1RealFreqs,s.f0RealFreqs);
    %[k residuals predicts J exitFlag f0predicts] = fitf1(s.f1RealFreqs,s.f1RealJs);
    %STUFF HERE FOR RESIDUALS, TO BE EATEN BY PVALS. PVALS AND H
    if exitFlag <= 0
        s.f1RealFreqs   
        s.f1Failed = 1;
        s.closedOut = 1;
        fprintf('fitf1f0 failed..not sure what to do');
        s.fgrid;
    end
    s.f0predicts = f0predicts;
   % s.f1Residuals = residuals;
    s.allResiduals = residuals;
    s.k = k;
  %  s.fancyPredicts = predicts;
    s.nextf1 = f1predicts(2);
    s.prevf1 = f1predicts(1);
    s.nextf0 = f0predicts(2);
    s.prevf0 = f0predicts(1);
    s.f0Spread = s.ts.fancytolerancef0;
    s.fittype = 'fitf1f0';
    
function [s exitFlag] = addfitf1(s)
    [k residuals predicts J exitFlag f0predicts] = fitf1(s.f1RealFreqs,s.f1RealJs);
    %STUFF HERE FOR RESIDUALS, TO BE EATEN BY PVALS. PVALS AND H
    if exitFlag <= 0
        s.f1RealFreqs
        fprintf('diff is %s, bend is %s\n',num2str(diff(s.f1RealFreqs)),num2str(diff(diff(s.f1RealFreqs))));
        s.f1Failed = 1;
        s.closedOut = 1;
        fprintf('fitf1 failed..not sure what to do');
    end
    s.k = k;
    s.f0predicts = f0predicts;
    s.allResiduals = residuals;
  %  s.fancyPredicts = predicts;
    s.nextf1 = predicts(2);
    s.prevf1 = predicts(1);
    s.f1Spread = s.ts.fancytolerance;
    s.fittype = 'fitf1';
        
function s = updatePolyPredictions(s)
    n = min(length(s.f1RealFreqs),s.maxDegree+1);
    x = 1:n;
    y = s.f1RealFreqs(1:n);
    s.poly = polyfit(x,y,n-1);
    s.polyPrevf1 = polyval(s.poly,0);
    s.f1Spread = guessQuality(s);

    y = s.f1RealFreqs(end+1-n:end);
    s.poly = polyfit(x,y,n-1);
    s.polyNextf1 = polyval(s.poly,n+1);
    
    
function s = chooseCorner(s)
    %selects which row and column to try and predict next.
    s.nextCorner = 'closedOut';
    if s.nextf1 > s.maxf
        s.closedAbove = 1;
    end
    if s.prevf1 < s.minf
        s.closedBelow = 1;
    end
    %first decide if it's f1 or f0.
    if (s.closedAbove == 1) && (s.closedBelow == 1) && (s.closedf0 == 1)
        %either f0up,f0down, or closed.
        if s.nextf0 > s.maxf
            s.closedAbove = 1;
        end
        if s.prevf0 < s.minf
            s.closedBelow = 1;
        end
    
        if abs(s.nextf0 - s.midp) < abs(s.prevf0 - s.midp)
            preferUp = 1;
        else
            preferUp = 0;
        end
        if (s.closedAbovef0 == 0) && (s.closedBelowf0 == 0)
            if preferUp
                s.nextCorner = 'f0up';
            else
                s.nextCorner = 'f0down';
            end
        end
        if (s.closedAbovef0 == 0) && (s.closedBelowf0 == 1)
            s.nextCorner = 'f0up';
        end
        if (s.closedAbovef0 == 1) && (s.closedBelowf0 == 0)
            s.nextCorner = 'f0down';
        end
        if length(s.f0RealFreqs) == 0  %closed out and nowhere to go
            s.nextCorner = 'closedOut';
        end
        switch s.nextCorner
            case 'f0up'
                s.ftoseek = s.nextf0;
                s.nextcolumn = 1;
                s.nextrow = s.nextf0J;
            case 'f0down'
                s.ftoseek = s.prevf0;
                s.nextcolumn = 1;
                s.nextrow = s.prevf0J;
            case 'closedOut'
                s.closedOut = 1;
        end
        if (s.closedOut == 0)  %always BELOW the linear prediction
            
            s.maxftoseek = s.ftoseek + s.f0Spread;
            s.minftoseek = s.ftoseek - s.f0Spread;
        else
           
            s.ftoseek = 0;
            s.maxftoseek = 0;
            s.minftoseek = 0;
        end
    else
        
        if (s.closedAbove == 1) && (s.closedBelow == 1) && (s.closedf0 == 0) %have to go to f0
            %this is f0straight
            
            if (length(s.f0RealFreqs) == 0) && (length(s.f1RealFreqs) >= s.ts.minf1length)
                s.nextCorner = 'f0first';
                [bestJ bestf] = pickOneF(s.f0predicts,s.f1RealJs);
                %         s.fgrid
                s.ftoseek = bestf;
                s.maxftoseek = s.ftoseek + s.ts.f1tof0tolerance;
                s.minftoseek = s.ftoseek - s.ts.f1tof0tolerance;
                s.nextcolumn = 1;
                s.nextrow = bestJ;
                %f0predicts = F0(k,J);
            else
                s.closedf0 = 1;
            end
        else
            
            if abs(s.nextf1 - s.midp) < abs(s.prevf1 - s.midp)
                preferUp = 1;
            else
                preferUp = 0;
            end
            s.nextCorner = 'closedOut';
            if (s.closedAbove == 0) && (s.closedBelow == 0)
                if preferUp
                    s.nextCorner = 'f1up';
                else
                    s.nextCorner = 'f1down';
                end
            end
            if (s.closedAbove == 0) && (s.closedBelow == 1)
                s.nextCorner = 'f1up';
            end
            if (s.closedAbove == 1) && (s.closedBelow == 0)
                s.nextCorner = 'f1down';
            end
            switch s.nextCorner
                case 'f1up'
                    s.ftoseek = s.nextf1;
                    s.nextcolumn = 2;
                    s.nextrow = s.nextf1J;
                case 'f1down'
                    s.ftoseek = s.prevf1;
                    s.nextcolumn = 2;
                    s.nextrow = s.prevf1J;
                    
            end
            if (s.closedOut == 0)  %always BELOW the linear prediction
                if (length(s.f1RealFreqs) == 2)
                    s.maxftoseek = s.ftoseek;
                    s.minftoseek = s.ftoseek - s.f1Spread;
                else
                    s.maxftoseek = s.ftoseek + s.f1Spread;
                    s.minftoseek = s.ftoseek - s.f1Spread;
                end
            end
        end
    end
function [bestJ bestf] = pickOneF(f0predicts,J)
    besti = round(length(J)/2);
    bestJ = J(besti);
    bestf = f0predicts(besti);
    
function fspread = guessQuality(s)
    fs = s.f1RealFreqs;
    if length(fs) == 2
        tolerance1 = s.ts.bendTolerance(1);
        maxgap = max(diff(s.f1RealFreqs));
        tolerance2 = maxgap / s.ts.gapoverbendmax;
    else
        tolerance1 = s.ts.bendTolerance(length(fs)-1);  %only get here when fitf1 failed.. maybe just give up at this point? 
        tolerance2 = 3 * mean(abs(diff(diff(fs))));
    end
    fspread = min(tolerance1,tolerance2);
    
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
    