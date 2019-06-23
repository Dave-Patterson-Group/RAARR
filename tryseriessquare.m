function [kit] = tryseriessquare(s,kit)
rmsthresh = 20; %super loose
s.ordercutoff = 10; 
mostvotesssofar = 0;

n = length(kit.fitlist)+1;
kit.latestfit  = 0;
foundone = 0;
spfittrials = maketrials(s,kit);
if  kit.forcef1 ~= 0
    showseriessquare(s);
    1;
end

for i = 1:length(spfittrials)
    thistrial = spfittrials{i};
%     if i == 9
%         thistrial.ABC = [1230 680 490]; %this fixes case 42. Hmm. ABC starting points seem shaky as usual...
%     end
    thisfit = quickspfit(thistrial.lineset,thistrial.ABC);
    thisfit.seriessquare = s;
    thisfit.latticetype = 'ladder';
    fprintf('trial %d/%d,%s [%d]\n',i,length(spfittrials),thistrial.descriptor,thistrial.indexi);
    thisfit.trial = thistrial;
    if (thisfit.info.myrms_error < rmsthresh) && (thisfit.info.params.a > (thisfit.info.params.c * 1.1))
        thisfit = testfitonkit(thisfit,kit);
        if thisfit.yesvotes > 10
            foundone = 1;
            if thisfit.yesvotes > mostvotesssofar
                latestfit = thisfit;
                mostvotesssofar = thisfit.yesvotes;
            end            
        else %converged but no yesvotes
            %fprintf('Converged but only %d yesvotes\n',thisfit.yesvotes);
        end
    end
end

if (foundone)
    fprintf('Found match with %d yesvotes\n',latestfit.yesvotes);
    kit = addfittokit(kit,latestfit,n);
 %   try
        displaykitwithfits(kit,1);
  %  catch
    %    fprintf('displaykit having trouble again')
   % end
end


function spfittrials = maketrials(s,kit)
spfittrials = {};

jrange = jguesses(s);
for startka = 0:kit.maxka
    for jj = 1:length(jrange)
        offsetj = jrange(jj);
        [lineset] = linesfromseriessquareb(s,offsetj,startka); 
        
        [setdescriptor] = descriptorsfromlineset(lineset);
        ABCs  = findABC(s.fgrid);
        ABCs = [ABCs,{[2000 600 400],[5000 800 600]}]; %COWCOW MORE WORK HERE. higher KA isn't working
        ABCs = selectcells(ABCs,1:s.tightnesssettings.numABCs);
        %ABCs = {[1000 500 400]};%,[5000 1000 700]};%,[8500 600 530],[1000 980 800],[3000 1000 700]};
        thistrial.offsetj = offsetj;
        thistrial.startka = startka;
        thistrial.lineset = lineset;
        thistrial.setdescriptor = setdescriptor;

            
        for abck = 1:length(ABCs)
            %    fprintf('starting square %d flip %d,offset %d, ABC %d\n',ii,flipit,offsetj,abck);
            thistrial.ABC = ABCs{abck};
            thistrial.descriptor = sprintf('%s,offset %d ka %d, ABC %d\n%s',s.originstring,offsetj,startka,abck,setdescriptor);
            
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

function js = jguesses(s)
jdown = 3 + floor(s.tightnesssettings.numjguess/2);
s.tightnesssettings.numjguess
startj = max(1,floor(s.predictoffset-jdown));
endj = startj+s.tightnesssettings.numjguess;
js = startj:endj;




