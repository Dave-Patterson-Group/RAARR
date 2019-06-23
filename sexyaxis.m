function sexyaxis
a = xlim;

minf = a(1);
maxf = a(2);
possibles = (1:50) * 2000;
if (maxf - minf) < 8000
    possibles = possibles/2;
end
ticks = [];
labels = {};
for i = 1:length(possibles)
    if (possibles(i) >= minf) && (possibles(i) <= maxf)
        ticks(end+1) = possibles(i);
        labels{end+1} = sprintf('%d',possibles(i));
    end
end
xticks(ticks);
xticklabels(labels);
