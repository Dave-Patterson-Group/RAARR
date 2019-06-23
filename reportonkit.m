function [reportstring] = reportonkit(kit,molstats,i)
if kit.bogged == 1
    boggedstring = 'BOGGED';
else
    boggedstring = '';
end
basestring = sprintf('%s k=%3.3f,%s in %3.1f seconds [%s] range %d flat, ',molstats.molname,molstats.asymm,boggedstring,kit.fitduration,num2str(molstats.frange),kit.totalflatsquares);
if kit.foundfit == 1
    trialString = kit.finalfit.trial.offsetdescriptor;
    gotitright = ABCmatch(molstats.ABC,kit.finalfit.ABC);
    if gotitright
        reportstring = sprintf('CORRECT: %s %d upvotes on trial %s\n',basestring,kit.numvotes,trialString);
    else
        reportstring = sprintf('FALSE POSITIVE: %s %d upvotes on trial %s, found[%s]%s\n',basestring,kit.numvotes,trialString,num2str(kit.finalfit.ABC));
    end
else
    reportstring = sprintf('FAILED: %s %d tries to SPFIT\n',basestring,kit.spfitcount);
end
if nargin == 3
    reportstring = sprintf('%d rng %s',i,reportstring);
end
function [match,distance] = ABCmatch(ABC1,ABC2,thresh)
if nargin < 3
    thresh = 2.0; %in MHz
end
distance = norm(ABC1-ABC2);
if distance < thresh
    match = 1;
else
    match = 0;
end

