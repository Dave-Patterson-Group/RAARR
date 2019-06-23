function kit =  quickFit(molname,method)
if nargin < 2
    method = 'scaffold';
end
ts = settingsfromtightness(1);
ts.patternfitting.maxcomponents = 1;
ts.evolveFit = 0;
ts.addisotopes = 0;
[kit] = autofit(molname,method,0,1,ts);
