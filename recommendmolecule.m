function [pairlist, trianglelist, drlist] = recommendmolecule(A,B,C)



if (nargin == 3)
    newmol = loadmol('generic');
    newmol.a = A;
    newmol.b = B;
    newmol.c = C;
end

if nargin == 1
    if isstruct(A)
        newmol= A;
    else
        newmol = loadmol(A);
    end
    %argsin.molstats = loadmol(3);  %19 is conformer 2
end
if nargin == 0
    newmol = loadmol('menthone1');
    %argsin.molstats = loadmol(3);  %19 is conformer 2
end

argsin.molstats = newmol;  %19 is conformer 2
argsin.maxj = 8;
argsin.usepgo = 1;
argsin.reduceset = 0;
argsin.minrf = 0.01;
argsin.maxrf = 0.5;  %in GHz
argsin.maxmw = 22.0;
argsin.minmw = 10;
argsin.mindr = 0.0;
argsin.temp = 6;
argsin.finddrs = 1;


[pairlist trianglelist drlist] = findalltriangles(argsin);
% if nargin == 1
%     return;
% end
fprintf('full line list :::::::::::::::::::::::\n');
listpairs(pairlist);
fprintf('full dr list :::::::::::::::::::::::\n');
listdrs(drlist);

fprintf('detect recommendations:::::::::::::::::::::::\n');
findbestpairs(pairlist);
fprintf('triangle recommendations:::::::::::::::::::::::\n');
listtriangles(trianglelist);

figure('Name',argsin.molstats.molname,'Position',[541    85   616   611]);
subplot(3,1,1);
plotpairs(pairlist);
title(sprintf('%s jmax = %d',argsin.molstats.molname,argsin.maxj));
a = xlim;
subplot(3,1,[2 3]);
plotdrs(drlist);
disp(newmol);
%xlim(a);


% function recommendmoleculefaster(argsin)
% 
% if nargin == 0
%     argsin.molstats = loadmol(3);  %19 is conformer 2
%     argsin.temp = 6;
% end
% [fs intensities hashes alltransitions] = runpgopherfast(argsin.molstats,argsin.temp);
% figure;
% p = stickplot(fs*1e6,intensities);
% a.datatype = 'pgoplot';
% a.alltransitions = alltransitions;
% set(p,'UserData',a);
% fancystickies();
% 
% 


% [pairlist trianglelist drlist] = findalltriangles(argsin);
% fprintf('full line list :::::::::::::::::::::::\n');
% listpairs(pairlist);
% fprintf('full dr list :::::::::::::::::::::::\n');
% listdrs(drlist);
% 
% fprintf('detect recommendations:::::::::::::::::::::::\n');
% findbestpairs(pairlist);
% fprintf('triangle recommendations:::::::::::::::::::::::\n');
% listtriangles(trianglelist);
% 
% figure('Name',argsin.molstats.molname,'Position',[541    85   616   611]);
% subplot(3,1,1);
% plotpairs(pairlist);
% title(sprintf('%s jmax = %d',argsin.molstats.molname,argsin.maxj));
% a = xlim;
% subplot(3,1,[2 3]);
% plotdrs(drlist);
%xlim(a);
