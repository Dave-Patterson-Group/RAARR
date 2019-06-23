function plotprimaryseries(kit,ownfigure)

if nargin < 2
    ownfigure = 1;
end
%s = kit.allseries{1};
if ownfigure
    figure('Name',kit.cheat.molstring,'Position',[74          95        1013         843]);
    subplot(5,2,[1 3 5 7]);
end
hold all;
plotscaffold(kit);
subplot(5,2,[9 10]);
plotoneaseries(kit);




