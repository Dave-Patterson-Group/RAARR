function kit = addfittokit(kit,fit)
if isstruct(fit) == 0
    return
end
if nargin < 3
    n = length(kit.fitlist) + 1;
end

switch mod(n,6)
    case 0
        fit.color = 'r';
    case 1
        fit.color = 'b';
    case 2
        fit.color = 'm';
    case 3
        fit.color = 'c';
    case 4
        fit.color = 'g';
    case 5
        fit.color = 'k';    
    otherwise
        fit.color = 'k';
end
kit.fitlist{n} = fit;
kit.numspecies = length(kit.fitlist);
kit.latestfit = fit;
kit.numvotes = fit.yesvotes;

kit.whichspecies(fit.hitis) = n;
ulines = find(kit.whichspecies == 0);
kit.onedpeakfsunassigned = kit.onedpeakfs(ulines);
kit.onedpeakhsunassigned = kit.onedpeakhs(ulines);
kit.fitlistreport = makefitlistreport(kit);
kit.finalfit = kit.fitlist{1};
if isfield(fit,'isotopes')
    for i = 1:length(fit.isotopes)
        thisisotope = fit.isotopes{i};
        kit = addfittokit(kit,thisisotope);
    end
end
%displayspfit(finalfit,kit);
%1;

