
function s = updateseriessquare(s)
    if nargin < 2
        slowmode = 1;
    end


s.column1 = updateseries(s.column1);
s.column2 = updateseries(s.column2);
s.column3 = updateseries(s.column3);
s.column4 = updateseries(s.column4);

s.numjs = length(s.column1.fs);  %this should be the same as all others. now fixed
s.fgrid = zeros(s.numjs,4);

% if s.dtype == 1
    s.fgrid(1:end,1) = s.column1.fs;
    s.fgrid(1:end,2) = s.column2.fs;
    s.fgrid(1:end,3) = s.column3.fs;
    s.fgrid(1:end,4) = s.column4.fs;
    
    if isfield(s,'originalfgrid') == 0
        s.originalfgrid = s.fgrid;
    end
    
    if isfield(s,'allpredicts') == 0
        s.lineorder = s.fgrid  * 0;
        switch s.flattype
            case 'D'
                if s.fgrid(3,1) ~= 0
                    s.lineorder(3,:) = [1   3   0   0];
                    s.lineorder(4,:) = [2   0   4   0];
                else
                    s.lineorder(3,:) = [0   0   3   1];
                    s.lineorder(4,:) = [0   4   0   2];
                end
                
            case '/' 
                    s.lineorder(3,:) = [3   1   0   0];
                    s.lineorder(4,:) = [0   2   0   4];
     
                
            case '\' 
%             
                    s.lineorder(3,:) = [0   0   1   3];
                    s.lineorder(4,:) = [4   0   2   0];
       
        end
%         s.lineorder(5,:) = [9  12  10  11]; 
%         s.lineorder(6,:) = [13 16  14  15];
%         s.lineorder(7,:) = [17 20  18  19]; 
%         s.lineorder(8,:) = [21 24  22  23];
        s.allpredicts = s.fgrid * 0;
        s.alineorder = s.lineorder;
        s.corners = zeros(1,8);
    end
    s.maxnumlines = max(max(s.lineorder));
    s.columnorder = zeros(1,s.maxnumlines);
    s.roworder = s.columnorder;
    
    n = 1;
    for i = 1:s.numjs
        for j = 1:4
%             if s.originalfgrid(i,j) ~= 0
%                 s.alineorder(i,j) = n;
%                 n = n+1;
%             end
 
            thiso = s.lineorder(i,j);
            if thiso > 0
                s.columnorder(thiso) = j;
                s.roworder(thiso) = i;

            end
        end
    end
    
    for i = 1:4
        r = s.roworder(i);
        c = s.columnorder(i);
        s.listpredicts(i) = s.fgrid(r,c) - s.flatsquare.flaterrors(i);
        s.allpredicts(r,c) = s.listpredicts(i);
    end
    s.allerrors = s.fgrid - s.allpredicts;
    

fdiffs = [];
if length(s.column1.realfs) >= 2
    fdiffs = diff(s.column1.realfs);
end
if length(s.column4.realfs) >= 2
    fdiffs = [fdiffs diff(s.column4.realfs)];
end
if length(fdiffs) > 0
    s.bpluscguess = mean(fdiffs);
    s.bpluscerror = s.lowsidetolerance(2);
else
    if length(s.column2.realfs) >= 2
        fdiffs = diff(s.column2.realfs);
    end
    if length(s.column3.realfs) >= 2
        fdiffs = [fdiffs diff(s.column3.realfs)];
    end
    if length(fdiffs) > 0
        s.bpluscguess = mean(fdiffs);
        s.bpluscerror = s.lowsidetolerance(2);
    else
        s.bpluscguess = 3000;
        s.bpluscerror = s.bpluscguess * 0.9; %no idea what bplusc is
    end
end

s.highestfullrow = 0;
s.lowestfullrow = 0;

n = length(s.column1.fs) + 1;
for i = length(s.column1.fs)
    if (s.column1.fs(i) ~= 0) && (s.column2.fs(i) ~= 0) && (s.column3.fs(i) ~= 0) && (s.column4.fs(i) ~= 0)
        s.highestfullrow = i;
    end
    if (s.column1.fs(n-i) ~= 0) && (s.column2.fs(n-i) ~= 0) && (s.column3.fs(n-i) ~= 0) && (s.column4.fs(n-i) ~= 0)
        s.lowestfullrow = n-i;
    end
    if (s.column1.fs(i) ~= 0) || (s.column2.fs(i) ~= 0) || (s.column3.fs(i) ~= 0) || (s.column4.fs(i) ~= 0)
        s.highestpartialrow = i;
    end
    if (s.column1.fs(n-i) ~= 0) || (s.column2.fs(n-i) ~= 0) || (s.column3.fs(n-i) ~= 0) || (s.column4.fs(n-i) ~= 0)
        s.lowestpartialrow = n-i;
    end
