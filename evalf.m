function freq = evalf(J,k1,k2,k3,ftable)
    if isstruct(ftable) == 0
        load('ftablefile','f1table','f0table');
        switch ftable
            case 0
                table = f0table;
            case 1
                table = f1table;
            otherwise
                ftable
                error('unknown function');
        end
    else
        table = ftable;
    end
    x = (J+1)/k3;
    y1 = k2 * interp1(table.xvals,table.yvals,x,'linear','extrap');
    freq = ((J+1) * k1) + y1;
