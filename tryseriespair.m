function [finalfit numvotes kit] = tryseriespair(s1,s2,kit)
%s2 is lowside; s1 is highside
%this entire function is super repitive, it should be done with
%tryseriessquare.
rmsthresh = s1.ts.rmsthresh; %super loose

finalfit = 0;
numvotes = 0;


ka = 0;
%n = length(kit.fitlist)+1;
allfs = [s1.realfs s2.realfs];
if length(unique(allfs)) < (length(s1.realfs) + length(s2.realfs)) 
    fprintf('only %d unique lines\n',length(unique(allfs)));
    return
end
kit.latestfit  = 0;
foundone = 0;
square.fgrid = zeros(20,4);
square.fgrid(:,1) = s2.fvsj;
square.fgrid(:,4) = s1.fvsj;
lowestsharedj = 0;
for i = 1:length(s1.fvsj)
    if (s1.fvsj(i) > 0) && (s2.fvsj(i) > 0)
        lowestsharedj = i;
        lowestsharedf1 = s1.fvsj(i);
        lowestsharedf2 = s2.fvsj(i);
        fdiff  = (lowestsharedf1 - lowestsharedf2);
        fdiffratio = fdiff/ lowestsharedf1;
        break
    end
end
if lowestsharedj == 0
    return
end
if abs(fdiffratio) > s1.ts.f1f2ratiothresh
    fprintf('rejecting fdiff ratio = %3.2f without spfit\n',fdiffratio);
    return;
end

fprintf('trying pair:\n s1: %s\n s2: %s\n',s1.fulldescriptor,s2.fulldescriptor);
offsetj = 0;
   

%for squarei = 9:9    %square 9, offset 4 is alpha  pinene 1



istart = 1;
iend = 44; %fix this - neuter series coming in
%             if s.degree >= 5
%                 
%                 iend = 5;
%             end
%             istart = 1;
%             iend = 30;
%     [lineset setdescriptor] = linesfromseriessquare(s,thissquareseries,offsetj,smartstart,smartend); %this picks best quad.. but less lines
square.ordercutoff = 50;
square.alineorder = zeros(20,4);

[lineset1] = linesfromoneaseries(s1,ka,1); %5,3 is the cheatcodes for myrtenal
[lineset2] = linesfromoneaseries(s2,ka,0); %5,3 is the cheatcodes for myrtenal

lineset = [lineset1 lineset2];
smartABC = findABCfromaseries(s1);
%[lineset setdescriptor longdescriptor smartABC] = linesfromseriessquareb(square,offsetj,1,44,0,ka,[100 0 0 100]); %5,3 is the cheatcodes for myrtenal
ABCs = {smartABC};
%ABCs = {[1000 500 400]};%,[5000 1000 700]};%,[8500 600 530],[1000 980 800],[3000 1000 700]};

%longdescriptor
for abck = 1:length(ABCs)
    %    fprintf('starting square %d flip %d,offset %d, ABC %d\n',ii,flipit,offsetj,abck);
    thisfit = quickspfit(lineset,ABCs{abck});
    ABC = [thisfit.info.params.a thisfit.info.params.c thisfit.info.params.b];
    thisfit.info;
    %      fprintf('done %d skipped %d of %d: %3.1f MHz error\n',numdone,numskipped,totscans,thisfit.info.myrms_error);
    if (thisfit.info.myrms_error < rmsthresh) && (thisfit.info.params.a > (thisfit.info.params.c * 1.1))
        if thisfit.info.params.c > thisfit.info.params.b
            oldinfo = thisfit.info;
            ABC = [thisfit.info.params.a thisfit.info.params.c thisfit.info.params.b];
            newfit = quickspfit(lineset,ABC);
            if (newfit.info.myrms_error < rmsthresh) && (newfit.info.params.a > (newfit.info.params.c * 1.1))
                thisfit = newfit;
            end
        end
        thisfit.series1 = s1;
        thisfit.series2 = s2;
        thisfit.serieska = ka;
        thisfit.latticetype = 'aseries';
        bestfit = thisfit;
        bestfit.twoseriesrms = thisfit.info.myrms_error;
        
        kit.allfs = [s1.fs s2.fs];
        kit.allhs = [s1.hs s2.hs];
        1;
        extendedfit = quickseriesextend(bestfit,kit,0);
        
        
        if extendedfit.yesvotes > 18
%            fitwithtargetseries = findbtransitions(extendedfit,kit);
%             btries = fitwithtargetseries.targetseries.foundseries;
%             if length(btries) > 0
%                 totalyes = extendedfit.yesvotes;
%                 alltries{1} = extendedfit;
%                 for i = 1:length(btries)
%                     newlineset = [lineset btries{i}.assignments];
%                     newfit = quickspfit(newlineset,ABC);
%                     if (newfit.info.myrms_error < rmsthresh)
%                         newextendedfit = quickseriesextend(newfit,kit,0);
%                         totalyes(end+1) = newextendedfit.yesvotes;
%                         alltries{end+1} = newextendedfit;
%                     end
%                 end
%                 besti = find(totalyes == max(totalyes),1,'first');
%                 extendedfit = alltries{besti};
%             end
            
            1;
            kit = addfittokit(kit,extendedfit,1);
            
            displaykitwithfits(kit,1);
            %     fprintf('set %d, offset %d [predict %d]\n %s\n',flipit,offsetj,s.predictoffset,extendedfit.extendstring);
            
            %              bigextendedfit = quickseriesextend(bestfit,kit,1);
            %testmanyconditions(lineset) %this runs many ABCs,
            %                            if (foundone == 0) && (argsin.verbose == 1)
            %   displayspfit(extendedfit,kit,1);
            
            %             displayspfit(bigextendedfit,kit,1);
%            addtext(sprintf('%s flip %d,offset %d [predict %d] ka %d, ABC %d\n%s',s.originstring,flipit,offsetj,startj+3,startka,abck,setdescriptor));
%             subplot(1,3,3);
%             showseriesladder(s);
            foundone = 1;
            %   end
            if extendedfit.yesvotes > numvotes
                finalfit = extendedfit;
                kit.latestfit = finalfit;
                numvotes = extendedfit.yesvotes;
            end
            %     return finish this sweep  - just a few seconds
            %   foundone = 1;
            %disp(extendedfit.extendstring);
            %exploreABCs - find out how many converge in this
            %case.  This one good to explore with fake data.
            %                            if extendedfit.yesvotes > mostupvotes
            %                                finalfit = extendedfit;
            %                                mostupvotes = extendedfit.yesvotes;
            %
            %                                if (kit.breakmode == 1) && (mostupvotes > 20)
            %                                    return
            %                                end
            %                            end
        else %converged but no yesvotes
            fprintf('Converged but only %d yesvotes, %d novotes\n',extendedfit.yesvotes,extendedfit.novotes);
        end
    end
end
        
    
% 
% if (foundone == 0) 
%     showseriessquare(s,kit);
%     
%     addtext('NOT FOUND');
% end

function kit = addfittokit(kit,fit,n)

fit.hitfs = kit.onedpeakfs(fit.hitis);
fit.hiths = kit.onedpeakhs(fit.hitis);
switch n
    case 1
        fit.color = 'r';
    case 2
        fit.color = 'b';
    case 3
        fit.color = 'm';
    case 4
        fit.color = 'c';
    otherwise
        kit.color = 'k';
end
kit.fitlist{n} = fit;
kit.numspecies = length(kit.fitlist);
    

kit.whichspecies(fit.hitis) = n;
%displayspfit(finalfit,kit);
%1;

