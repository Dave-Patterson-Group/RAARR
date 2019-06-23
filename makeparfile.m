function [parfilename filename] = makeparfile(argsin)

if nargin < 1
   argsin = prepare_spfit_argsin(); 
end

%supports only one vib state and assumes Watson A reduction

for suffix = 1:3
    parfilename = [argsin.filename sprintf('%d.par',suffix)];
    filename = [argsin.filename sprintf('%d',suffix)];
    f = fopen(parfilename,'w');
    if f == -1
        1;
        argsin
        fprintf('file %s did not open',parfilename);

    else
        break
    end
end
if f == -1
    error('file %s did not open at all',parfilename);
end
fprintf(f, '%s\n', argsin.molname); %line 1 is title
if argsin.default == 1
    fprintf(f, '%i 99 10 0 0 1000000 1 1\n', 8); %number of parameters (A,B,C,DJ, DJK, DK, deltaJ, deltaK)
else
    fprintf(f, '%i %i %i %i %f %f %f %f\n', 8, argsin.nline,argsin.ntir,argsin.nxpar,argsin.thresh,argsin.errtst,argsin.frac,argsin.cal); %number of parameters (A,B,C,DJ, DJK, DK, deltaJ, deltaK)
end
fprintf(f, '''a'' 1 1 0 99\n'); %[A or S reduction, pos - asym top neg - sym top magnitude -spin degeneracy, num of vibstates, Kmin, Kmax]

% now parameters. Real useful CRIB sheet: http://info.ifpan.edu.pl/~kisiel/asym/pickett/crib.htm#asym
fprintf(f, '10000 %f %f\n', argsin.a, argsin.aerror); % A in MHz (all units)
fprintf(f, '20000 %f %f\n', argsin.b, argsin.berror); % B
fprintf(f, '30000 %f %f\n', argsin.c, argsin.cerror); % C
if argsin.useCD >= 1
    CDerror = 1;
else
    CDerror = 0;
end
if isfield(argsin, 'DJ') == 0
    argsin.DJ = 0;
    argsin.DJK = 0;
    argsin.DK = 0;
    argsin.deltaJ = 0;
    argsin.deltaK = 0;
end

if (argsin.useCD >= 1) || (argsin.DJ ~= 0)
    fprintf(f, '200 %f %f\n', -argsin.DJ,CDerror); % -DeltaJ
    fprintf(f, '1100 %f %f\n', -argsin.DJK,CDerror); %-DeltaJK
    fprintf(f, '2000 %f %f\n', -argsin.DK,CDerror); % -DeltaK
    fprintf(f, '40100 %f %f\n', -argsin.deltaJ,CDerror); %-deltaJ
    fprintf(f, '41000 %f %f\n', -argsin.deltaK,CDerror); %-deltaK
end

fclose(f);

1;


end