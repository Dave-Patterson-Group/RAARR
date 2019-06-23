function kit = selectlines(kit)
1;
fitfreqs = kit.squares{kit.squarei}.fs;

for i = 1:length(fitfreqs)
    thisf = fitfreqs(i);
    ferrors = abs(kit.onedpeakfs - thisf);
    besti = find(ferrors == min(ferrors),1,'first');
    fitis(i) = besti;
    fiths(i) = kit.onedpeakhs(besti);
end
strengththresh = min(fiths) * 0.3;
stronglines = find(kit.onedpeakhs > strengththresh);
kit.usefs = kit.onedpeakfs(stronglines);
kit.usehs = kit.onedpeakhs(stronglines);
kit.strengththresh = strengththresh;