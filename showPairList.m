function showPairList(pairList,n)
if nargin == 1
    n = Inf;
end
n = min(length(pairList),n);
for i = 1:n
    fprintf('grid %d/%d: ==================\n%s\n',i,length(pairList),pairList{i}.fullString);
end


