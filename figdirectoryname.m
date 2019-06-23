function s = figdirectoryname(csvfilename)
lastslash = find(csvfilename == '/'
 s = [csvfilename(1:end-4) 'fig.fig'];
