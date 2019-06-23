function [newfs,oldis] = bogglefs(fs)
%returns fs that only appear once. like words in scoring boggle.
%bogglefs([1 2 3]) returns [1 2 3]
%bogglefs([1 2 2 3]) returns [1 3]
is = 1:length(fs);
fs = sort(fs);
diffs = diff(fs);
matches = find(diffs == 0);
fs(matches) = Inf;
fs(matches+1) = Inf;
oldis = is(fs < Inf);
newfs = fs(fs < Inf);