end
%s.degree = length(s.column1.fs) - 1;
quadsums = [];
for i = 2:length(s.column1.fs)-1
    if (s.fgrid(i,1) ~= 0) && (s.fgrid(i+1,1) ~= 0) && (s.fgrid(i,2) ~= 0) && (s.fgrid(i+1,3) ~= 0) %D1
    	quadsums(end+1) = s.fgrid(i,1) + s.fgrid(i+1,1) - s.fgrid(i,2) - s.fgrid(i+1,3);
    end
    if (s.fgrid(i,4) ~= 0) && (s.fgrid(i+1,4) ~= 0) && (s.fgrid(i,3) ~= 0) && (s.fgrid(i+1,2) ~= 0) %D2
    	quadsums(end+1) = s.fgrid(i,4) + s.fgrid(i+1,4) - s.fgrid(i,3) - s.fgrid(i+1,2);
    end
    if (s.fgrid(i,1) ~= 0) && (s.fgrid(i,2) ~= 0) && (s.fgrid(i+1,2) ~= 0) && (s.fgrid(i+1,4) ~= 0) %slashsup
    	quadsums(end+1) = s.fgrid(i,1) - s.fgrid(i+1,4) - s.fgrid(i,2) + s.fgrid(i+1,2);
    end
    if (s.fgrid(i+1,1) ~= 0) && (s.fgrid(i,3) ~= 0) && (s.fgrid(i+1,3) ~= 0) && (s.fgrid(i,4) ~= 0) %slashsup
    	quadsums(end+1) = s.fgrid(i+1,1) - s.fgrid(i,4) + s.fgrid(i,3) - s.fgrid(i+1,3);
    end
    if (s.fgrid(i,1) ~= 0) && (s.fgrid(i,2) ~= 0) && (s.fgrid(i,3) ~= 0) && (s.fgrid(i,4) ~= 0)  %X
    	quadsums(end+1) = s.fgrid(i,1) + s.fgrid(i,4) - s.fgrid(i,3) - s.fgrid(i,2);
    end
end
    s.healthy = checkhealth(s);
    s.aheight = mean([s.column1.realhs s.column4.realhs]);
    s.bheight = mean([s.column2.realhs s.column3.realhs]);
%     if length(s.column1.realhs) > 0
%         s.aheight = mean(s.column1.realhs);
%     else
%         s.aheight = s.column4.realhs(end);
%     end
%     if (length(s.column1.realhs) > 0) && (length(s.column4.realhs) > 0)
%         aheight = (s.column1.realhs(end) + s.column1.realhs(end))/2;
%     end
%     if length(s.column2.realhs) > 0
%         bheight = s.column2.realhs(end);
%     else
%         bheight = s.column3.realhs(end);
%     end
%     if (length(s.column2.realhs) > 0) && (length(s.column3.realhs) > 0)
%         bheight = (s.column2.realhs(end) + s.column3.realhs(end))/2;
%     end
s.longquadstring = sprintf('Quad sums:');
for i = 1:length(quadsums)
    s.longquadstring = sprintf('%s\n%3.4f',s.longquadstring,quadsums(i)); 
end
s.medianquadsum = median(abs(quadsums));
s.maxquadsum = max(abs(quadsums));
s.quadstring = sprintf('%d quads, median %3.1f,max %3.1f Khz',length(quadsums),s.medianquadsum *1000,s.maxquadsum*1000);
meanquadsum = sqrt(mean(quadsums.^2));
s.meanquadsum = max(meanquadsum,.001);
if s.meanquadsum > 0.1
%     if containsf(s,3000) == 0
%         fprintf('doesnt have 3000');
%     end
    quadsums
    s.fgrid
  %  error('quads dont work!');
end
s.quadsums = quadsums;
s.onequadpval = s.meanquadsum / s.frange;
sums = [];
csums = [];


