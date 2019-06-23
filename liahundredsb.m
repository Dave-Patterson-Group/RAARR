function liahundreds

figure('Position',[2054         111        1324         815]);
legs = {};
%avals = linspace(1800,8000,25);
% avals = rand(100,1)*(4000) + 2000;
% bvals = rand(100,1)*(2000) + 800;
% cvals = rand(100,1)*(2000) + 400;

numfound = 0;
while numfound < 15
    try
        themol = loadmol('test4');
        themol.a = rand()*(4000) + 2000;
        themol.b = rand()*(2000) + 800;
        themol.c = rand()*(2000) + 400;
        
        themol = updatemolstats(themol);
        numfound = numfound+1;
        kit = presentaseriesladder(themol,1,0);
%         plotseriesc(kit.series1,'b');
%         plotseriesc(kit.series4,'k');
%         legs{end+1} = themol.descriptor;
%         pause(0.001);
%         legend(legs);
    end
end

1;

