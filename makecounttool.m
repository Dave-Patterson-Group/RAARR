function counttool = makecounttool(hs)
    hs = sort(hs,'descend');
    counttool.minh = min(hs);
    counttool.maxh = max(hs);
    counttool.hvalues = linspace(counttool.minh,counttool.maxh,50);
    counttool.countvalues = counttool.hvalues * 0;
    for i = 1:length(counttool.hvalues)
        thish = counttool.hvalues(i);
        counttool.countvalues(i) = find(hs >= thish,1,'last');
    end

