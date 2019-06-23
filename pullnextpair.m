function newpair = pullnextpair(pairlist,pair,upordown)
newpair = 0;

nextpair = pair;
delj = pair.endj - pair.startj;
delka = pair.endka - pair.startka;
delkc = pair.endkc - pair.startkc;
if upordown == 1
    s.endj = pair.endj + 1;
    s.endka = pair.endka;
    s.endkc = pair.endkc + 1;
    s.startj = pair.startj + 1;
    s.startka = pair.startka;
    s.startkc = pair.startkc +1;
else
    s.endj = pair.endj - 1;
    s.endka = pair.endka;
    s.endkc = pair.endkc - 1;
    s.startj = pair.startj - 1;
    s.startka = pair.startka;
    s.startkc = pair.startkc -1;
end

newpair = pullpairb(pairlist,s);

