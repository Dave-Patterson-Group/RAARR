% Usage: quadsearch(csvfilename, fit_params(optional))
% - csvfilename: path to the csv of spectra frequencies and intensities
% - fit_params: an object with variables (dot referenced); -1 for defaults
% - an octet is formatted [series1high, series2high, series3high, series4high,
%   series1low, series2low, series3low, series4low]
function [converged, kit, times] = quadsearchSPFIT_refactored(csvfilenameORkit, fit_params, cont, savept)
if nargin < 2
    fit_params = settingsfromtightness();
    fit_params = fit_params.bowties();
end
if nargin < 3
    cont = false;
end
if nargin < 4
    savept = [1 1 1];
end
if isstruct(csvfilenameORkit)
    kit = csvfilenameORkit;
else
    kit = kitfromcsvfile(csvfilenameORkit);
end
[converged, times] = findquads(kit,fit_params, cont, savept);

    function printTimes()
    endsearchtime = toc;
    if endsearchtime < 60
        fprintf(' Search time = %.1f seconds\n', endsearchtime);
    elseif endsearchtime < 3600
        fprintf(' Search time = %.1f minutes\n', endsearchtime/60);
    else
        fprintf(' Search time = %.2f hours\n', endsearchtime/3600);
    end
    times(3) = endsearchtime - sum(times([1 2 4]));
    tau = sum(times(1:4));
    fprintf('Sort time: %.1f%%\nSearch time: %.1f%%\nExponential time: %.1f%%\nSPFIT time: %.1f%%\n', sum(times(1))/tau*100, sum(times(2))/tau*100, sum(times(3))/tau*100, sum(times(4))/tau*100);
    end
%printTimes();
end


function [converged, times] = findquads(kit,fit_params,cont,savept)
converged = false;
times = zeros(5,1); %1:sort; 2:search; 3:exponential; 4:constant; 5:num calls to SPFIT
divthresh = fit_params.divthresh;
divthresh2 = fit_params.divthresh;
divthreshs = fit_params.divthreshs;
weakAorB = fit_params.weakAorB;

    function [sorted_fs_by_hs, sorted_hs, n] = getFsAndHs()
    fs = kit.onedpeakfs;
    hs = kit.onedpeakhs;
    hthresh = max(hs) / fit_params.hsdivthresh;
    fs = fs(hs > hthresh);
    hs = hs(hs > hthresh);
    [sorted_hs, XJ] = sort(hs, 'descend');
    sorted_fs_by_hs = fs(XJ);
    n = length(sorted_fs_by_hs);
    end
[sorted_fs_by_hs, sorted_hs, n] = getFsAndHs();

    function [allhighlines, alllowlines, allstrongNtsts, allweakNtsts, sorted_diffs_by_diffs, XHS] = storeAndSortByDiffs()
    [alldiffs, allhighlines, alllowlines, allstrongNtsts, allweakNtsts] = deal(zeros(n,n));
    for i = 1:n
        for j = i+1:n
            alldiffs(i,j) = sorted_fs_by_hs(i) - sorted_fs_by_hs(j);
            alldiffs(j,i) = -1 * alldiffs(i,j);
            if sorted_fs_by_hs(i) > sorted_fs_by_hs(j)
                allhighlines(i,j) = sorted_fs_by_hs(i);
                allhighlines(j,i) = sorted_fs_by_hs(i);
                alllowlines(i,j) = sorted_fs_by_hs(j);
                alllowlines(j,i) = sorted_fs_by_hs(j);
            else
                allhighlines(i,j) = sorted_fs_by_hs(j);
                allhighlines(j,i) = sorted_fs_by_hs(j);
                alllowlines(i,j) = sorted_fs_by_hs(i);
                alllowlines(j,i) = sorted_fs_by_hs(i);
            end
            if sorted_hs(i) > sorted_hs(j)
                allstrongNtsts(i,j) = sorted_hs(i);
                allstrongNtsts(j,i) = sorted_hs(i);
                allweakNtsts(i,j) = sorted_hs(j);
                allweakNtsts(j,i) = sorted_hs(j);
            else
                allstrongNtsts(i,j) = sorted_hs(j);
                allstrongNtsts(j,i) = sorted_hs(j);
                allweakNtsts(i,j) = sorted_hs(i);
                allweakNtsts(j,i) = sorted_hs(i);
            end
        end
    end
    [sorted_diffs_by_diffs, XDIFF] = sort(alldiffs(1:n^2));  %the only expensive part!
    % XDIFF(i) = presort index for a given postsort index i; usage: alldiffs([XDIFF(i)])
    [~, XHS] = sort(XDIFF); % XHS(j) = postsort index for a given presort index j; usage: sorted_diffs_by_diffs(XHS(j))
    allhighlines = allhighlines(XDIFF);
    alllowlines = alllowlines(XDIFF);
    allstrongNtsts = allstrongNtsts(XDIFF);
    allweakNtsts = allweakNtsts(XDIFF);
    end
