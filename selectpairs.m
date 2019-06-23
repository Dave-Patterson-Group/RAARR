function newlist = selectpairs(pairlist,minf,maxf,figureofmerit,downwards)

if nargin == 0
    pairlist = findallpairs();
end
if nargin < 4
    figureofmerit = 'sixKweakpulsestrength';
end
if nargin < 5
    downwards = 1;
end
numpairs = length(pairlist);

whichi = [];
foms = [];
for i = 1:numpairs
    thispair = pairlist{i};
    f = thispair.delf;
    if (f >= minf) && (f <= maxf)
        foms(end+1) = getfield(thispair,figureofmerit);
        whichi(end+1) = i;
    end
    %disp(thispair.description);
end
if downwards
    [f xi] = sort(foms,'descend');
else
    [f xi] = sort(foms,'ascend');
end
newlist = {};

for i = 1:length(xi)
    thisi = whichi(xi(i));
    thispair = pairlist{thisi};
	newlist{end+1} = thispair;
    %disp(thispair);
end

