function molstats = updatemolstats(molstats)
molstats.ABC = [molstats.a molstats.b molstats.c];
molstats.rays = ((2 * molstats.b) - molstats.a - molstats.c) / (molstats.a - molstats.c);
molstats.descriptor = [molstats.molname ': ' num2str(molstats.ABC)];
if isfield(molstats,'shortname') == 0
    molstats.shortname = molstats.molname;
end
molstats.asymm = ((2 * molstats.b) - molstats.a - molstats.c) / (molstats.a - molstats.c);
  i3 = 1.0 / molstats.c;
    i2 = 1.0 /  molstats.b;
    i1 = 1.0 /  molstats.a;
    
  %  if i3 > (i1 + i2)
        molstats.massdefect = (i1 + i2) - i3;
  %  end
    if (molstats.a < molstats.b) || (molstats.b < molstats.c)
        molstats;
        error('illegal molecule! A B C out of order');
    end
    if molstats.massdefect < 0
        molstats;
        error('illegal molecule! Mass defect negative');
    end
    