function [titlestring] = litestringfromfit(thisfit)
mol = thisfit.info.argsout;
cheatstring = '';
if mol.DJ ~= 0
    CDstring = 'CD';
else
    CDstring = '-';
end
titlestring = sprintf('A=%3.2f,B=%3.2f,C=%3.2f %s %d hits',mol.a,mol.b,mol.c,CDstring,thisfit.yesvotes);%thisfit.info.myrms_error);
if isfield(thisfit,'C13frac')
    titlestring = sprintf('%s %3.3f ^{13}C',titlestring,thisfit.C13frac);
end


