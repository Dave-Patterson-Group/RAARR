function filename = makeintfile(argsin)

if nargin < 1
    argsin = prepare_sp_argsin;
end

%supports only one vib state and assumes Watson A reduction

molstats = argsin.molstats;

for types = ['a' 'b' 'c']

    filename = [argsin.filename types '.int'];

    partitionfn = (5.3311 * 10^6) * sqrt(argsin.temp^3/(molstats.a * molstats.b * molstats.c));%at 300 K, http://info.ifpan.edu.pl/~kisiel/asym/pickett/crib.htm#spcatint

    f = fopen(filename,'w');
    fprintf(f, '%s\n', molstats.molname); %line 1 is title
    fprintf(f, '114 %i %f %i %i %f ,, %f %f\n', -molstats.molid, partitionfn, argsin.jmin, argsin.jmax, argsin.intensethresh, argsin.maxf, argsin.temp); % outputspecification (114 outputs all), molID, partitionfnat300, KMIN, KMAX, logstrengthcutoff1,logstrengthcutoff2 (unused, some weird formula, stick with only the 1st cutoff), freq cutoff(GHz), temp

    %now dipole moments
    if strcmp(types, 'a')
        fprintf(f, '001 %f\n', molstats.mua);
    elseif strcmp(types, 'b')
        fprintf(f, '002 %f\n', molstats.mub);
    else
        fprintf(f, '003 %f\n', molstats.muc);
    end

    fclose(f);

end

