function kit =  grindAtype()

%molname = 'dioxolane';
%molname = 'eucalyptus';
molname = 'angelica'; %angelica seems to not work as of 4/11
ts = settingsfromtightness(1);
ts.patternfitting.maxcomponents = 1;

ts.evolveFit = 0;
ts.addisotopes = 0;
ts.variant3.verbose = 1;
ts.variant3.maxPval = 10000;
ts.correctheights = 0;
%add a verbose mode to tightness?? goal is to run deeper and be more
%tolerant of height mismatch. should probably make some fakies with bad
%heights as well.

[kit] = autofit(molname,'atype',1,1,ts);
