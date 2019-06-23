function [linfilename, numoflines] = convertcsvtolin(csvfilename)
    
    linfilename = [csvfilename(1:end-3) 'lin'];
    f = fopen(csvfilename);
    
    C = textscan(f,'%u %u %u %u %u %u %f %f', 'Delimiter', ',');
    
    Jupper = C{1};
    Kaupper = C{2};
    Kcupper = C{3};
    
    Jlower = C{4};
    Kalower = C{5};
    Kclower = C{6};
    
    frequencies = C{7};
    errors = C{8};
    
    g = fopen(linfilename,'w');
    
    Jupper_str = convertQNtostring(Jupper); %converts to SPFIT/SPCAT format
    Kaupper_str = convertQNtostring(Kaupper);
    Kcupper_str = convertQNtostring(Kcupper);
    Jlower_str = convertQNtostring(Jlower);
    Kalower_str = convertQNtostring(Kalower);
    Kclower_str = convertQNtostring(Kclower);
    
    
    for i = 1:length(Jupper)
        fprintf(g,[Jupper_str{i} Kaupper_str{i} Kcupper_str{i} Jlower_str{i} Kalower_str{i} Kclower_str{i}]);
        for j = 1:6
            fprintf(g,'   '); % 6 unused quantum numbers
        end
        fprintf(g,'  %f %f\n', frequencies(i), errors(i));
    end
    
    numoflines = length(Jupper);
    
    
    fclose(g);
    
    fclose(f);
    

end