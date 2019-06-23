function [lineset] = linesfromseriessquareb(s,startj,startka,uselines,useac)

if nargin < 4
    uselines = [100 100 100 100];
end
if nargin < 4
    useac = 0;
end
    s.fcutoff = 100000;
    s.fmin = 0;
    %fgrid = s.fgrid;
    fgrid = s.fgrid;
    %ordercutoff = s.ordercutoff;
    ordercutoff = Inf;
%end

%smartABC = findABC(fgrid);
starti = 1;
endi = 50;
    
starti = max(starti,1);
endi = min(length(fgrid(:,1)),endi);

line1.Jupper = 2;
line1.Kaupper = 0; 
line1.Kcupper = 2; 
line1.Jlower = 1; 
line1.Kalower = 0; 
line1.Kclower = 1; 
line1.expfreq = 0;
line1 = updateline(line1);
line1.transitiontype = 'a';

line2.Jupper = 2;
line2.Kaupper = 1; 
line2.Kcupper = 2; 
line2.Jlower = 1; 
line2.Kalower = 0; 
line2.Kclower = 1; 
line2.expfreq = 0;
line2 = updateline(line2);
line2.transitiontype = 'b';

line3.Jupper = 2;
line3.Kaupper = 0; 
line3.Kcupper = 2; 
line3.Jlower = 1; 
line3.Kalower = 1; 
line3.Kclower = 1; 
line3.expfreq = 0;
line3 = updateline(line3);
line3.transitiontype = 'b';

line4.Jupper = 2;
line4.Kaupper = 1; 
line4.Kcupper = 2; 
line4.Jlower = 1; 
line4.Kalower = 1; 
line4.Kclower = 1; 
line4.expfreq = 0;
line4 = updateline(line4);
line4.transitiontype = 'a';

if useac == 1
    line2.Kcupper = 1; 
    line3.Kclower = 0;
    line4.Kcupper = 1;  
    line4.Kclower = 0; 
    line2.transitiontype = 'c';
    line3.transitiontype = 'c';
end

    
for i = 1:startka
    line1 = bumpka(line1);
    line2 = bumpka(line2);
    line3 = bumpka(line3);
    line4 = bumpka(line4);
end


for i = 1:startj-1
    line1 = bumpj(line1);
    line2 = bumpj(line2);
    line3 = bumpj(line3);
    line4 = bumpj(line4);
end
lineset = {};
columns = [1 2 3 4];
% if flipit == 1
%     columns = [4 3 2 1];
% end
if startj == 0
    starti = starti+1;
end
if startj == -1
    starti = starti+2;
end
for i = starti:endi
    line1.expfreq = fgrid(i,columns(1));
    line1 = updateline(line1);
    if (line1.expfreq > s.fmin) && (line1.expfreq < s.fcutoff) && (uselines(1) >= i)% && (s.alineorder(i,columns(1)) <= ordercutoff)
        lineset{end+1} = line1;
    end
    
    line2.expfreq = fgrid(i,columns(2));
    line2 = updateline(line2);
    if (line2.expfreq > s.fmin) && (line1.expfreq < s.fcutoff) && (uselines(2) >= i)% && (s.alineorder(i,columns(2)) <= ordercutoff)
        lineset{end+1} = line2;
    end
    
    line3.expfreq = fgrid(i,columns(3));
    line3 = updateline(line3);
    if (line3.expfreq > s.fmin) && (line1.expfreq < s.fcutoff) && (uselines(3) >= i)% && (s.alineorder(i,columns(3)) <= ordercutoff)
        lineset{end+1} = line3;
    end
    
    line4.expfreq = fgrid(i,columns(4));
    line4 = updateline(line4);
    if (line4.expfreq > s.fmin) && (line1.expfreq < s.fcutoff) && (uselines(4) >= i)% && (s.alineorder(i,columns(4)) <= ordercutoff)
        lineset{end+1} = line4;
    end
    line1 = bumpj(line1);
    line2 = bumpj(line2);
    line3 = bumpj(line3);
    line4 = bumpj(line4);
end
% longdescriptor = sprintf('%d line set:',length(lineset));
% for i = 1:length(lineset)
%     longdescriptor = sprintf('%s\n%s',longdescriptor,lineset{i}.descriptor);
% end
% descriptor = sprintf('%s\n%s\n%s\n%s\n%d lines total',lineset{1}.descriptor,lineset{2}.descriptor,lineset{3}.descriptor,lineset{4}.descriptor,length(lineset));




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
