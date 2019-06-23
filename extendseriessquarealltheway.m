
function [newsquarelist,boggeddown,census] = extendseriessquarealltheway(squarelist,fs,hs)

census = zeros(1,20);
boggeddown = 0;
newsquarelist = squarelist;
if length(squarelist) == 0
    return
end
extendingup = 1;

%in these nearly degenerate series, I'm crossing threads.  That is, I'm
%finding transitions that should be in one series and assigning them to the
%other.  More dangerous, in real spectra these lines might be unresolved.
%Having the same line in more than one spectrum is not necessarily wrong!
ts = squarelist{1}.tightnesssettings;
numrounds = 0;
while extendingup
    newlist = {};
    %extendingup = 0;
    % thissquare = squarelist{i};
    for i = 1:length(squarelist)% cowcow have to keep the 'orphans' as well because later we go down
        s = squarelist{i};
        newguys = extendseriessquare(s,fs,hs,1);
        newlist = [newlist newguys];  %I could sort here into terminal and not terminal but this works
    end
    squarelist = sortcellarraybyfield(newlist,'netpval');

    updowns = extractfieldsfromcellarray(squarelist,{'upterminated','downterminated','degree','netpval'});
    %factor this part
    numrounds = numrounds+1;
    qualities = sort(updowns.netpval);
    numquality = length(find(qualities < ts.minpval));
    
    fprintf('after %d rounds, %d total,%d candidates with p < %3.1e\n',numrounds,length(squarelist),numquality,ts.minpval);
    if numquality > ts.maxscaffolds %cutoff best N. about 50?
        boggeddown = 1;
        squarelist = {};
        break
    end
    ups = updowns.upterminated;
    stilllive = find(ups == 0);
    %    disp(updowns.degree);
   % fprintf('%d series remain, degree %d => %d going up\n',length(updowns.degree),min(updowns.degree),max(updowns.degree));
    
    if length(stilllive) == 0
        break;
    end
 
end
degrees = updowns.degree;
for i = 1:15
    census(i) = length(find(degrees == i));
end
newsquarelist = squarelist;





function newsquares = extendseriessquare(s,allfs,allhs,upordown)
%if the squares can be extended, newsquares is a list of those extensions.
%currently assumes series 1 is complete.
newsquares = {};
    c1 = s.nextcolumn;
    r1 = s.nextrow;
    
    c2 = s.nextnextcolumn;
    r2 = s.nextnextrow;
    if c1 == 0
        s.upterminated = 1;
    end
if (s.upterminated == 1) && (upordown == 1)  %already terminated this guy
    newsquares{1} = s;
    return
end
newsquares = {};
if (s.downterminated == 1) && (upordown == 0)  %already terminated this guy
    newsquares{1} = s;
    return
end

%bpluscold = s.series1.fs(2) - s.series1.fs(1);
%bplusc = s.bpluscguess;
%fprintf('old guess %3.1f new guess %3.1f\n',bpluscold,bplusc);
newsquares = {};

rup = min(length(s.column1.fs),r1+1);
rdown = max(1,r1-1);
otherfs = [s.fgrid(r1,:)  s.fgrid(rup,:) s.fgrid(rdown,:)];
otherfs = otherfs(otherfs ~= 0);
energydiff = s.nextenergydiff;
% if ((c1 == 4)  && (c2 == 2)) || ((c1 == 1)  && (c2 == 3)) 
%     energydiff = s.energies(r1,1) - s.energies(r1,2);
%     if (s.energies(r1,1) == 0) || (s.energies(r1,2) == 0)
%         1;
%         error('energies below are not known');
%     end
% end
% if ((c1 == 4)  && (c2 == 3)) || ((c1 == 1)  && (c2 == 2)) 
%     energydiff = s.energies(r1+1,2) - s.energies(r1+1,1);
%     if (s.energies(r1+1,1) == 0) || (s.energies(r1+1,2) == 0)
%         1;
%         error('energies above are not known');
%     end
% end
% if c1 == 1
%     energydiff = -1 * energydiff;
% end
%this next line can be easily modified if there's a known ladder; it simply
%pulls known ladder(c1,r1).  
%it also should perhaps be moved.  It would be more elegant to at least
%predict in updateseriessquare.

