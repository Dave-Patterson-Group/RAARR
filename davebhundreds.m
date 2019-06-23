function davebhundreds

figure('Position',[2054         111        1324         815]);
legs = {};
bvals = [1540 1600 1800 2200];
%cvals = rand(100,1)*(1200-400) + 400;
for i = 1:length(bvals)
    try
        themol  = molstatsfromwhatever([4000 2000 1500]);
        themol.b = bvals(i);
        themol = updatemolstats(themol);
        
   %     themol = updatemolstats(themol);
        kit = presentbseriesladder(themol,0,1);

    end
end

% for i = 1:length(avals)
%     try
%         themol = loadmol('test2');
%         themol.a = avals(i);
%         themol.b = 2000;
%         
%         themol = updatemolstats(themol);
%         kit = presentaseriesladder(themol,0,1);
% 
%     end
% end

1;

