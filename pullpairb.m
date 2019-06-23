function newpair = pullpairb(pairlist,startj,startka,startkc,endj,endka,endkc)
newpair = 0;
if nargin == 2
    s = startj;
    startj = s.startj;
    startka = s.startka;
    startkc = s.startkc;
    endj = s.endj;
    endka = s.endka;
    endkc = s.endkc;
end

for i = 1:length(pairlist)
    thispair = pairlist{i};
    %tf = thispair.delf;
    if (thispair.startj == startj) && ...
         (thispair.startka == startka) && ...   
         (thispair.startkc == startkc) && ...
         (thispair.endj == endj) && ...
         (thispair.endka == endka) && ...
         (thispair.endkc == endkc) 
         newpair = thispair;
    end
    %disp(thispair.description);
end