%[nextseries1f nextseries1h ferr1 series1frange] = extendseriesbyone(s,c1,r1,allfs,allhs); %this is new f2
if s.laddermode == 0
    allowedf = find((allfs < s.nextmaxf) & (allfs > s.nextminf)); % & ((allfs < (s.fs(1)-mingap)) | (allfs > (s.fs(1)+mingap))));
    nextseries1f = allfs(allowedf);
    nextseries1h = allhs(allowedf);
else
    nextseries1f = s.ladderfs(r1,c1);
    nextseries1h = 1;
end
% oldf = mean(series1frange);
% newf = s.nextpredictf;
% if abs(newf - oldf) > 0.01;
%     
%     newf
%     oldf
%     1;
% end
%[nextseries2f nextseries2h ferr2 series2frange] = extendseriesbyone(s,c2,nextj,allfs,allhs); %this is new f2

% [nextseries2f nextseries2h ferr2 series2frange] = extendseriesbyone(s.series2,allfs,allhs,upordown,s); %this is new f3
% 
% [nextseries3f nextseries3h ferr series3frange] = extendseriesbyone(s.series3,allfs,allhs,upordown,s); %this is new f3
%n = length(s.column1.fs);
% if length(s.series1.realfs) < n
%     error('series 1 seems incomplete');
% end
% if upordown == 0
%     1;
% end
%targetnextj = nextj;
for ii = 1:length(nextseries1f) 
    nextj = r1;
%    for jj = 1:length(nextseries2f)
%    highenough = 0;

    f1 = nextseries1f(ii);
%      f2 = nextseries2f(ii);
    fneeded = f1 - energydiff;

    %fdiff = f1 - f2;

    h1 = nextseries1h(ii);
    %h2 = nextseries2h(jj);

    if (h1 > s.aheight/s.tightnesssettings.seriesaratio) % && (h2 > bheight/8)
        if s.laddermode == 0
            [minval ival] = closest(fneeded,allfs);
            h2 = allhs(ival);
            f2 = allfs(ival);
        else
            f2 = s.ladderfs(r2,c2);
            h2 = 1;
        end
        ferror = abs(f2 - fneeded);
        if (ferror < s.tightnesssettings.seriessquarefthresh) && (h2 > s.bheight/s.tightnesssettings.seriesbratio) && (min(diff(sort([f1 f2 otherfs ]))) > 0.1)
            1;
            news = s;%no more adding rows! addrows(s,addrowabove,addrowbelow);
%             if addrowbelow
%                 nextj = targetnextj+1;
%                 1;
%             end
            switch c1
                case 1
                    news.column1.fs(r1) = f1;
                    news.column1.hs(r1) = h1;
                case 4
                    news.column4.fs(r1) = f1;
                    news.column4.hs(r1) = h1;
            end
            switch c2
                case 2
                    
                    news.column2.fs(r2) = f2;
                    news.column2.hs(r2) = h2;
                case 3
                    news.column3.fs(r2) = f2;
                    news.column3.hs(r2) = h2;
            end
            news.allpredicts(r2,c2) = fneeded;
            news.listpredicts(s.nextline) = fneeded;
            news = updateseriessquare(news);
%             if containsf(news,3000) == 0
%                 1;
%             end
            if news.isoutlawed == 0
            %check to see if its legal?
                newsquares{end+1} = news;
            else
             %   news.fgrid
                1;
            end
              
        end
    end
end
%if length(newsquares) == 0  %no extensions.  mark original as terminal and hand back
if upordown == 1
    s.upterminated = 1;
end
if upordown == 0
    s.downterminated = 1;
end
s = updateseriessquare(s);
newsquares{end+1} = s;


function [minval ival] = closest(f,allfs)
allfs = abs(allfs-f);
[minval ival] = min(allfs);