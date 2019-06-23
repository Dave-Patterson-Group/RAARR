function plotseriesc(series,color)
    pairseries = series.cheat.pairseries;
    firstpair = series.cheat.lowestpair;
    
    
%     startj = extractfieldsfromcellarray(pairseries,{'startj'});
%     startj = startj.startj;
    
    startj = series.jvalues;
    fs = series.fs;
    difffs = diff(fs);
    diffffs = diff(difffs);
   % disp(fs);
   % disp(diff(fs));
  
    subplot(4,1,[1]);
    plotwithvis(startj,fs,series.visibleis,color);
    if isfield(series,'predictstring');
        addtext(series.predictstring);
    end
    ylabel('f');
    title([firstpair.molname ' from ' firstpair.shortdescription]);
    subplot(4,1,2);
    plotwithvis(startj(1:end-1),difffs,series.visibleis,color);
    molstats = series.cheat.lowestpair.molstats;
    1;
    predictj = molstats.a / (molstats.b-molstats.c);
    funkyscale = molstats.c / (molstats.b-molstats.c);
    addtext(sprintf('C / (B-C) = %3.1f',funkyscale));
%    bplusc = molstats.b+molstats.c;
%     text(1,bplusc,'b plus c');
%     text(1,2* molstats.b,'2 b');
%     text(1,2* molstats.c,'2 c');
    ylabel('f_{j+1} - f_j');
    hold all;
    plotwithvis(startj(1:end-1),difffs,series.visibleis,color);
    
        subplot(4,1,3);
    plotwithvis(startj(1:end-2),diffffs,series.visibleis,color);

     subplot(4,1,4);
    finald = fs(end) - fs(end-1);
    modfs = fs - (finald * startj);
    plotwithvis(startj,modfs,series.visibleis,color);

 %   molstats = series.cheat.lowestpair.molstats;

    ylabel('tightness 2');
    hold all;
    
    function plotwithvis(j,f,vis,color)
        if vis(end) > length(f)
            vis = vis(1:end-1);
        end
        hold all;
        plot(j,f,['-' color 's']);
        plot(j(vis),f(vis),[color 's'],'MarkerFaceColor',color);
    
