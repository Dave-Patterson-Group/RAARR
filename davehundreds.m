function davehundreds

figure('Position',[2054         111        1324         815]);
legs = {};
avals = linspace(3000,8000,4);
%cvals = rand(100,1)*(1200-400) + 400;
for i = 1:length(avals)
    try
        themol = loadmol('test2');
        themol.a = avals(i);

        
        themol = updatemolstats(themol);
        kit = presentaseriesladder(themol,1,1);

    end
end

for i = 1:length(avals)
    try
        themol = loadmol('test2');
        themol.a = avals(i);
        themol.b = 2000;
        
        themol = updatemolstats(themol);
        kit = presentaseriesladder(themol,0,1);

    end
end

1;

