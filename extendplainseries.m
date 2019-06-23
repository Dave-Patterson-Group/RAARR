function newseries = extendplainseries(s,allfs,allhs)
newseries = {};

    r1 = s.nextrow;
    s.tried(r1) = 1;
%otherfs = s.realfs;


    allowedf = find((allfs < s.nextmaxf) & (allfs > s.nextminf)); % & ((allfs < (s.fs(1)-mingap)) | (allfs > (s.fs(1)+mingap))));
    nextseriesf = allfs(allowedf);
    nextseriesh = allhs(allowedf);

    hthresh = mean(s.realhs) / s.ts.seriesaratio;
for ii = 1:length(nextseriesf) 

    f1 = nextseriesf(ii);

    h1 = nextseriesh(ii);
    %h2 = nextseries2h(jj);

    if (h1 > hthresh) % && (h2 > bheight/8)
        
       news = s;%no more adding rows! addrows(s,addrowabove,addrowbelow);
       news.fs(r1) = f1;
       news.hs(r1) = h1;
%        
%             news.allpredicts(r2,c2) = fneeded;
%             news.listpredicts(s.nextline) = fneeded;
        news = updateplainseries(news);
%             if containsf(news,3000) == 0
%                 1;
%             end
        if news.outlawed == 0
        %check to see if its legal?
            newseries{end+1} = news;
        else
         %   news.fgrid
            1;
        end
              
        
    end
end
if length(newseries) == 0  %no extensions.  mark original as terminal and hand back

    %s = updateseriessquare(s);
    newseries{end+1} = updateplainseries(s);
end


