function [titlestring fulldescription cheatstring cheaterror] = stringfromfit(thisfit,trueABC)
mol = thisfit.info.argsout;
cheatstring = '';
if mol.DJ ~= 0
    CDstring = 'CD';
else
    CDstring = '-';
end
titlestring = sprintf('A=%3.2f,B=%3.2f,C=%3.2f %s\n%d lines %f MHz RMS',mol.a,mol.b,mol.c,CDstring,length(thisfit.info.lines),thisfit.info.myrms_error);
diffs = extractfieldsfromcellarray(thisfit.info.lines,{'diff'});
rmsdiff = mean(diffs.diff.^2);
qnumbers = extractfieldsfromcellarray(thisfit.info.lines,{'Kaupper','Kalower','Jupper','Jlower'});

allkas = [qnumbers.Kaupper qnumbers.Kalower];
maxka = max(allkas);
minka = min(allkas);

alljs = [qnumbers.Jupper qnumbers.Jlower];
maxj = max(alljs);
minj = min(alljs);
%fulldescription = sprintf('%s\nJ %d lines, %3.4f MHz RMS\n',titlestring,length(thisfit.info.lines),rmsdiff);
if isfield(thisfit,'pval')
    pvalstring = sprintf(' pval = %3.4g',thisfit.pval);
else
    pvalstring = '';
end
fulldescription = sprintf('=================\n%s%s\nJ = %d => %d, Ka = %d=>%d\n',titlestring,pvalstring,minj,maxj,minka,maxka);
1;

if nargin == 2
    fitabc = [mol.a mol.b mol.c];
    cheaterror = norm(fitabc - trueABC);
    cheatstring = sprintf('ABC off by %3.1f MHz',cheaterror);
end


