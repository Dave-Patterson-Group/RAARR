function liahundreds

figure('Position',[2054         111        1324         815]);
legs = {};
%avals = linspace(1800,8000,25);
cvals = rand(100,1)*(1200-400) + 400;
for i = 1:length(cvals)
    try
        themol = loadmol('test4');
        themol.a = 5000;
        themol.b = 2500 - cvals(i);
        themol.c = cvals(i);
        
        themol = updatemolstats(themol);
        kit = presentaseriesladder(themol,0,0);
        plotseriesc(kit.series1,'b');
        plotseriesc(kit.series4,'k');
        legs{end+1} = themol.descriptor;
        pause(0.001);
        legend(legs);
    end
end

1;