s.allfs = [s.column1.realfs s.column2.realfs s.column3.realfs s.column4.realfs];
s.allhs = [s.column1.realhs s.column2.realhs s.column3.realhs s.column4.realhs];

s.listerrors = zeros(1,length(s.allfs));
s.f1 = s.fgrid(s.roworder(1),s.columnorder(1));
for i = 1:4
    for j = 1:length(s.column1.fs)
        thiso = s.alineorder(j,i);
        thisf = s.fgrid(j,i);
        if thisf ~= 0
            if thiso == 0
                1;
            end
            s.listerrors(thiso) = s.allerrors(j,i);
        end
    end
end
s.allnormerrors = s.allerrors/s.f1;
s.listnormerrors = s.listerrors/s.f1;
s.errorstring = sprintf('prediction\n errors\n');
s.searchspace = 1;
for i = 1:length(s.listerrors)
   
    if (i <= 12) && ((i == 2) || mod(i,2) == 1)
         s.searchspace = s.searchspace * s.listerrors(i);
    end
    s.errorstring = sprintf('%s %3.2f\n',s.errorstring,s.listerrors(i));
end
s.errorstring = sprintf('%s NET\n%3.1e\n',s.errorstring,s.searchspace);
s.nextline = length(s.allfs) + 1;


s.aamaxerror = 0;
s.abmaxerror = 0;
aaerrors = [];
aberrors = [];
for i = 1:length(s.column1.fs)
    if (s.column1.fs(i) ~= 0) && (s.column4.fs(i) ~= 0)
        aaerrors(end+1) = s.column1.fs(i) - s.column4.fs(i);
    end
    if (s.column1.fs(i) ~= 0) && (s.column2.fs(i) ~= 0)
        aberrors(end+1) = s.column1.fs(i) - s.column2.fs(i);
    end
    if (s.column1.fs(i) ~= 0) && (s.column3.fs(i) ~= 0)
        aberrors(end+1) = s.column1.fs(i) - s.column3.fs(i);
    end
end
if length(aaerrors) > 0
    s.aamaxerror = max(abs(aaerrors));
end
if length(aberrors) > 0
    s.abmaxerror = max(abs(aberrors));
end
s.numlines = length(s.allfs);
s.numconstraints = (s.numlines / 2) - 1;  %better than degree
s.degree = s.numconstraints;
%if s.dtype == 1
    s.allafs = [s.column1.realfs s.column4.realfs];
    s.allahs = [s.column1.realhs s.column4.realhs];
    s.allbfs = [s.column2.realfs s.column3.realfs];
    s.allbhs = [s.column2.realhs s.column3.realhs];
% else
%     s.allafs = [s.series2.realfs s.series3.realfs];
%     s.allahs = [s.series2.realhs s.series3.realhs];
%     s.allbfs = [s.series1.realfs s.series4.realfs];
%     s.allbhs = [s.series1.realhs s.series4.realhs];
% end
s.heightstring = sprintf('A heights %s, B heights %s',num2str(s.allahs,3),num2str(s.allbhs,3));
%s.series4string = sprintf('Series 4 predictions: %s',num2str(s.series4.fs,6));

s.minf = min(s.allfs);
s.minh = min(s.allhs);
s.allbestfs = s.allfs;
s.allbesths = s.allhs;  %update later if degree >= 2
s.bestfstring = num2str(s.allfs,6);
s.series4string = 'no series 4 yet';
s.allfstring = num2str(s.allfs,6);
s.bendstring = '2 points, no bend';
s.sortfs = sort(s.allfs);
s.usablefgrid = usablefgrid(s);
s.gridhash = hashfromsquare(s);
s.mindiff = min(diff(s.sortfs));
s.isoutlawed = s.column1.outlawed || s.column2.outlawed || s.column3.outlawed || s.column4.outlawed || (s.mindiff < 0.01);
s.seriesstring = sprintf('%c%c%c%c',s.column1.outlawchar,s.column2.outlawchar,s.column3.outlawchar,s.column4.outlawchar);



s.a1diff = 0;
s.a2diff = 0;
s.a1bend = 0;
s.a2bend = 0;
s.b1diff = 0;
s.b2diff = 0;
s.b1bend = 0;
s.b2bend = 0;
if length(s.column1.realfs) >= 2
    s.a1diff = mean(diff(s.column1.realfs));
end

