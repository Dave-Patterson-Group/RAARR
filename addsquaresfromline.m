function kit = addsquaresfromline(kit,linetouse)

    f1 = pickfirstf(kit,linetouse);
    [newsquares,searchreport] = squaresfromline(kit,linetouse);        

  %  minpval = min(extractonefieldfromcellarray(newsquares,'netpval'));

    kit.searchedf1s(end+1) = f1;
    if searchreport.bogged == 0
        kit = addtrialsquarestokit(kit,newsquares);
        kit.totalflatsquares = kit.totalflatsquares + searchreport.numflatsquares;
        kit.totalCensus = kit.totalCensus + searchreport.census;
    end

     function newScoffoldList = sortScaffolds(candidateScaffolds)
    newScoffoldList = {};
    hashesUsed = [];
    candidateScaffolds = sortcellarraybyfield(candidateScaffolds,'netpval','ascend');
    for i = 1:length(candidateScaffolds)
        thisScaffold = candidateScaffolds{i};
        thisHash = thisScaffold.gridhash;
        if ismember(thisHash,hashesUsed) == 0
            newScoffoldList{end+1} = thisScaffold;
            hashesUsed(end+1) = thisHash;
        end
    end
    
  function kit = addtrialsquarestokit(kit,newsquares)  %should edit to simply return newsquares, not pack them into kit.
    if length(newsquares) > 0
        newsquares = sortcellarraybyfield(newsquares,'netpval','ascend');
        numsquares = min(kit.tightnesssettings.maxsquaresfromline,length(newsquares));
        for i = 1:numsquares
            thissquare = newsquares{i};
            kit.candidateScaffolds{end+1} = thissquare;
        end %now sort 
        kit.candidateScaffolds = sortScaffolds(kit.candidateScaffolds);
    end
    if length(kit.candidateScaffolds) == 0
        kit.bestScaffoldp = 1;
    else
        kit.bestScaffoldp = kit.candidateScaffolds{1}.netpval;
    end
        
function [finalsquares,searchReport] = squaresfromline(kit,linetouse)

ts = kit.tightnesssettings;
ts.starttime = now;

searchReport.bogged = 0;
searchReport.numflatsquares = 0;

   finalsquares = {};
  

    
    [allsquares,kit] = getflatsquares(kit,linetouse,ts);
    fs = kit.usefs;
    hs = kit.usehs;
    seriessquares = {};
    
    searchReport.numflatsquares = length(allsquares);
    for i = 1:length(allsquares)
        seriessquares{end+1} = seriessquarefromflatsquare(allsquares{i},0);
        if seriessquares{end}.dtype && kit.Dinverted 
            seriessquares{end+1} = seriessquarefromflatsquare(allsquares{i},1);
        end
        
    end
    
    if length(seriessquares) > ts.flatsquarelimit
        fprintf('%d is far too many flatsquares\n',length(seriessquares));
        searchReport.bogged = 1;
        return
    end

    if linetouse > 5000 %force f1
        if length(seriessquares) < 3
            for i = 1:length(seriessquares)
                disp(seriessquares{i}.bestfstring);
                showseriessquare(seriessquares{i},kit);
                1;
            end
        end
        1;
    end
    
    1;
%  seriessquares = {seriessquares{2}};
    [seriessquares,bogged,census] = extendseriessquarealltheway(seriessquares,fs,hs);
    searchReport.census = census;
    if bogged == 1
        searchReport.bogged = 1;
        return
    end

    allps = extractfieldsfromcellarray(seriessquares,{'netpval','testable'});
    alltests = allps.testable;
    allps = allps.netpval;
    

    
    for i = 1:length(seriessquares)
        s = seriessquares{i};

        if s.testable == 1 %s.netpval < ts.minpval  %more tightness
            numps = length(find(alltests == 1));
            if s.netpval == min(allps)
                fprintf('adding %d squares from %3.1f of degree %d, pval %3.2e\n',numps,s.originalf1,s.degree,s.netpval);
            end
            finalsquares{end+1} = s;
        end
    end
    finalsquares = sortcellarraybyfield(finalsquares,'netpval','ascend');
    if ts.trimends
        finalsquares = trimends(finalsquares);
    end
    finalsquares = removeidentical(finalsquares);

function yesorno = identicalseries(s1,s2)
yesorno = 1;
if (length(s1.fgrid(:,1)) ~= length(s2.fgrid(:,1)))
    yesorno = 0;
    return
end

function newlist = removeidentical(slist)
    newlist = {};
    for i = 1:length(slist)
        isindy = 1;
        for j = 1:length(newlist)
            if identicalseries(slist{i},newlist{j})
                isindy = 0;
            end
        end
        if isindy
            sortfs = sort(slist{i}.allfs);
            if min(diff(sortfs)) > 0.01
                
                newlist{end+1} = slist{i};
            end
        end
        
    end
