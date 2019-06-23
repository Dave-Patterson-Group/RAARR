function octet128 = perm128(octet, isOblate)
    if nargin < 2
        isOblate = true;
    end
    octet128 = zeros(0, 8);
    pairs = reshape(octet, [2, 4]);
    pairs = sort(pairs,2,'descend');
    if ~isOblate
        octet128 = vertcat(pairs([5 1 6 2 4 3 8 7]), pairs([3 1 4 2 6 5 8 7]));
    else
        for jt = 0:7
            pairsj = pairs;
            j = jt;
            if j >= 4
                pairsj([3 4 5 6]) = pairsj([5 6 3 4]);
                j = j - 4;
            end
            if j >= 2
                pairsj([1 2 3 4]) = pairsj([3 4 1 2]);
                j = j - 2;
            end
            if j == 1
                pairsj([5 6 7 8]) = pairsj([7 8 5 6]);
            end
            for it = 0:15
                pairsi = pairsj;
                i = it;
                if i >= 8
                    pairsi(:,1) = swap(pairsi(:,1));
                    i = i - 8;
                end
                if i >= 4
                    pairsi(:,2) = swap(pairsi(:,2));
                    i = i - 4;
                end
                if i >= 2
                    pairsi(:,3) = swap(pairsi(:,3));
                    i = i - 2;
                end
                if i == 1
                    pairsi(:,4) = swap(pairsi(:,4));
                end
                octet128(end+1,:) = pairsi([1 3 2 4 5 6 7 8]);
            end
        end
    end
end

function pair = swap(pair)
    pair([1 2]) = pair([2 1]);
end
