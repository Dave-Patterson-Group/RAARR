function csvfilename = fakecsvname(molname,template)
if nargin < 2
    template = 0;
end
    if template == 0
         csvfilename = sprintf('../squareassign/Molecules/fakes/fake%s.csv',molname);
    else
        csvfilename = sprintf('../squareassign/Molecules/theory templates/%s_theory.csv',molname);
    end
    csvfilename(csvfilename == ' ') = '_'; 
    
