function [finalSeriesList,alltriedthistime] = extendAllf1Series(thisSeriesList,babyKit)
global ALLEVERTRIED

thisSeriesList = findUniqueSeriesPairs(thisSeriesList);
%[thisSeriesList] = findNewSeriesPairs(thisSeriesList,alltried); 
alltriedthistime = containers.Map(0,0);

if length(thisSeriesList) > 0
    if thisSeriesList{1}.searchf0 == 0
        fprintf('Extending %d baby series 4s\n',length(thisSeriesList));
    else
        fprintf('Extending %d series 4s into series 1-4s\n',length(thisSeriesList));
    end
end
if babyKit.ts.verbose == 1
    displaySeries(thisSeriesList,babyKit.cheatCodes);
end
    
stillGrowing = 1;
numrounds = 0;
finalSeriesList = {};
while stillGrowing
    numrounds = numrounds+1;
    [thisSeriesList] = findNewSeriesPairs(thisSeriesList,ALLEVERTRIED); %finds new AND marks them as tried

    
    listhashes = extractonefieldfromcellarray(thisSeriesList,'hashInt');
    for i = listhashes
        alltriedthistime(i) = 1;
    end
    [thisSeriesList,stillGrowing] = extendf1SeriesListByOne(thisSeriesList,babyKit);
    
    thisSeriesList = findUniqueSeriesPairs(thisSeriesList);  %also sorts.
    %now, find items which have never been tried
%    [thisSeriesList, alltried] = markKnownSeriesPairs(thisSeriesList,alltried); 
    
    if length(thisSeriesList) == 0
        fprintf('after %d rounds, none left\n');
        break;
    end
  %  thisSeriesList = sortcellarraybyfield(thisSeriesList,'pval');
    a = extractfieldsfromcellarray(thisSeriesList,{'closedOut','pval','totalLines'});
    closeouts = a.closedOut;
    lengths = a.totalLines;
    pvals = a.pval;
    if length(find(closeouts == 0)) == 0
        stillGrowing = 0;
    end
    fprintf('after %d rounds, %d survivors,length %d-%d, best p %3.1e\n',numrounds, length(thisSeriesList),min(lengths),max(lengths),min(pvals));
    if babyKit.ts.verbose == 1
        displaySeries(thisSeriesList,babyKit.cheatCodes);
    end
end
for i = 1:length(thisSeriesList)
    if thisSeriesList{i}.pval < babyKit.ts.maxPval
        finalSeriesList{end+1} = thisSeriesList{i};
    end
end


function displaySeries(sl,cheatcode)
format short;
 for i = 1:length(sl)
     thisseries = sl{i};
     f1s = thisseries.f1RealFreqs;
     color = 1;
     if nearlycontains(f1s,cheatcode.correctf1) && nearlycontains(f1s,cheatcode.correctf2)
         goodstart = 1;
         color = 2;
     end
     
     fprintf(color,'series %d f1 freqs: %s p = %3.1e\n',i,num2str(thisseries.f1RealFreqs),thisseries.pval);
     1;
 end
 
function yesorno = nearlycontains(series,value,tolerance)
if nargin < 3
    tolerance = 1;
end
minerror = min(abs(series - value));
if minerror < tolerance
    yesorno = 1;
else
    yesorno = 0;
end
%tentative rule: if your series is length 2, you HAVE to extend it, and in
%the given direction. return a list of series, each of length 3.

%if your series is 3 or longer, [3 is an adjustment], the returned list
%incl
function [newSeriesList,foundNewOne] = extendf1SeriesListByOne(thisSeriesList,babyKit)
%if doOrDie is 1, then don't add yourself - extend or perish. if 0, add
%self with a closeout.
foundNewOne = 0;
newSeriesList = {};
for i = 1:length(thisSeriesList)
    s = thisSeriesList{i};

    if (s.seenBefore == 1) || (s.closedOut == 1) || (strcmp(s.nextCorner,'f0first') && (s.searchf0 == 0))
        %is it a keeper? this one will never grow old. use minlines.
        %fredos need not apply
        newSeriesList{end+1} = s;  %pass it forward. 
    else
        
        
%         heightThresh = mean(s.f1RealHeights) / s.ts.meantolerance;
%         startf = s.minftoseek;
%         stopf = s.maxftoseek;
        if s.nextcolumn == 1
            1;
        end
        
        [fs,hs] = findcandidates(s,babyKit);
        for i = 1:length(fs)
            newSeriesList{end+1}  = addCandidate(s,fs(i),hs(i));
            foundNewOne = 1;
        end
        if (length(fs) == 0) && (s.totalLines >= s.ts.minforcloseout) %this guy can be handed forward
            newSeriesList{end+1} = closeOut(s); %only closes current channel, eventually out of 4.
            foundNewOne = 1;
        end
    end
end

function s = closeOut(s)
    switch s.nextCorner
        case 'f1down'
            s.closedBelow = 1;
        case 'f1up'
            s.closedAbove = 1;
        case 'f0first'
            s.closedf0 = 1;
        case 'f0down'
            s.closedBelowf0 = 1;
        case 'f0up'
            s.closedAbovef0 = 1;
    end
    if (length(s.f0RealFreqs) == 0) && s.closedf0 && s.closedAbove && s.closedBelow
        s.closedOut = 1;
    end
    if s.closedBelowf0 && s.closedAbovef0 && s.closedAbove && s.closedBelow
        s.closedOut = 1;
    end
    s = updateSeriesPair(s);
    
function s = addCandidate(s,f,h)
    try
        s.fgrid(s.nextrow,s.nextcolumn) = f;
        s.hgrid(s.nextrow,s.nextcolumn) = h;
    catch
        s.nextrow = 1;
        s.fgrid(s.nextrow,s.nextcolumn) = f;
        s.hgrid(s.nextrow,s.nextcolumn) = h;
    end
    s.seenBefore = 0;
    if s.nextcolumn == 1
        1;
    end
    s = updateSeriesPair(s);

function [fs,hs] = findcandidates(s,babyKit)
%heightThresh = mean(s.f1RealHeights) / s.ts.meantolerance;

startf = s.minftoseek;
stopf = s.maxftoseek;
firsti = find(babyKit.fs > startf,1,'first');
lasti = find(babyKit.fs < stopf,1,'last');  %could be faster - fs are sorted.

fs = [];
hs = [];
for i = firsti:lasti
    if babyKit.hs(i) > s.heightThresh
        fs(end+1) = babyKit.fs(i);
        hs(end+1) = babyKit.hs(i);
    end
end