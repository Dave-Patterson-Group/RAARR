function newfit = runspfit_from_fit(goodfit,verbose)

%called from demokingpin2.  Basically runs spfit based on a list of lines,
%argsin, etc.

%typical call is runspfit_from_fit(good_fits{1});
if nargin < 2
    verbose = 1;
end

testingcsvname = sprintf('%s/fittesting%d.csv',getspfitpath,floor(rand() * 5));
%maketestingcsv(lines,testingcsvname);

maketestingcsvfromfit(goodfit,testingcsvname);
argsout = goodfit.info.argsout;
[~,~,~,fit_info] = runspfit(argsout,testingcsvname,verbose);
newfit = fit_info;% = runspfit(argsout, testingcsvname,1);

[shortstring fulldescription] = stringfromfit(newfit);
newfit.shortstring = shortstring;
newfit.fulldescription = fulldescription;
end