[allhighlines, alllowlines, allstrongNtsts, allweakNtsts, sorted_diffs_by_diffs, XHS] = storeAndSortByDiffs();
times(1) = toc;

    function [converged, times] = searchOneDiff(times)
    converged = false;
    for hI = savept(1):fit_params.rank
        [ranges, rangesSorted, nranges] = deal(cell(1,n));
        for i = hI+1:n
            if hI == savept(1) && i < savept(2)
                continue;
            end
            if sorted_hs(i) < sorted_hs(hI)/divthreshs
                break;
            end
            if (cont && toc > cont) || (~cont && isstruct(converged))
                return;
            end
            dI = XHS((hI-1)*n + i); % dI = index in sorted_diffs_by_diffs of line with height rank hI
            [lowerIndex, upperIndex] = searchRangeWithTolerance(sorted_diffs_by_diffs, dI, fit_params.dthresh);
            rangeLength = upperIndex - lowerIndex + 1;
            if (rangeLength < 3), continue; end
            times(2) = toc - times(1);
            highLinesRange = allhighlines(lowerIndex:upperIndex);
            lowLinesRange = alllowlines(lowerIndex:upperIndex);
            strongNtstsRange = allstrongNtsts(lowerIndex:upperIndex);
            weakNtstsRange = allweakNtsts(lowerIndex:upperIndex);
            j1 = dI - lowerIndex + 1;
            
            [rangeLength, Idxs] = searchRange2(strongNtstsRange, weakNtstsRange, divthresh, divthresh2, weakAorB, j1);
            if (rangeLength < 3), continue; end
            highLinesRange = highLinesRange(Idxs);
            lowLinesRange = lowLinesRange(Idxs);
            strongNtstsRange = strongNtstsRange(Idxs);
            weakNtstsRange = weakNtstsRange(Idxs);
            ranges{i} = [highLinesRange; lowLinesRange];
            nranges{i} = [strongNtstsRange; weakNtstsRange];
            [rangesSorted{i}, IX] = sort(ranges{i}(:));
            nranges{i}(:) = nranges{i}(IX);
            octet = zeros(1, 8);
            for j = hI+1:i-1
                if hI == savept(1) && i == savept(2) && j < savept(3)
                    continue;
                end
                if (length(ranges{i}) >= 4 || length(ranges{j}) >= 4) && sum(ismembc(rangesSorted{i}, rangesSorted{j})) >= 4
                    kis = otherInPair(find(ranges{i} == sorted_fs_by_hs(j)));
                    if (kis == 0), continue; end
                    kjs = otherInPair(find(ranges{j} == sorted_fs_by_hs(i)));
                    if (kjs == 0), continue; end
                    [fs_k,idxi,idxj] = intersect(ranges{i}(kis), ranges{j}(kjs));
                    if (isempty(fs_k)), continue; end
                    if numel(ranges{j}) >= 8
                        highLinesRangej = ranges{j}(1,:);
                        lowLinesRangej = ranges{j}(2,:);
                        dJ = XHS((hI-1)*n + j);
                        octet(1,1:4) = [allhighlines(dJ), alllowlines(dJ), max(fs_k(1), sorted_fs_by_hs(i)), min(fs_k(1), sorted_fs_by_hs(i))];
                        nrangeskjs = nranges{j}(kjs);
                        minocteths = min(nrangeskjs(idxj(1)), allweakNtsts(dJ));
                        [returned, times] = rangeChoose2(highLinesRangej,lowLinesRangej,length(highLinesRangej),octet,times,fit_params);
                        if isstruct(returned)
                            converged = returned;
                            converged.minocteths = minocteths;
                            converged.savept = [hI i j];
                            fprintf('\t\thI = %d, i = %d, j = %d \n\n', hI, i, j);
                            return;
                        end
                    end
                    if numel(ranges{i}) >= 8
                        octet(1,1) = allhighlines(dI);
                        octet(1,2) = alllowlines(dI);        
                        octet(1,3) = max(fs_k(1), sorted_fs_by_hs(j));
                        octet(1,4) = min(fs_k(1), sorted_fs_by_hs(j));
                        nrangeskis = nranges{i}(kis);
                        minocteths = min(nrangeskis(idxi(1)), allweakNtsts(dI));
                        [returned, times] = rangeChoose2(highLinesRange,lowLinesRange,rangeLength,octet,times,fit_params);
                        if isstruct(returned)
                            converged = returned;
                            converged.minocteths = minocteths;
                            converged.savept = [hI i j];
                            fprintf('\t\thI = %d, i = %d, j = %d \n\n', hI, i, j);
                            return;
                        end
                    end
                end
            end
        end
    end
    end
