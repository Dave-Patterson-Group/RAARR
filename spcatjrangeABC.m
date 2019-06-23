function allpairs = spcatjrangeABC(ABCxxxxx,jmin,jmax)

    kmin = 0;
    kmax = jmax;
    molstats.a = ABCxxxxx(1) / 1000;
    molstats.b = ABCxxxxx(2) / 1000;
    molstats.c = ABCxxxxx(3) / 1000;
    molstats.DJ = -.000000001 + ABCxxxxx(4) / 1000;
    molstats.DJK = -.000000001 + ABCxxxxx(5) / 1000;
    molstats.DK = -.000000001 + ABCxxxxx(6) / 1000;
    molstats.deltaJ = -.000000001 + ABCxxxxx(7) / 1000;
    molstats.deltaK = -.000000001 + ABCxxxxx(8) / 1000;
    molstats.molname = 'unknown';
    molstats.molid = 0;
    molstats.mua = 1;
    molstats.mub = 1;
    molstats.muc = 1;
    
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