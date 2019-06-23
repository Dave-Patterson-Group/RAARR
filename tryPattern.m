function newfit = tryPattern(s,kit)
%s is the pattern. contains only fgrid, pval, and a tiny descriptor.  This
%code should try SPFIT on ANY pattern. I think we can assume that series4
%has non-zero entries.
s = updatePattern(s,kit);
newfit.quality = 0;

s.tightnesssettings = kit.tightnesssettings.patternfitting;

rmsthresh = 20; %super loose
s.ordercutoff = 10; 
mostvotesssofar = 0;

n = length(kit.fitlist)+1;
kit.latestfit  = 0;
foundone = 0;
spfittrials = maketrials(s,kit);
% if  kit.forcef1 ~= 0
%     showseriessquare(s);
%     1;
% end

for i = 1:length(spfittrials)
    thistrial = spfittrials{i};
%     if i == 9
%         thistrial.ABC = [1230 680 490]; %this fixes case 42. Hmm. ABC starting points seem shaky as usual...
%     end
    thisfit = quickspfit(thistrial.lineset,thistrial.ABC);
    thisfit.pattern = s;
    thisfit.patternType = s.patternType;
    fprintf('\ntrial %d/%d,%s [%d]\n',i,length(spfittrials),thistrial.descriptor,thistrial.indexi);
  %  fprintf('\ntrial %d/%d, [%d]\n',i,length(spfittrials),thistrial.indexi);
    
    thisfit.trial = thistrial;
    if (thisfit.info.myrms_error < rmsthresh) && (thisfit.info.params.a > (thisfit.info.params.c * 1.1))
        thisfit = testfitonkit(thisfit,kit);
        thisfit.quality = thisfit.pval^(-1);
        %at this point thisfit has a fairly organized cell array
        %newassignments
        disp(thistrial.descriptor);
        if thisfit.yesvotes > 10
            foundone = 1;
            if thisfit.quality > mostvotesssofar
                
                fprintf('\ntrial %d, %d hits found\n',i,thisfit.yesvotes); 
                latestfit = thisfit;
                mostvotesssofar = thisfit.quality;
            end            
        else %converged but no yesvotes
            %fprintf('Converged but only %d yesvotes\n',thisfit.yesvotes);
        end
    end
end

if (foundone)
    fprintf('Found match with %d yesvotes, quality %3.1e\n',latestfit.yesvotes,latestfit.quality);
    newfit = latestfit;

end


function spfittrials = maketrials(s,kit)
spfittrials = {};

switch s.patternType
    case {'scaffold','bowties'}
        jrange = jguesses(s);
    case 'aTypes'
        jrange = 1;
    case 'btype'
        jrange = 1;
end

for startka = 0:s.tightnesssettings.maxka
    for jj = 1:length(jrange)
        for kci = 1:length(s.tightnesssettings.actypes)
            thisac = s.tightnesssettings.actypes(kci);
            offsetj = jrange(jj);
            [lineset] = linesfromseriessquareb(s,offsetj,startka,[100 100 100 100],thisac);
            
            [setdescriptor] = descriptorsfromlineset(lineset);
            ABCs  = findABC(s.fgrid,startka);
            ABCs = [ABCs,{[2000 1400 1000],[5000 800 600]}]; %COWCOW MORE WORK HERE. higher KA isn't working
            ABCs = selectcells(ABCs,1:s.tightnesssettings.numABCs);
            %ABCs = {[1000 500 400]};%,[5000 1000 700]};%,[8500 600 530],[1000 980 800],[3000 1000 700]};
            thistrial.offsetj = offsetj;
            thistrial.startka = startka;
            thistrial.lineset = lineset;
            thistrial.setdescriptor = setdescriptor;
            
            
            for abck = 1:length(ABCs)
                %    fprintf('starting square %d flip %d,offset %d, ABC %d\n',ii,flipit,offsetj,abck);
                thistrial.ABC = ABCs{abck};
                thistrial.descriptor = sprintf('offset %d ka %d, ABC %d\n%s',offsetj,startka,abck,setdescriptor);
                
                thistrial.indexi = length(spfittrials) + 1;
                thistrial.offsetdescriptor = sprintf('[%d:JKABC=%d%d%d]',thistrial.indexi,jj,startka,abck);
                thistrial.islegal = testtrial(thistrial);
                if thistrial.islegal
                    spfittrials{end+1} = thistrial;
                else
                    fprintf('skipping illegal trial %s\n',thistrial.descriptor);
                    lineset{1}
                end
            end
        end
    end
end

function islegal = testtrial(thistrial)
    islegal = 1;
    lineset = thistrial.lineset;
    ABC = thistrial.ABC;
    Js = extractonefieldfromcellarray(lineset,'Jupper');
    if length(lineset) < 4
        islegal = 0;
    end
    if max(Js) > 99
        islegal = 0;
    end
    if (ABC(1) < ABC (2)) || (ABC(2) < ABC(3))
        islegal = 0;
    end

function jguess = predictoffset(fs)
    
    lowesti = find(fs > 0,1,'first');
    f2 = fs(lowesti + 1);
    f1 = fs(lowesti);
    jguess = f1 / (f2-f1);
    jguess = floor(jguess)-(lowesti-1);
    if f2 == 0
        jguess = -10000;
    end
function jguess = predictbestoffset(fgrid)
jguess = predictoffset(fgrid(:,4));
if jguess == -10000
    jguess = predictoffset(fgrid(:,1));
end

function js = jguesses(s)
jdown = floor(s.tightnesssettings.numjguess/2);
%s.tightnesssettings.numjguess
jguess = predictbestoffset(s.fgrid);
startj = max(-1,floor(jguess-jdown)-1);
endj = startj+s.tightnesssettings.numjguess-1;
js = startj:endj;



