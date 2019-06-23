function [allseries kit] = getseries(kit,linetouse,ts)
if linetouse == 0
    laddermode = 1;
else
    laddermode = 0;
end
%loads flatsquares EITHER from a csvkitfile, or from a kit containing a
%theoryladder for a dry run
 
%     gapmax = 2250;
%     gapmin = 2240; %menthone is 1164
    % gapmax = 3000; %about 2500
    % gapmin = 200; %about 600
    
    % gapmax = frange / 4; %about 2500
    % gapmin = gapmax / 4; %about 600
    
    %pick a good first frequency. strong line a bit short of the middle
numchecked = 0;
numfound = 0;
allsquares = {};

if laddermode == 0
    fs = kit.onedpeakfs;
    hs = kit.onedpeakhs;
    
    counttool = makecounttool(hs);
    %maxheight = max(hs);
    %   hthresh = maxheight/50;
    
    frange = max(fs) - min(fs);
    
%     gapmax = 1667; %% 3000; %frange / 4; %about 2500
%     gapmin = 1665; %frange / 15; %about 600
    
    
        
    gapmax = ts.gapmax;
    gapmin = ts.gapmin; %menthone is 1164
    
    [f1 h1 istart rank] = pickfirstf(kit,linetouse);
    f1error = f1 - linetouse;
%    f1cheat = makecheats(f1,kit,linetouse,ts);
    fprintf('%s: jumping in, rank %d, height %3.1f tightness %3.1f\n',kit.molfilename,rank,h1,ts.scalartightness);
%     newhs = [];
%     
%     f = 6;
%     hthresh = 1e10;
%     
    minlines = ts.minlines;
 
%    possh = hs(imin:imax);
    [sorth] = sort(hs,'descend');
    if length(sorth) < minlines
        minlines = length(sorth);
    end
    
    tightthresh = h1/ts.firstcutheightratio;
    hthresh = min(tightthresh,sorth(minlines));
%    tightthresh
%    hthresh
%     while (length(newhs) < 1000) && (hthresh > min(hs))
%         hthresh = h1/(f * tightness);
% 
%         newfs = fs(find(hs > hthresh));
%         newhs = hs(find(hs > hthresh));
%         f = f * 1.5;
%      %   f
%      %   length(newhs)
%     end
    
    fs = fs(find(hs > hthresh));
    hs = hs(find(hs > hthresh));
    kit.usefs = fs;
    kit.usehs = hs;
    if isfield(kit,'forcef2') && kit.forcef2 > 0
        ferrs = abs(fs - kit.forcef2);
        minjj = find(ferrs == min(ferrs),1,'first');
        maxjj = minjj;
    else
        
        minjj = find(fs > (f1 + gapmin),1,'first');
        maxjj = find(fs > (f1 + gapmax),1,'first');
    end
    %code here to deal with f2correction if exists.
    
%     numf2s = 1 + maxjj - minjj;
%     
%     totalnum = (maxjj - minjj) * length(fs);
    
    f2list = fs;
    f3list = fs;
    f4list = fs;
    
    h2list = hs;
    h3list = hs;
    h4list = hs;
    %f3f1 is one of the numbers scouted by plotprimary series. for menthone
    %it is 300 MHz. So this bound is actually not that conservative.
%    f3f1thresh = 2000 * (tightness^2);
%cowcow take out f2 and f3 assigned as well..
else
    counttool = 0;
    frange = 100000;
    ts = settingsfromtightness(10); %very loose doesn't matter
    f1 = kit.firstsquare(1);
    h1 = 1;
    f1error = f1 - kit.templateabsolute(1);
    
    f2list = kit.firstsquare(2);
    f3list = kit.firstsquare(3);
    f4list = kit.firstsquare(4);
    
    h2list = 1;
    h3list = 1;
    h4list = 1;
    minjj = 1;
    maxjj = 1;
  %  hs = [1 1 1 1];
end

    for jj = minjj:maxjj
        f2 = f2list(jj);
        h2 = h2list(jj);
        f2error = f2 - f1 - (kit.templatenorm(2)*f1);  %we childishly pretend a 'zero' gap is expected.
        
        %    fprintf('%d total, %d checked, %d found\n',totalnum,numchecked,numfound);
        if (h2 > (h1 / ts.flatsquareheightratio))  %these two could be in a series.  Now the expensive part.  f3 could
            for kk = 1:length(f3list)
                f3 = f3list(kk);
                h3 = h3list(kk);
                f3f1 = abs(f3 - f1);
                f3error = f3 - f1 - (kit.templatenorm(3)*f1);
                %code here to deal with f3 correction if it exists..
                if (min(diff(sort([f1 f2 f3]))) > 0.1) && (f3f1 < ts.f3f1thresh)
                    f4s = abs([f1 + f2 - f3, f1 - f2 + f3,f1 - f2 - f3]);
                    numchecked = numchecked+1;
                    for mm = 1:3
                        f4 = f4s(mm);
                        if (f4 > f3)  || laddermode %avoids double finding
                     %       [minval ival] = closest(f4,fs);
                            ferrs = abs(f4list-f4);
                            [minval,ival] = min(ferrs);
                            if minval < ts.flatsquarefthresh
                                oldf4 = f4;
                                f4 = f4list(ival);
                                f4error = f4 - oldf4;
                                s.fs = [f1 f2 f3 f4];
                                s.hs = [h1 h2 h3 h4list(ival)];
                                switch mm
                                    case 1
                                        s.signs = [1 1 -1 -1];
                                    case 2
                                        s.signs = [1 -1 1 -1];
                                    case 3
                                        s.signs = [1 -1 -1 1];
                                end
                                s.usecorrection = 1;
                                s.laddermode = laddermode;
                                s.originalf1 = f1;
                                s.originallinetouse = linetouse;
                                s.counttool = counttool;
                                s.frange = frange;
                                if laddermode == 1
                                    s.frecommendedmin = 10000;
                                    s.frecommendedmax = 18500;
                                else
                                   
                                    s.frecommendedmin = min(fs) + 0.05 * frange;
                                    s.frecommendedmax = min(fs)  + 0.95*frange;
                                end
                                s.templateabsolute =  kit.templateabsolute;
                                s.templatenorm =  kit.templatenorm;
                                s.forcecorners = kit.forcecorners;
                                s.cornermap = kit.cornermap;
                                s.flaterrors = [f1error f2error f3error f4error];
                                s.tightnesssettings = ts;
                                s.signedfs = s.signs .* s.fs;  %so we know which ones are in a series yet? Maybe not.
                                s.ferror = sum(s.signedfs);
                                s.ferror2 = minval;
                                s.originstring = sprintf('%s %3.1f line %d',kit.kitfilename,f1,linetouse);
                                s.descriptor = sprintf('unconfirmed square %3.2f %3.2f %3.2f %3.2f',s.signedfs(1),s.signedfs(2),s.signedfs(3),s.signedfs(4));
                %                disp(s);
                                numfound = numfound+1;
                                allsquares{end+1} = s;
                            end
                        end
                    end
                
                end
            end
        end
    end
    
    allsquares = uniquesquares(allsquares);
    
    if length(allsquares) == 0
        fprintf('no squares found :(\n');
    end






