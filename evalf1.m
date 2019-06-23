function y = evalf1(x,fname)
 if nargin < 2
     fname = 'ftablefile';
 end
   load(fname,'f1table');

   y = (x>=0) .* interp1(f1table.xvals,f1table.yvals,x,'spline','extrap');
 
