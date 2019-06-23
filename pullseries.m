function series = pullseries(pairlist,firstpair,visiblewindow)
if nargin  < 3
    visiblewindow = [10000 19000];
end



   % firstpair = pullpairb(pairlist,11,0,11,10,1,10);
 %   firstpair = pullpairb(pairlist,11,0,11,10,1,10);
    pairseries{1} = firstpair;
    lastpair = firstpair;
    while 1
        lastpair = pullnextpair(pairlist,lastpair,0);
        if isstruct(lastpair) == 0
            break
        end
        pairseries{end+1} = lastpair;
    end
    lastpair = firstpair;
    while 1
        lastpair = pullnextpair(pairlist,lastpair,1);
        if isstruct(lastpair) == 0
            break
        end
        pairseries{end+1} = lastpair;
    end
        
    1;
    fields = extractfieldsfromcellarray(pairlist,{'sixKweakpulsestrength'});
    
    spectrummax = max(fields.sixKweakpulsestrength);
    
    pairseries = selectpairs(pairseries,0,1000,'startj',0);
    fields = extractfieldsfromcellarray(pairseries,{'delfMHZ','sixKweakpulsestrength','semifreq'});
    series.fs = fields.delfMHZ;
    series.hs = fields.sixKweakpulsestrength;
    series.classicalf = fields.semifreq;
    series.spectrummax = spectrummax;
    series.numlines = length(series.fs);
    series.bpluscguess = mean(diff(series.fs));
    series.secondordererror = mean(diff(diff(series.fs)));
    series.largestbend = max(abs(diff(diff(series.fs))));
    series.smallestgap = min(abs(diff(series.fs)));
    series.mingapoverbend = series.smallestgap / series.largestbend;
    series.allordererrors = alldiffs(series.fs);
    series.meanh = mean(series.hs);
    series.alljguess = series.fs(1:end-1) ./ (series.fs(2:end) - series.fs(1:end-1));
    n = 3;
    errors = [];
    predicts = [];
    % allx = linspace(1,8,100);
 
%     format short;
%     v = alldiffs(fs);
%     disp(v(2:end));
%     disp(errors);
%     bplusc = p(end-1);
%     bplusc
    
    cheat.pairseries = pairseries;
    cheat.lowestpair = pairseries{1};
    cheat.descriptor = cheat.lowestpair.shortdescription;
    fulldescription = sprintf('%d line series taylor series %s\n',series.numlines,num2str(series.allordererrors,2));
    jvalues = zeros(1,series.numlines);
    for i = 1:series.numlines
    
        thisline = pairseries{i};
        fulldescription = sprintf('%s%3.1f,%s\n',fulldescription,series.fs(i),thisline.shortdescription);
        jvalues(i) = thisline.endj;
    end
    cheat.fulldescription = fulldescription;
    series.cheat = cheat;
    series.jvalues = jvalues;
    series = addseriesvisbles(series,visiblewindow,1.0);
   
    series.bpluscguess = mean(diff(series.visiblefs));
    
    
   
    
    function v = alldiffs(fs)
        v = [];
        while(length(fs) > 1)
            fs = diff(fs);
            v(end+1) = mean(sqrt(fs.^2));
        end
    
    