[converged, times] = searchOneDiff(times);
end

function [rangeLength, Idxs] = searchRange2(strongNtstsRange, weakNtstsRange, divthresh, divthresh2, weakAorB, j1)
high1val = strongNtstsRange(j1); % = allstrongNtsts(XHS((hI-1)*n + i))
low1val = weakNtstsRange(j1); % = allweakNtsts(XHS((hI-1)*n + i))
strongNtst = max([high1val low1val]);
weakNtst = min([high1val low1val]);
strongIdxs = find(strongNtstsRange > strongNtst / divthresh);
if ~weakAorB
    weakIdxs = find(weakNtstsRange > strongNtst / divthresh);
else
    weakIdxs = find(weakNtstsRange > weakNtst / divthresh2 & weakNtstsRange < weakNtst * divthresh2);
end
Idxs = intersect(strongIdxs, weakIdxs);
rangeLength = length(Idxs);
end

function [bestfit, times] = rangeChoose2(highLinesRange,lowLinesRange,m,octet,times,fit_params)
bestfit = 0;
for j3 = 1:m
    if highLinesRange(j3) == octet(1,1) || highLinesRange(j3) == octet(1,3)
        continue;
    end
    octet(1,5:6) = [highLinesRange(j3), lowLinesRange(j3)];

    for j4 = j3+1:m
        if highLinesRange(j4) == octet(1,1) || highLinesRange(j4) == octet(1,3)
            continue;
        end
        octet(1,7:8) = [highLinesRange(j4), lowLinesRange(j4)];

        if length(unique(octet(1:8))) == length(octet(1:8))
            octet128 = perm128(octet(1:8), fit_params.containsOblate);
            lenoct128 = numel(octet128)/8;
            for j = 1:lenoct128
                if isGoodOctet(octet128(j,:),fit_params)
                    %octet128(j,:)
                    inttest = abs( octet128(j,4) / (octet128(j,4) - octet128(j,8)) );
                    t4 = toc;
                    [bestfit,nts] = tryspfit(octet128(j,:),inttest,fit_params.rmsthresh);
                    times(4:5) = [times(4)+toc-t4, times(5)+nts];
                    if isstruct(bestfit)
                        bestfit.ABC = [bestfit.info.params.a bestfit.info.params.b bestfit.info.params.c];
                        if isGoodABC(bestfit.ABC)
                            dashIdx = strfind(bestfit.shortstring,'-'); fprintf(strcat("\t",bestfit.shortstring(1:dashIdx(1)-1),'\t\t%.1f seconds'),toc);
                            return;
                        else
                            bestfit = 0;
                        end
                    end
                end
            end
        end
    end
end
end

function [lowerIdx, upperIdx] = searchRangeWithTolerance(arr, idx, dthresh)
[lowerIdx, upperIdx] = deal(idx);
for i = idx:-1:1
    if arr(i) < arr(idx) - dthresh
        lowerIdx = i + 1;
        break;
    end
end
for i = idx:numel(arr)
    if arr(i) > arr(idx) + dthresh
        upperIdx = i - 1;
        break;
    end
end
end

function ks = otherInPair(its)
if its == 0
    ks = 0;
else
    itseven = its(mod(its,2)==0)-1;
    itsodd = its(mod(its,2)==1)+1;
    try
        ks = vertcat(itseven(:),itsodd(:));
    catch
        its
        1;
    end
end
end

