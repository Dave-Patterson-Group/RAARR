function csvfilename = completeFilename(molname)
    if strcmp(molname(end-3:end),'.csv') == 1
        csvfilename = molname;
        return
    end
    csvfilename = sprintf('../squareassign/Molecules/%s/%s.csv',molname,molname);
    if length(dir(csvfilename)) == 0
        if molname(1) ~= upper(molname(1))
            molname(1) = upper(molname(1));
            csvfilename = completeFilename(molname);
        else
            
            fprintf('file %s not found\n',csvfilename);
            csvfilename = [];
        end
    end
