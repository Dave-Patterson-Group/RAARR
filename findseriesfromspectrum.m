function kit = findseriesfromspectrum(kit)
format short;
% seriesi = kit.allseries{kit.ichoice};
% seriesj = kit.allseries{kit.jchoice};
% p1 = stickplot(seriesi.fs,seriesi.hs,'b'); 
% hold all;
% 
% p2 = stickplot(seriesj.fs,seriesj.hs,'m');
% 
% stickplot(kit.onedpeakfs,kit.onedpeakhs,'k');
ts = seriessettingsfromtightness(1);

linestouse = kit.forcef1;
allseries = {};
kit.minf = min(kit.onedpeakfs);
kit.maxf = max(kit.onedpeakfs);
kit.frange = kit.maxf - kit.minf;

for ll = linestouse
    [fstart hstart istart rank] = pickfirstf(kit,ll);
    fprintf('%s: jumping in, rank %d, height %3.1f tightness %3.1f\n',kit.molname,rank,hstart,ts.scalartightness);

    
    fs = kit.onedpeakfs;
    hs = kit.onedpeakhs;
    counttool = makecounttool(hs);
    kit.counttool = counttool;
    hthresh = hstart/ts.fullseriesratio;
    
    frange = max(fs) - min(fs);
    midf = mean([max(fs) min(fs)]);
%     gapmax = frange / 3;
%     gapmin = gapmax / 4;
    
    highenough = find(hs > hthresh);
    fs = fs(highenough);
    hs = hs(highenough);

    alls = {};
    
    firstline = fstart;
    firstheight = hstart;
    minjj = find(fs > (firstline + ts.gapmin),1,'first');
    maxjj = find(fs > (firstline + ts.gapmax),1,'first');
    f2options = minjj:maxjj;
    if isfield(kit,'forcef2') && kit.forcef2(1) > 0
        f2options = [];
        for i = 1:length(kit.forcef2)
            f = kit.forcef2(i);
            if (firstline + ts.gapmin < f) &&  (firstline + ts.gapmax > f)
                ferrs = abs(fs - kit.forcef2(i));
                f2options(end+1) = find(ferrs == min(ferrs),1,'first');
            end
        end
    end
    for jj = f2options
        secondline = fs(jj);
        secondheight = hs(jj);
        
        if (secondheight > (firstheight / ts.babytolerance))
            babyseries.fs = [fstart secondline];
            babyseries.hs = [hstart secondheight];
            babyseries.frange = frange;
            babyseries.midf = midf;
            babyseries.ts = ts;
            babyseries.counttool = counttool;
            babyseries.firstf = fstart;
            babyseries.firsth = hstart;
            babyseries.firstrank = rank;
            babyseries.originstring =  sprintf('origin f = %3.2f,rank %d, height %3.1f t %3.1f\n',fstart,rank,hstart,ts.scalartightness);
            babyseries.whichcolumn = 1;
            babyseries.lowsidetolerance = ts.atolerance*1;
            babyseries.lowjthresh = ts.lowjthresh;
            1;
%             babyseries.numlines = 2;
%             babyseries.terminal = 0;
%             babyseries.psofar = 1;
%             babyseries.pstring = 'babyp!';
%             babyseries.babystring = sprintf('searching on %d, %d: %3.1f %3.1f\n',ii,jj,fs(ii),fs(jj));
            alls{end+1} = updateplainseries(babyseries);
            %          newseriesset = extendseries(babyseries,fs,hs);
            1;
            
            
        end
    end
    
    alls = extendseriesalltheway(alls,fs,hs);
    for i = 1:length(alls)
        if alls{i}.numlines >= ts.minserieslength
            allseries{end+1} = alls{i};
        end
    end
end
allseries = sortcellarraybyfield(allseries,'pval','ascend');
oldlength = length(allseries);
allseries = uniqueseries(allseries);
newlength = length(allseries);
fprintf('uniqueseries reduced list from %d to %d\n',oldlength,newlength);
kit.allseries = sortcellarraybyfield(allseries,'pval','ascend');
    

function newseries = uniqueseries(allseries)
newseries = {};
for i = 1:length(allseries)
    seemsnew = 1;
    thisseries = allseries{i};

    for k = 1:length(newseries)
        
        thatseries = newseries{k};
        allfs = [thisseries.realfs thatseries.realfs];
        series1length = length(thisseries.realfs);
        series2length = length(thatseries.realfs);
        longerlength = max([series1length series2length]);
        if length(unique(allfs)) <= longerlength %series1 is subset of series2 or vice versa
            seemsnew = 0;
        end
    end
    if seemsnew
      
        newseries{end+1} = thisseries;

    end
end


    
function [newserieslist boggeddown] = extendseriesalltheway(alls,fs,hs)
    
    %very much inherited ffrom extendseriessquarealltheway
    
    boggeddown = 0;
newserieslist = alls;
fprintf('%d starting\n',length(alls));
if length(alls) == 0
    return
end
extending = 1;

while extending
    newlist = {};
    for i = 1:length(alls)%
        s = alls{i};
        newguys = extendplainseries(s,fs,hs);
        newlist = [newlist newguys];  %I could sort here into terminal and not terminal but this works
    end
   % disp(length(newlist));
    alls = newlist;  

    updowns = extractfieldsfromcellarray(alls,{'closedout','numlines','pval'});
    closed = updowns.closedout;
    numlines = updowns.numlines;
    bestpval = min(updowns.pval);
    stilllive = find(closed == 0);
   fprintf('%d still alive, lengths %d-%d, best p %3.1g\n',length(stilllive),min(numlines),max(numlines),bestpval);
    if length(stilllive) == 0
        break;
    end

end

newserieslist = alls;



    
        function [allagree numagree] = agreement(s1,s2,thresh)
            allagree = 0;
            allf = sort([s1 s2]);
            difff = diff(allf);
            numagree = length(find(difff < thresh));
            minlength = min(length(s1),length(s2));
            if minlength == numagree
                allagree = 1;
            end

