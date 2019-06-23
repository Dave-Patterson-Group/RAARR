function y = evalf1(x)
    
   load('ftablefile','f1table');

   y = interp1(f1table.xvals,f1table.yvals,x,'spline','extrap');
 
