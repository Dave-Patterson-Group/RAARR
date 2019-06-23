function [new_database complement_database] = filterdatabasebyfield(database,fieldname,keyword)
    new_database = {};
    complement_database = {};
    doublesided = 0;
    
    if isstruct(keyword)
        minimum = keyword.min;
        maximum = keyword.max;
        doublesided = 1;
    end
    
    for i = 1:length(database)
        keep = 0;
        tocompare = database{i}.(fieldname);
        if doublesided
            if tocompare >= minimum && tocompare <= maximum
                keep = 1;
            end
        else
            if ischar(tocompare)
                if strcmp(tocompare,keyword)
                    keep = 1;
                end
            else
                if tocompare == keyword
                    keep = 1;
                end
            end
        end
        
        if keep
            new_database{end + 1} = database{i};
        else
            complement_database{end + 1} = database{i};
        end
    end
end