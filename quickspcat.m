function [lineset,newset] = quickspcat(lineset,delABC)
%evaluates all the lines in newfit under ABC + delABC
%calls SPCAT to return a list of pairs in and near the fit
if nargin == 1
    delABC = [0 0 0];
end
%argsin = fit.info.argsout;
argsin.a = lineset.ABCxxxxx(1);
argsin.b = lineset.ABCxxxxx(2);
argsin.c = lineset.ABCxxxxx(3);
argsin.DJ = lineset.ABCxxxxx(4);
argsin.DJK = lineset.ABCxxxxx(5);
argsin.DK = lineset.ABCxxxxx(6);
argsin.deltaJ = lineset.ABCxxxxx(7);
argsin.deltaK = lineset.ABCxxxxx(8);

argsin.a = argsin.a + delABC(1);
argsin.b = argsin.b + delABC(2);
argsin.c = argsin.c + delABC(3);
newABC = [argsin.a argsin.b argsin.c];

jmin = min(extractonefieldfromcellarray(lineset.lines,'Jlower'));
jmax = max(extractonefieldfromcellarray(lineset.lines,'Jupper'));%fit.info.maxj;
argsin.hasa = 1;
argsin.hasb = 1;
argsin.hasc = 1;

pairlist = spcatjrange(argsin,jmin,jmax,0,jmax);  %just do all k seems more stable
1;
hashlist = extractonefieldfromcellarray(lineset.lines,'hash');
newset = {};
for i = 1:length(pairlist)
    thispair = pairlist{i};
    if ismember(thispair.hash,hashlist)
        whichi = find(hashlist == thispair.hash,1);
        thisline = lineset.lines{whichi};
        thisline.stretchedf = thispair.delf;
        thisline.stretchedABC = newABC;
     %   newset{end+1} = thisline;
        lineset.lines{whichi} = thisline;
        1;
    end
end
 
