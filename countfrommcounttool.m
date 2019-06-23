function count = countfrommcounttool(counttool,h)
%typical use is:
% for h = s.allhs
%     linecount = countfrommcounttool(s.counttool,h);
%     s.pvalprefactor = s.pvalprefactor * (linecount * 1.5);
% end

if isstruct(counttool) == 0
    count = 1;
    return
end
if h < min(counttool.hvalues)
    h = min(counttool.hvalues);
end
count = interp1(counttool.hvalues,counttool.countvalues,h);
