function plotlinelist(linelist)

outputs = extractfieldsfromcellarray(linelist,{'expfreq','unstretchedpredictedf','predictedh','expheight'});

theoryfs = outputs.unstretchedpredictedf;
theoryhs = outputs.predictedh;
expfs = outputs.expfreq;
exphs = outputs.expheight;
figure;
stickplot(expfs,exphs,'r');
hold all;
stickplot(theoryfs,-theoryhs,'b');
xlabel('frequency');
legend('experiment','theory');

