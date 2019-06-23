function fit = addHeights(fit,kit)
if nargin == 2
    save('tfile2','fit','kit')
else
    load('tfile2','fit','kit');
end

for i = 1:length(fit.lines)
    thisline = fit.lines{i};
    thisf = thisline.expf;
    ferrors = abs(thisf - kit.onedpeakfs);
    besti = find(ferrors == min(ferrors),1);
    thish = kit.onedpeakhs(besti);
    thisline.exph = thish;
    fit.lines{i} = thisline;
end