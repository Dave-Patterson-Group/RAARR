function suggestlist = findbestpairs(pairlist)
numpairs = length(pairlist);
minf = 11.5;
maxf = 19;
numsuggest = 4;

freqs = [];
amps = [];
fom = [];
suggestlist = {};
for i = 1:numpairs
    thispair = pairlist{i};
    freqs(i) = thispair.delf;
    amps(i) = thispair.transmoment;
    fom(i) = -thispair.transmoment * (thispair.starterstate.j+1) * thispair.delf;
    if (thispair.delf < minf) || (thispair.delf > maxf)
        fom(i) = 0;
    end
    %disp(thispair.description);
end

[sortfom whichi] = sort(fom);
numposs = find(sortfom == 0,1,'first');
numposs = numposs - 1;

numsuggest = min([numposs numsuggest]);
for (i = 1:numsuggest)
    thisi = whichi(i);
    thispair = pairlist{thisi};
    suggestlist{i} = thispair;
    disp(thispair.description);
    fprintf('frequency %3.5f\n',thispair.delf);
end
% stickplot(freqs,amps,'b');
% ylabel('trad amplitude');
