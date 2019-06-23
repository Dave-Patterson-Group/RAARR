function newmol = randomizemolecule(oldmol,howmuch,negit,rngseed)
if nargin < 3
    negit = 0;
end
if nargin >= 4
    rng(rngseed);
end
newmol = oldmol;
if howmuch == 0
    newmol.molname = sprintf ('%s [%3.1f %3.1f %3.1f] original',newmol.molname,newmol.a,newmol.b,newmol.c);
    return
end
islegal = 0;
while islegal == 0
    rands = rand(1,3) - 0.5;
    if negit
        rands = rands - 0.5;
    end
    rands = 1 + (rands * howmuch);
    oldabc = [oldmol.a oldmol.b oldmol.c];
    newabc = oldabc .* rands;
    islegal = 1;
    if (newabc(2) > newabc(1)) || (newabc(3) > newabc(2))
        islegal = 0;
    end
    
    i3 = 1.0 / newabc(3);
    i2 = 1.0 / newabc(2);
    i1 = 1.0 / newabc(1);
    
    if i3 > (i1 + i2)
        islegal = 0;
    end
end
newmol.a = newabc(1);
newmol.b = newabc(2);
newmol.c = newabc(3);
if howmuch == 0
    newmol.molname = sprintf ('%s [%3.1f %3.1f %3.1f] original',newmol.molname,newabc(1),newabc(2),newabc(3));
else
    newmol.molname = sprintf ('%s [%3.1f %3.1f %3.1f]',newmol.molname,newabc(1),newabc(2),newabc(3));
end
newmol = updatemolstats(newmol);