if length(s.column1.realfs) >= 3
    s.a1bend = mean(diff(diff(s.column1.realfs)));
end
s.a1bendstring = sprintf('a1diff %3.3f, a1bend %3.3f',s.a1diff,s.a1bend);

if length(s.column2.realfs) >= 2
    s.b1diff = mean(diff(s.column2.realfs));
end

if length(s.column2.realfs) >= 3
    s.b1bend = mean(diff(diff(s.column2.realfs)));
end

s.b1bendstring = sprintf('b1diff %3.3f, b1bend %3.3f',s.b1diff,s.b1bend);

if length(s.column4.realfs) >= 2
    s.a2diff = mean(diff(s.column4.realfs));
end

if length(s.column4.realfs) >= 3
    s.a2bend = mean(diff(diff(s.column4.realfs)));
end
s.a2bendstring = sprintf('a2diff %3.3f, a2bend %3.3f',s.a2diff,s.a2bend);

if length(s.column3.realfs) >= 2
    s.b2diff = mean(diff(s.column3.realfs));
end

if length(s.column3.realfs) >= 3
    s.b2bend = mean(diff(diff(s.column3.realfs)));
end
s.b2bendstring = sprintf('b2diff %3.3f, b2bend %3.3f',s.b2diff,s.b2bend);


s.tightdescriptor = sprintf('%s\n%s\n%s\n%s\n%s\naa tolerance %3.1f, abtolerance %3.1f\n',s.a1bendstring,s.a2bendstring,s.b1bendstring,s.b2bendstring,s.quadstring,s.aamaxerror,s.abmaxerror);
s.columnp = 1;
s.columndiffs = [s.a1diff s.b1diff s.b2diff s.a2diff];
s.realcolumndiffs = s.columndiffs(s.columndiffs < Inf);
s.columndiffspread = max(s.realcolumndiffs) - min(s.realcolumndiffs);
s.numcolumnconstraints = length(s.realcolumndiffs) - 1;
%reward for columns agreeing with each other.
if s.numcolumnconstraints >= 1
    s.columnp = (s.columndiffspread/s.frange)^s.numcolumnconstraints;
end

s.termstring = 'ud';
if s.upterminated == 1
    s.termstring(1) = 'U';
end
if s.downterminated == 1
    s.termstring(2) = 'D';
end
%now do pvalues
s = addlevels(s);
%choose which row to do next
allcoords{1} = predictnext(s,'ur');
allcoords{2} = predictnext(s,'ul');
allcoords{3} = predictnext(s,'dr');
allcoords{4} = predictnext(s,'dl');
if s.forcecorners == 0
    dists = [allcoords{1}.fdist allcoords{2}.fdist allcoords{3}.fdist allcoords{4}.fdist];

    %recommended = [allcoords{1}.isrecommended allcoords{2}.isrecommended allcoords{3}.isrecommended allcoords{4}.isrecommended];
    %recn = find(recommended == 1);
    %dists = dists(recn);

    bestcorner = find(dists == min(dists),1,'first');
    reccoords = allcoords{bestcorner};
    if min(dists) > 1e9
        s.closedout = 1;
    end
else
    if (s.numlines+1) > length(s.cornermap)
        s.closedout = 1;
    else
        
        reccoords = allcoords{s.cornermap(s.numlines+1)};
        bestcorner = s.cornermap(s.numlines+1);
    end
end


if s.closedout == 0 %s.nextline < length(s.columnorder)
    s.corners(s.numlines+1) = bestcorner;
  %  s.reccoords = reccoords;
    s.nextcolumn = reccoords.c1;
    s.nextrow = reccoords.r1;   %how to do the constraints? use energies I think. maybe slow?

    s.nextnextcolumn = reccoords.c2;
    s.nextnextrow = reccoords.r2;
    s.alineorder(s.nextrow,s.nextcolumn) = s.numlines+1;
    s.alineorder(s.nextnextrow,s.nextnextcolumn) = s.numlines+2;
  %  [coords] = predictnext(s);
    s.nextpredictf = reccoords.f1;
    s.nextnextpredictf = reccoords.f2;
    s.nextenergydiff = reccoords.energydiff;
    s.nextminf = reccoords.minf;
    s.nextmaxf = reccoords.maxf;
    s.allpredicts(s.nextrow,s.nextcolumn) = s.nextpredictf;
