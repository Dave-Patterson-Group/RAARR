function [pairlist] = showseries(A,B,C)



if (nargin == 3)
    newmol = loadmol('generic');
    newmol.a = A;
    newmol.b = B;
    newmol.c = C;
end


if nargin == 1
    newmol = A;
    %argsin.molstats = loadmol(3);  %19 is conformer 2
end
if nargin == 0
    newmol = loadmol('menthone1');
    %argsin.molstats = loadmol(3);  %19 is conformer 2
end

    if nargin == 0
        argsin.molstats = newmol;
        argsin.maxj = 16;
        argsin.usepgo = 0;
        argsin.reduceset = 0;
%         argsin.maxrf = 1.0;  %in GHz
%         argsin.minrf = 0;
%         argsin.maxmw = 20.0;
%         argsin.minmw = 11.0;
%         argsin.mindr = 12.0;
        argsin.temp = 6;
    end
    bplusc = newmol.b + newmol.c;
    
    pairlist = findallpairspgo(argsin);
   % firstpair = pullpairb(pairlist,11,0,11,10,1,10);
    firstpair = pullpairb(pairlist,11,0,11,10,1,10);
    pairseries{1} = firstpair;
    lastpair = firstpair;
    while 1
        lastpair = pullnextpair(pairlist,lastpair,0);
        if isstruct(lastpair) == 0
            break
        end
        pairseries{end+1} = lastpair;
    end
    lastpair = firstpair;
    while 1
        lastpair = pullnextpair(pairlist,lastpair,1);
        if isstruct(lastpair) == 0
            break
        end
        pairseries{end+1} = lastpair;
    end
        
    1;
    pairseries = selectpairs(pairseries,0,1000,'startj',0);
    startj = extractfieldsfromcellarray(pairseries,{'startj'});
    startj = startj.startj;
    fs = extractfieldsfromcellarray(pairseries,{'delf'});
    fs = fs.delf;
    disp(fs);
    disp(diff(fs));
    figure;
    subplot(3,1,1);
    plot(startj,fs,'bs');
    ylabel('f');
    title(firstpair.labelstring);
    subplot(3,1,2);
    plot(startj(1:end-1),diff(fs),'bs');
    ylabel('f_{j+1} - f_j');
    hold all;
 %   plot(2,bplusc,'kx');
    subplot(3,1,3);
    plot(startj(1:end-2),diff(diff(fs)),'bs');
    ylabel('f_{j+1} - f_j');
    xlabel('j');
    
    1;
    
    
    