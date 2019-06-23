function states = findallstates(Jmax, Kamax, Kcmax)

states = {};

for i = 1:Jmax
    Kahigh = min(i,Kamax);
    for m = 0:Kahigh
       Kclow = i - m;
       Kchigh = min(Kclow + 1, Kcmax);
       Kchigh = min(Kchigh, i);
       for n = Kclow:Kchigh
            
            thisstate.j = i;
            thisstate.ka = m;
            thisstate.kc = n;
            thisstate.i = thisstate.j * 1e4 + thisstate.ka * 1e2 + thisstate.kc * 1e0;
            thisstate.m = 0; %following format...never used
            states{end + 1} = thisstate; 
       end
    end
end

end