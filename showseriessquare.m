function showseriessquare(s,lineset)

figure('Position',[79   108   951   817]);
subplot(121);

hold all;
c1 = 0;

hold all;
%if s.series1.type == 'a'  %column 1
    p1 = stickplot(s.column1.realfs,s.column1.realhs,'b');
    p2 = stickplot(s.column2.realfs,s.column2.realhs,'r');
    p3 = stickplot(s.column3.realfs,s.column3.realhs,'m');
    p4 = stickplot(s.column4.realfs,s.column4.realhs,'k');
% else
%     p1 = stickplot(s.series1.realfs,s.series1.realhs,'r');
%     p2 = stickplot(s.series2.realfs,s.series2.realhs,'b');
%     p3 = stickplot(s.series3.realfs,s.series3.realhs,'k');
%     p4 = stickplot(s.series4.realfs,s.series3.realhs,'m');
% end

set(p1,'LineWidth',4);
set(p2,'LineWidth',4);
set(p3,'LineWidth',4);
set(p4,'LineWidth',4);
% if isfield(s,'series4')
%     p4 = stickplot(s.series4.fs,s.series4.hs,'k');
%     set(p4,'LineWidth',4);
% end
% 
% if isstruct(c1)
%     if (c1.foundseries && c2.foundseries && c3.foundseries)
%         p11 = stickplot(c1.upwardfs,-c1.upwardhs,'m');
%         p22 = stickplot(c2.upwardfs,-c2.upwardhs,'b');
%         p33 = stickplot(c3.upwardfs,-c3.upwardhs,'r');
% 
%         sr1 = seriesreport(s.column1.fs,c1.upwardfs);
%         sr2 = seriesreport(s.column2.fs,c2.upwardfs);
%         sr3 = seriesreport(s.column3.fs,c3.upwardfs);
% 
%         text(c1.upwardfs(1),-c1.upwardhs(1),sr1.shortstring);
%         text(c2.upwardfs(1),-c2.upwardhs(1),sr2.shortstring);
%         text(c3.upwardfs(1),-c3.upwardhs(1),sr3.shortstring);
% 
% 
%         set(p11,'LineWidth',2);
%         set(p22,'LineWidth',2);
%         set(p33,'LineWidth',2);
% 
%         legend('exact theory','measured spectrum','column 1','column 2','column 3');
%     end
% end
plot(s.flatsquare.fs(1),s.flatsquare.hs(1),'X','MarkerSize',20);
%plot(s.allbestfs,s.allbesths,'o','MarkerSize',6);
xlabel('frequency, MHz');
addtext(s.seriesstring,1);
addtext(sprintf('%s\n%s\n%s',s.descriptor,s.series4string, s.allfstring));
addtext(s.originstring,-1);
title(s.originstring);
precisestickies();

subplot(1,3,3);
showseriesladder(s);
%subplot(224);
%showseriesladder(s,1);



    
%    text(6.8,series1.ploth(3),descriptor);
%    title([kit.fakemolname]);

% errors = scrutinizeseries(kit.allseries{i});
% 
% 
% subplot(1,1,1);
% hold all;
% plot((1:length(errors)) + 2,errors,'s');
% xlabel('line number');
% ylabel('prediction label, MHz');
% title(sprintf('%d true [cheated] series from %s',numseries,kit.cheat.molstring));
% subplot(2,1,2);
% title(sprintf('%s %d kings',kit.allseries{i}.truthdescriptor,length(kit.allseries{i}.ikings)));
% 1;


% xlabel('1 / second error');
% ylabel('numkings');
% title(kit.cheat.molstring);
% 
% subplot(2,1,2);
% plot(1 ./ thirderrors,numkings,'rs');
% xlabel('1 / third error');
% ylabel('numkings');
% title(kit.cheat.molstring);

% function s = trimseries(s,numdrop)
% s.fs = s.fs(1+numdrop:end);
% s.hs = s.hs(1+numdrop:end);
% s.numlines = length(s.fs);
% newpairs = {};
% for i = 1:s.numlines
%     newpairs{i} = s.cheat.pairseries{i+numdrop};
% end
% s.cheat.pairseries = newpairs;
% s.cheat.lowestpair = newpairs{1};
% s.descriptor = s.cheat.lowestpair.shortdescription;
% 
% s = addpolytoseries(s);


function sr = seriesreport(foundfs,truthfs)
minlength = min(length(foundfs),length(truthfs));
errors = foundfs(1:minlength) - truthfs(1:minlength);
maxerror = max(abs(errors));
sr.maxerror = maxerror;
sr.shortstring = sprintf('E %3.3f',maxerror);
sr.longstring = sprintf('error %3.1f [%s]',maxerror,num2str(errors,2));

