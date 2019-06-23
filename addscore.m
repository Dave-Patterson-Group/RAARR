function thisFit = addscore(thisFit,scoretype)
    switch scoretype
        case 'pval'
            thisFit.fitScore = thisFit.pval^(-1);
        case 'pvaledge'
            thisFit.fitScore = thisFit.pval^(-1)  * 2^length(thisFit.lines);
        case 'pvaledgeJ'
            Jvals = extractonefieldfromcellarray(thisFit.lines,'Jupper');
            stdJ = std(Jvals);
            thisFit.fitScore = thisFit.pval^(-1)  * 2^length(thisFit.lines) * 10^stdJ * 10^thisFit.numtypes;
        case 'broadpval'
            thisFit.fitScore = thisFit.pval^(-0.5) * 10^length(thisFit.lines);
            %thisFit.fitScore = thisFit.pval^(-1) * 10^length(thisFit.lines);
    end
    thisFit.scoretype = scoretype;
    thisFit.scorefitdescriptor = sprintf('p = %3.1e, score %s = %3.1e, %d lines, %d hits',thisFit.pval,scoretype,thisFit.fitScore,length(thisFit.lines),thisFit.yesvotes);
    

