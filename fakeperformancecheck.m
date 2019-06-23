function fakeperformancecheck

molnames = {'menthone1'};

%makefakecsvs(molnames);
filenames = fakecsvfilesfrommolnames(molnames);


% 
% works = [];
% timings = [];
% votes = [];
% tights = [];
% minjs = [];
for i = 1:length(filenames)
%for i = 1:2
 
 %   try
        tic;
        [numconverged mostvotes bestfit tightness]  = autofitladder(filenames{i},0);%franges{i});%,tightmodes(i));
        works(i) = numconverged;
        votes(i) = mostvotes;
        tights(i) = tightness;
        minjs(i) = bestfit.minj;

        timings(i) = toc;
%     catch
%         error('%s %s CRASHED   \n',molnames{i},filenames{i});
%     end
end

for i = 1:length(works)
    
    if works(i) > 0
        fprintf('fake %s CONVERGED %d conformers in %f seconds [tightness %3.1f,minj %d] with %d upvotes\n',molnames{i},works(i),timings(i),tights(i),minjs(i),votes(i));
    else
        fprintf('%s FAILED    in %f seconds [tightness %3.1f] \n',molnames{i},timings(i),tights(i));
    end
end

function makefakecsvs(molnames)
for i = 1:length(molnames)
    makefakecsv(molnames{i});
end

function filenames = fakecsvfilesfrommolnames(molnames)
    filenames = {};
    for i = 1:length(molnames)
        filenames{end+1} = fakecsvname(molnames{i});
    end

