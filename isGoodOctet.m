function score = isGoodOctet(octet,fit_params)
    score = 0;
    if ~(fit_params.containsOblate || (octet(1) > octet(4) && octet(5) > octet(8)))
        return;
    end
    if ~(fit_params.containsOblate || (octet(1) > octet(3) && octet(2) > octet(4)))
        return;
    end
    r12 = (octet(1) - octet(2)) / (octet(5) - octet(6));
    if r12 < 0
        return;
    end
    r13 = (octet(1) - octet(3)) / (octet(5) - octet(7));
    r23 = (octet(2) - octet(3)) / (octet(6) - octet(7));
    r24 = (octet(2) - octet(4)) / (octet(6) - octet(8));
    r34 = (octet(3) - octet(4)) / (octet(7) - octet(8));
    ratio5 = [r12 r13 r23 r24 r34];
    percentmaxdiff = (max(ratio5) - min(ratio5)) / mean(ratio5);
    h1 = octet(1) + octet(5);
    h4 = octet(4) + octet(8);
    percenth14diff = abs((h1 - h4) / mean([h1 h4]));
    leftsq = abs(octet(1) - octet(3) - octet(6) + octet(5));
    rightsq = abs(octet(4) - octet(2) - octet(7) + octet(8));
    prll1 = abs(octet(1)-octet(3)-octet(8)+octet(7));
    prll2 = abs(octet(2)-octet(4)-octet(6)+octet(5));
    ratiovar = max(abs(ratio5 - r12));
    if abs(percentmaxdiff) < fit_params.percentmaxdiff
        score = score + 1;
    end
    if abs(percenth14diff) < fit_params.percenth14diff
        score = score + 1;
    end
    if leftsq < fit_params.leftsq
        score = score + 1;
    end
    if rightsq < fit_params.rightsq
        score = score + 1;
    end
    if prll1 < fit_params.prll1
        score = score + 1;
    end
    if prll2 < fit_params.prll2
        score = score + 1;
    end
    if ratiovar < fit_params.ratiovar
        score = score + 1;
    end
    if score <= 5 %|| abs(octet(1) - 17914.475723) < 0.01 || abs(octet(1) - 14719.30) < 0.01
        if score == 5
            1;
        end
        score = 0;
    else
        1;
    end
end

