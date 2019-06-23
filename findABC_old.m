function smartABCs = findABC_old(fgrid)
if isstruct(fgrid)
    fgrid = s.fgrid;
end
n = 0;
for i = 1:length(fgrid(:,1))
    if (fgrid(i,1) > 0) && (fgrid(i,4) > 0)
        n = i;
        break
    end
end
if n == 0
    smartABCs = {[2000 500 400],[1000 500 400] };
else
    a1j = fgrid(n+1,1)/(fgrid(n+1,1) - fgrid(n,1));
    f1f4 = fgrid(n+1,1) - fgrid(n+1,4);
    bplusc = fgrid(n+1,1)/a1j;
    bminusc = abs((f1f4/a1j));
    B = (bplusc + bminusc)/2;
    C = (bplusc) - B;
    A = 4 * bplusc;
    smartABCs = {[A B C],[A/2 B C]};
end


