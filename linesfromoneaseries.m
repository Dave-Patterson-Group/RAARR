function [lineset descriptor longdescriptor smartABC] = linesfromoneaseries(s,startka,highside)

if isfield(s,'visiblefs') == 0
    s.visiblefs = s.realfs;
end
j = s.visiblefs(2)/(s.visiblefs(2) - s.visiblefs(1));
startj = j - 3;
  

starti = 1;
endi = length(s.visiblefs);

line1.Jupper = 2;
line1.Kaupper = 0; 
line1.Kcupper = 2; 
line1.Jlower = 1; 
line1.Kalower = 0; 
line1.Kclower = 1; 
line1.expfreq = 0;
line1 = updateline(line1);

line4.Jupper = 2;
line4.Kaupper = 1; 
line4.Kcupper = 2; 
line4.Jlower = 1; 
line4.Kalower = 1; 
line4.Kclower = 1; 
line4.expfreq = 0;
line4 = updateline(line4);

for i = 1:startka
    line1 = bumpka(line1);
    line4 = bumpka(line4);
end


for i = 1:startj
    line1 = bumpj(line1);
    line4 = bumpj(line4);
end
lineset = {};
if highside == 1
    line1 = line4;

end

for i = starti:endi
    line1.expfreq = s.visiblefs(i);
    lineset{end+1} = line1;
    
    line1 = bumpj(line1);

end
longdescriptor = sprintf('%d line set:',length(lineset));
for i = 1:length(lineset)
    longdescriptor = sprintf('%s\n%s',longdescriptor,lineset{i}.descriptor);
end
if length(lineset) >= 4
    descriptor = sprintf('%s\n%s\n%s\n%s\n%d lines total',lineset{1}.descriptor,lineset{2}.descriptor,lineset{3}.descriptor,lineset{4}.descriptor,length(lineset));
else
    descriptor = 'dont be dumb';
end

function thisline = updateline(thisline)
thisline.lowerhash = (thisline.Jlower * 1e4) + (thisline.Kalower * 1e2) + (thisline.Kclower);
thisline.upperhash = (thisline.Jupper * 1e4) + (thisline.Kaupper * 1e2) + (thisline.Kcupper);
thisline.hash = thisline.lowerhash + (1e6 * thisline.upperhash);
thisline.descriptor = sprintf('%d->%d %f',thisline.upperhash,thisline.lowerhash,thisline.expfreq);

function thisline = bumpka(thisline)
thisline.Kaupper = thisline.Kaupper + 1;
thisline.Kcupper = thisline.Kcupper - 1;
thisline.Kalower = thisline.Kalower + 1;
thisline.Kclower = thisline.Kclower - 1;
thisline = updateline(thisline);


function thisline = bumpj(thisline)
thisline.Jupper = thisline.Jupper + 1;
thisline.Kcupper = thisline.Kcupper + 1;
thisline.Jlower = thisline.Jlower + 1;
thisline.Kclower = thisline.Kclower + 1;
thisline = updateline(thisline);
