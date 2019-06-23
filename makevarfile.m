function filename = makevarfile(argsin)

if nargin < 1
   argsin = prepare_sp_argsin;
end

%supports only one vib state and assumes Watson A reduction

molstats = argsin.molstats;

for types = ['a' 'b' 'c']

    filename = [argsin.filename types '.var'];

    f = fopen(filename,'w');
    fprintf(f, '%s\n', molstats.molname); %line 1 is title
    fprintf(f, '%i\n', 8); %number of parameters (A,B,C,DJ, DJK, DK, deltaJ, deltaK)
    fprintf(f, '''a'' %i 1 %i %i\n', argsin.spindegeneracy, argsin.kmin, argsin.kmax); %[A or S reduction, pos - asym top neg - sym top magnitude -spin degeneracy, num of vibstates, Kmin, Kmax]

    % now parameters. Real useful CRIB sheet: http://info.ifpan.edu.pl/~kisiel/asym/pickett/crib.htm#asym
    fprintf(f, '10000 %f\n', molstats.a * 1000); % A in MHz (all units)
    fprintf(f, '20000 %f\n', molstats.b * 1000); % B
    fprintf(f, '30000 %f\n', molstats.c * 1000); % C
    fprintf(f, '200 %f\n', -molstats.DJ * 1000); % -DeltaJ
    fprintf(f, '1100 %f\n', -molstats.DJK * 1000); %-DeltaJK
    fprintf(f, '2000 %f\n', -molstats.DK  * 1000); % -DeltaK
    fprintf(f, '40100 %f\n', -molstats.deltaJ * 1000); %-deltaJ
    fprintf(f, '41000 %f\n', -molstats.deltaK * 1000); %-deltaK
    fclose(f);

end

end