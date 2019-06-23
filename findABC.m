function smartABCs = findABC(fgrid,ka)
%assumes ka = 0;
smartABCs = {};
%load('qfile');
if isstruct(fgrid)
    fgrid = s.fgrid;
end

f1freqs = nonzeros(fgrid(:,4))';
f0freqs = nonzeros(fgrid(:,1))';

if (length(f1freqs) >= 2) && (length(f0freqs) > 0)
  
    [k,residuals,f1predicts,f0predicts,J1,J0,exitFlag] = fitf1f0(f1freqs,f0freqs,ka);
    if exitFlag < 0
        return
    end
    C = k(1)/2;
    B = C + 2*(k(2)/k(3));
    a = (1/C) - (1/B);
    Amax = 1/a;
    
    %Amin = B + (B-C);
    
    Avals= [B + (B-C), (B+C), 2*(B+C), 0.8*Amax]; %shaky but have to do something..
    
    for i = 1:length(Avals)
        smartABCs{i} = [Avals(i),B,C];
    end
else
    smartABCs = findABC_old(fgrid);
end