function [bestfit,numtries] = tryspfit(octet,inttest,rmsthresh)
numtries = 0;
octetsq = vertcat(zeros(2,4),octet(5:8),octet(1:4),zeros(4,4));
lines = cell(1,8);
abc = findABC(octetsq);
intRange = round(inttest)-1:round(inttest)+1;
for ka = 0:2
    for intit = intRange
        for k = 1:8
            lines{k} = assignlines(intit, ka, k, octet);
        end
        try
            thisfit = quickspfit(lines,abc);
            if (thisfit.info.myrms_error < rmsthresh) && (thisfit.info.params.a > (thisfit.info.params.c * 1.1))
                bestfit = thisfit;
                return;
            else
                bestfit = 0;
            end
        catch
            bestfit = 0;
        end
        numtries = numtries + 1;
    end
end
end

function line = assignlines(intit, ka, k, octet)
if k == 1 || k == 5
    line.Kaupper = ka;
    line.Kalower = ka;
elseif k == 2 || k == 6
    line.Kaupper = ka + 1;
    line.Kalower = ka;
elseif k == 3 || k == 7
    line.Kaupper = ka;
    line.Kalower = ka + 1;
else
    line.Kaupper = ka + 1;
    line.Kalower = ka + 1;
end
if k <= 4
    line.Jupper = intit;
    line.Jlower = intit - 1;
else
    line.Jupper = intit - 1;
    line.Jlower = intit - 2;
end
line.Kcupper = line.Jupper - ka;
line.Kclower = line.Jlower - ka;
line.expfreq = octet(k);
end

function newfit = quickspfit(lines,ABC)

%given a set of lines, runs spfit.

%typical call is runspfit_from_fit(good_fits{1});
if nargin < 2
    verbose = 1;
end

testingcsvname = sprintf('%s/fittesting%d.csv',getspfitpath,floor(rand() * 5));
%maketestingcsv(lines,testingcsvname);

f = fopen(testingcsvname,'w');
%linelist = oldfit.info.lines;

for i = 1:length(lines)
    thisline = lines{i};
       % thisupperstate = lines{i}.upperstate;
       % thislowerstate = lines{i}.lowerstate;
        thisfreq = thisline.expfreq;
        thiserror = 0; %I think this is ok? 
        upper_J = thisline.Jupper;
        upper_Ka = thisline.Kaupper;
        upper_Kc = thisline.Kcupper;
        lower_J = thisline.Jlower;
        lower_Ka = thisline.Kalower;
        lower_Kc = thisline.Kclower;
        fprintf(f, '%i,%i,%i,%i,%i,%i,%f,%f\n', upper_J, upper_Ka, upper_Kc, lower_J, lower_Ka, lower_Kc, thisfreq, thiserror);
   
end

fclose(f);
argsin = prepare_spfit_argsin;
argsin.filename = sprintf('%s/tempspfitfilemany%d',getspfitpath,floor(rand() * 5));

argsin.a = ABC(1);
argsin.b = ABC(2);
argsin.c = ABC(3);  %figure out useCD stuff
if length(lines) >= 20
    argsin.useCD = 1;  %turn it off for now
else
    argsin.useCD = 0;
end
[~,~,~,fit_info] = runspfit(argsin,testingcsvname,0);
newfit = fit_info;% = runspfit(argsout, testingcsvname,1);

[shortstring fulldescription] = stringfromfit(newfit);
newfit.shortstring = shortstring;
newfit.fulldescription = fulldescription;
end

function smartABC = findABC(fgrid)
n = 0;
for i = 1:length(fgrid(:,1))
    if (fgrid(i,1) > 0) && (fgrid(i,4) > 0)
        n = i;
        break
    end
end
if n == 0
    smartABC = [2000 500 400];
else
    
    a1j = fgrid(n+1,1)/(fgrid(n+1,1) - fgrid(n,1));
    a2j = fgrid(n+1,4)/(fgrid(n+1,4) - fgrid(n,4));
    f1f4 = fgrid(n+1,1) - fgrid(n+1,4);
    bplusc = fgrid(n+1,1)/a1j;
    bminusc = (f1f4/a1j);
    B = (bplusc + bminusc)/2;
    C = (bplusc) - B;
    A = 4 * bplusc;
    smartABC = [A B C];
end
end

function isGood = isGoodABC(abc)
    if min(abc) < 0 || 1/abc(1) + 1/abc(2) < 1/abc(3)
        isGood = false;
    else
        isGood = true;
    end
end