function kit =  carefulFit(molname,method)
if nargin < 2
    method = 'scaffold';
end
ts = settingsfromtightness(1);
ts.patternfitting.maxcomponents = 6;

ts.evolveFit = 1;
ts.addisotopes = 0;
[kit] = autofit(molname,method,0,3,ts);