else
    s.nextcolumn = 0;
    s.nextrow = 0;
    s.nextnextcolumn = 0;
    s.nextnextrow = 0;
end

if (s.prolate == 1) && (s.oblate == 1)
    s.isoutlawed = 1;
end

if s.prolate == 0
    1;
    sold = s;
    s = flipseriessquare(s);
    1;
end

s.pvalprefactor = 1;
for h = s.allhs
    linecount = countfrommcounttool(s.counttool,h);
    s.pvalprefactor = s.pvalprefactor * (linecount * 1.5);
end
s.linecount = countfrommcounttool(s.counttool,min(s.allhs));

s.oldpvalprefactor = s.linecount^length(s.allfs);

s.seriespval = s.column1.pval * s.column2.pval * s.column3.pval * s.column4.pval;
s.quadpval = s.onequadpval^s.numconstraints;

s.netpval = s.pvalprefactor * s.seriespval * s.quadpval * s.columnp;
if isnan(s.netpval)
    1;
end
if isfield(s,'originalpval') == 0
    s.originalpval = s.netpval;
end

f2f1 = s.column1.fs(2) - s.column1.fs(1);
if s.column1.fs(3) > 0
    s.predictoffset = s.column1.fs(3)/s.bpluscguess;  %guess at starting j
else
    s.predictoffset = (s.column1.fs(4)/s.bpluscguess) - 1;
end
s.pvalstring = sprintf('net pval %3.1e [%3.1e original], %d constraints, [%3.1e %3.1e]',s.netpval,s.originalpval,s.numconstraints,s.seriespval,s.quadpval);
s.shortpvalstring = sprintf('net pval %3.1e, %d constraints',s.netpval,s.numconstraints);
s.verbosebend = sprintf('%s\n%s\n%s',s.column1.predictstring,s.column2.predictstring,s.column3.predictstring);
s.descriptor = sprintf('%s square of degree %d, %d lines',s.termstring,s.degree,s.numlines);
if (s.degree >= s.tightnesssettings.mindegree) && (s.netpval < s.tightnesssettings.checkablepval)
    s.testable =  1;
else
    s.testable = 0;
end

function shortfgrid = usablefgrid(s)
fatgrid = 0;
numrows = length(s.fgrid(:,1));
numentries = length(s.allfs);
if numentries <= s.tightnesssettings.smallestscaffold
    shortfgrid = s.fgrid;
    return
end
% if numentries > 16
%     fatgrid = 1;
% end
shortfgrid = s.fgrid*0;
numfilled = 0;
for i = 1:numrows
    thisrow = s.fgrid(i,:);
    if min(thisrow) > 0
        %fullrows(i) = 1;
        if (fatgrid == 0)
            shortfgrid(i,:) = thisrow;
            numfilled = numfilled+1;
        else
            fatgrid = 0;
        end
        if numfilled >= s.tightnesssettings.minrungs
            return;
        end
    end
end

function gridhash = hashfromsquare(s)
  fgrid = s.usablefgrid;
  gridhash = 0;
  numrows = length(fgrid(:,1));
  for i = 1:numrows
        thisrow = fgrid(i,:);
        if max(thisrow) > 0
            firstentry = i;
            break
        end
  end
  for i = 1:numrows
      for j  = 1:4
          gridhash = gridhash + (fgrid(i,j) * ((1 + i - firstentry) + (12345 * j)));
      end
  end
    
function s = addlevels(s)
%strings together transitions to find levels.  not particularly fast. by
%the end, levels.maxe and levels.mine should reflect the spread of
%calculated values. overcontraints simply ignored - work it out later
%levels.isknown = zeros(s.numjs+1,2); %how many constr

%also labels items in fgrid which are searchable or overconstrained.
%s.fstatus can be: 
%s.fstatus(i,j) == 0 % untouched
%s.fstatus(i,j) == 1 % known
%s.fstatus(i,j) == 2 % worth searching - connects to two. set flimits?
%maybe not
%s.fstates(i,j) == 3 % MUST search - overconstrained. s.flimits set tight
%fstatus = s.
levels.energy = zeros(s.numjs+1,2);
%levels.energy(2,1) = 1;
if s.fgrid(3,1) ~= 0
    levels.energy(3,1) = -1;  %start with j = 1 from bottom
else
    if s.fgrid(3,4) ~= 0
        levels.energy(3,2) = -1;
    else
        error('grid is a blank-o');
    end
