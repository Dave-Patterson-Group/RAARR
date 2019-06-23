function y = evalf0(x,fname)
 if nargin < 2
     fname = 'ftablefile';
 end
   load(fname,'f0table');

   y = (x>=0) .* interp1(f0table.xvals,f0table.yvals,x,'spline','extrap');
 
