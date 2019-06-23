function thisline = updateline(thisline)
if isfield(thisline,'Jlower') == 0 && isfield(thisline,'endj') == 1
    thisline.Jlower = thisline.endj;
    thisline.Kalower = thisline.endka;
    thisline.Kclower = thisline.endkc;
    thisline.Jupper = thisline.startj;
    thisline.Kaupper = thisline.startka;
    thisline.Kcupper = thisline.startkc;
end
thisline.lowerhash = (thisline.Jlower * 1e4) + (thisline.Kalower * 1e2) + (thisline.Kclower);
thisline.upperhash = (thisline.Jupper * 1e4) + (thisline.Kaupper * 1e2) + (thisline.Kcupper);
thisline.hash = thisline.lowerhash + (1e6 * thisline.upperhash);
if isfield(thisline,'expfreq')
    thisline.descriptor = sprintf('%d->%d %f',thisline.upperhash,thisline.lowerhash,thisline.expfreq);
else
    thisline.descriptor = sprintf('%d->%d no experiment',thisline.upperhash,thisline.lowerhash);
end
    
