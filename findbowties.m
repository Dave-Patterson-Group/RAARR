% Usage: findbowties(kit, fit_params, cont(optional))
% - kit: kitfromcsvfile
% - fit_params: an object with variables (dot referenced); -1 for defaults
% - cont: if cont=0, return 1st grid found; else return all grids found in
%         < cont seconds
% - an octet is formatted [series1high, series2high, series3high, series4high,
%   series1low, series2low, series3low, series4low]
function [fgrids, times] = findbowties(kit, cont)
tic
if nargin < 2
    cont = false;
end
fit_params = kit.tightnesssettings.bowties;
[fgrids, times] = findquads(kit,fit_params, cont);
end

function [fgrids, times] = findquads(kit,fit_params,cont)
fgrids = {};
times = [];
divthresh = fit_params.divthresh;
divthresh2 = fit_params.divthresh;
divthreshs = fit_params.divthreshs;
weakAorB = fit_params.weakAorB;

    function [sorted_fs_by_hs, sorted_hs, n] = getFsAndHs()
    fs = kit.onedpeakfsunassigned;
    hs = kit.onedpeakhsunassigned;
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

    function searchOneDiff()
    for hI = 1:fit_params.rank
        [ranges, rangesSorted] = deal(cell(1,n));
        for i = hI+1:n
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
            highLinesRange = allhighlines(lowerIndex:upperIndex);
            lowLinesRange = alllowlines(lowerIndex:upperIndex);
            strongNtstsRange = allstrongNtsts(lowerIndex:upperIndex);
            weakNtstsRange = allweakNtsts(lowerIndex:upperIndex);
            j1 = dI - lowerIndex + 1;
            
            [rangeLength, Idxs] = searchRange2(strongNtstsRange, weakNtstsRange, divthresh, divthresh2, weakAorB, j1);
            if (rangeLength < 3), continue; end
            highLinesRange = highLinesRange(Idxs);
            lowLinesRange = lowLinesRange(Idxs);
            ranges{i} = [highLinesRange; lowLinesRange];
            rangesSorted{i} = sort(ranges{i}(:));
            octet = zeros(1, 8);
            for j = hI+1:i-1
                if (length(ranges{i}) >= 4 || length(ranges{j}) >= 4) && sum(ismembc(rangesSorted{i}, rangesSorted{j})) >= 4
                    kis = otherInPair(find(ranges{i} == sorted_fs_by_hs(j)));
                    if (kis == 0), continue; end
                    kjs = otherInPair(find(ranges{j} == sorted_fs_by_hs(i)));
                    if (kjs == 0), continue; end
                    [fs_k,~,~] = intersect(ranges{i}(kis), ranges{j}(kjs));
                    if (isempty(fs_k)), continue; end
                    if numel(ranges{j}) >= 8
                        highLinesRangej = ranges{j}(1,:);
                        lowLinesRangej = ranges{j}(2,:);
                        dJ = XHS((hI-1)*n + j);
                        octet(1,1:4) = [allhighlines(dJ), alllowlines(dJ), max(fs_k(1), sorted_fs_by_hs(i)), min(fs_k(1), sorted_fs_by_hs(i))];
                        %nrangeskjs = nranges{j}(kjs); %minocteths = min(nrangeskjs(idxj(1)), allweakNtsts(dJ));
                        fgrid = rangeChoose2(highLinesRangej,lowLinesRangej,length(highLinesRangej),octet,fit_params);
                        if length(fgrid) > 1
                            fgrids{end+1} = fgrid;
                            times(end+1) = toc;
                            %fprintf('\t\thI = %d, i = %d, j = %d \n\n', hI, i, j);
                            if ~cont || toc > cont
                                return;
                            end
                        end
                    end
                    if numel(ranges{i}) >= 8
                        octet(1,1) = allhighlines(dI);
                        octet(1,2) = alllowlines(dI);        
                        octet(1,3) = max(fs_k(1), sorted_fs_by_hs(j));
                        octet(1,4) = min(fs_k(1), sorted_fs_by_hs(j));
                        %nrangeskis = nranges{i}(kis); %minocteths = min(nrangeskis(idxi(1)), allweakNtsts(dI));
                        fgrid = rangeChoose2(highLinesRange,lowLinesRange,rangeLength,octet,fit_params);
                        if length(fgrid) > 1
                            fgrids{end+1} = fgrid;
                            times(end+1) = toc;
                            %fprintf('\t\thI = %d, i = %d, j = %d \n\n', hI, i, j);
                            if ~cont || toc > cont
                                return;
                            end
                        end
                    end
                end
            end
        end
    end
    end
searchOneDiff();
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

function fgrid = rangeChoose2(highLinesRange,lowLinesRange,m,octet,fit_params)
fgrid = 0;
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
                    fgrid = vertcat(zeros(2,4),octet128(j,5:8),octet128(j,1:4),zeros(4,4));
                    return;
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