end
growing = 1;
while growing == 1
    growing = 0;
    for j = 1:s.numjs
        for i = 1:4
            if s.fgrid(j,i) ~= 0
                [levels added] = addlinetolevels(levels,j,i,s.fgrid(j,i));
                if added 
                    growing = 1;
                end
            end
        end
    end
end
minenergy = min(min(levels.energy));

newenergies = 1e-8 + levels.energy - minenergy;  %not zero because zero means unknown
for i = 1:s.numjs+1
    for j = 1:2
        if levels.energy(i,j) == 0
            newenergies(i,j) = 0;
        end
    end
end
s.prolate = 0;
s.oblate = 0;
for i = 1:s.numjs+1
    if (newenergies(i,1) ~= 0) && (newenergies(i,2) ~= 0) 
        if (newenergies(i,1) < newenergies(i,2))
            s.prolate = 1;
        else
            s.oblate = 1;
        end
    end
end
%     end
%     if (newenergies(i,1) ~= 0) && (newenergies(i,2) ~= 0) && (newenergies(i,1) < newenergies(i,2))
%         s.oblate = 1;
%     end
% end
s.energies = newenergies;
%strings together transitions to find the levels, which are nominally
%needed just for plotting, but also are a good thing to keep in mind.

function healthy = checkhealth(s)
healthy = 1;
numrows = length(s.fgrid(:,1));
for i = 1:numrows-1
    ivalue = s.fgrid(i,2);
    jvalue = s.fgrid(i+1,2);
    
    if tooclose(s.fgrid(i,2),s.fgrid(i+1,3),3.0)
       healthy = 0;
    end
    if tooclose(s.fgrid(i,3),s.fgrid(i+1,2),3.0)
       healthy = 0;
    end
    if healthy == 0
        1;
    end
end
        
function t = tooclose(i,j,thresh)
if (i > 0) && (j > 0) && abs(i-j) < thresh
        t = 1;
else
    t = 0;
end
function [levels added] = addlinetolevels(levels,j,whichseries,f)

level1i = j;
level2i = j+1; %j-1?
added = 0;
switch whichseries
    case 1
        level1j = 1;
        level2j = 1;
    case 2
        level1j = 1;
        level2j = 2;
    case 3
        level1j = 2;
        level2j = 1;
    case 4
        level1j = 2;
        level2j = 2;
end
% known1 = levels.isknown(level1j,level1i);
% known2 = levels.isknown(level2j,level2i);
e1 = levels.energy(level1i,level1j);
e2 = levels.energy(level2i,level2j);
if abs(f - 12016) < 1
    1;
end
if ((e1 == 0) && (e2 == 0)) || ((e1 ~= 0) && (e2 ~= 0))
    %cowcow theres something here.. this is overconstrained.
    return
end
if (e1 ~= 0)  %set e2
    newe2 = e1 + f;
    if (e2 == 0) %setting e2 for the first time
        added = 1;
        levels.energy(level2i,level2j) = newe2;
    end
end
if (e2 ~= 0)  %set e2
    newe1 = e2 - f;
    if (e1 == 0) %setting e2 for the first time
        added = 1;
        levels.energy(level1i,level1j) = newe1;
    end
end

function s2 = flipseriessquare(s)
s2 = s;
s2.column1 = s.column4;
s2.column2 = s.column3;
s2.column3 = s.column2;
s2.column4 = s.column1;
s2.column1.whichcolumn = 1;
s2.column2.whichcolumn = 2;
s2.column3.whichcolumn = 3;
s2.column4.whichcolumn = 4;

s2.flipped = s.flipped+1;
s2.fgrid = flipmatrix(s.fgrid);
s2.originalfgrid = flipmatrix(s.originalfgrid);
s2.alineorder = flipmatrix(s.alineorder);
s2.lineorder = flipmatrix(s.lineorder);
s2.allerrors = flipmatrix(s.allerrors);
if s.flattype == '/'
    s2.flattype = '\';
end
if s.flattype == '\'
    s2.flattype = '/';
end
%s2 = rmfield(s2,'lineorder');
s2 = updateseriessquare(s2);

function g2 = flipmatrix(g)
g2 = g * 0;
g2(:,1) = g(:,4);
g2(:,2) = g(:,3);
g2(:,3) = g(:,2);
g2(:,4) = g(:,1);


