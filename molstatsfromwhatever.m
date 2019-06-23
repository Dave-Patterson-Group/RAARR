function thismol = molstatsfromwhatever(molname)
if isstruct(molname)
    thismol = molname;
    return
end
if ischar(molname)
    thismol = loadmol(molname);
    thismol.molname =  sprintf ('%s [%3.1f %3.1f %3.1f]',molname,thismol.a,thismol.b,thismol.c);
    return
end
    thismol = loadmol('menthone1');
    thismol.a = molname(1);
    thismol.b = molname(2);
    thismol.c = molname(3);
    thismol.fakemolname = sprintf ('fiction [%3.1f %3.1f %3.1f]',molname(1),molname(2),molname(3));
    
    if (length(molname) >= 8) && (molname(4) ~= 0)
        thismol.fakemolname = sprintf ('fiction [%3.1f %3.1f %3.1f] CD',molname(1),molname(2),molname(3));
        thismol.DJ = molname(4);
        thismol.DJK = molname(5);
        thismol.DK = molname(6);
        thismol.deltaJ = molname(7);
        thismol.deltaK = molname(8);
    end
    thismol.molname = thismol.fakemolname;
    1;



