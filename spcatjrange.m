function allpairs = spcatjrange(argsin,jmin,jmax,kmin,kmax)
    if nargin == 0
        jmin = 9;
        jmax = 11;
        kmin = 0;
        kmax = 1;
    end
    molstats.a = argsin.a / 1000;
    molstats.b = argsin.b / 1000;
    molstats.c = argsin.c / 1000;
    molstats.DJ = -.000000001 + argsin.DJ / 1000;
    molstats.DJK = -.000000001 + argsin.DJK / 1000;
    molstats.DK = -.000000001 + argsin.DK / 1000;
    molstats.deltaJ = -.000000001 + argsin.deltaJ / 1000;
    molstats.deltaK = -.000000001 + argsin.deltaK / 1000;
    molstats.molname = 'unknown';
    molstats.molid = 0;
    molstats.mua = argsin.hasa;
    molstats.mub = argsin.hasb;
    molstats.muc = argsin.hasc;
    argsout.vibstates = 1; 
    argsout.spindegeneracy = 1;

    argsout.temp = 6;
    argsout.intensethresh = -11; %log of intensity threshold
    argsout.maxf = 30; % in GHz

    argsout.molstats = molstats;
%         fprintf(f, '10000 %f\n', molstats.a * 1000); % A in MHz (all units)
%     fprintf(f, '20000 %f\n', molstats.b * 1000); % B
%     fprintf(f, '30000 %f\n', molstats.c * 1000); % C
%     fprintf(f, '200 %f\n', -molstats.DJ * 1000); % -DeltaJ
%     fprintf(f, '1100 %f\n', -molstats.DJK * 1000); %-DeltaJK
%     fprintf(f, '2000 %f\n', -molstats.DK  * 1000); % -DeltaK
%     fprintf(f, '40100 %f\n', -molstats.deltaJ * 1000); %-deltaJ
%     fprintf(f, '41000 %f\n', -molstats.deltaK * 1000); %-deltaK
    
  %  argsin = prepare_sp_argsin();
    argsout.jmin = max(jmin,0);
    argsout.jmax = jmax;
    argsout.kmin = max(kmin,0);
    argsout.kmax = kmax;
    argsout.filename = [getspfitpath '\spcatfile2'];
    allpairs = runspcat(argsout,1);
    for i = 1:length(allpairs)
        allpairs{i} = updateline(allpairs{i});
    end
end