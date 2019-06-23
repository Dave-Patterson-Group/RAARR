function output = extractfieldsfromarray(database,fieldname)

if ischar(database)
    b = load(database); %assumes database is filename
    name = fieldnames(b); %name is a cellarray
    database = b.(name{1}); %fancy dynamic structure calling
end

if isempty(database)
    for i = 1:length(fieldname)
        output.(fieldname{i}) = {};
    end
else
    if not(iscell(database))
        database = num2cell(database);
    end
    if ischar(fieldname) 
        if strcmp(fieldname, 'all')
            fieldname = fieldnames(database{1});
            fieldname = transpose(fieldname);
        else
            error('Enter a different specification string or a cell array of fieldnames');
        end
    end
    
    cellmarker = [];
    for i = 1:length(fieldname)
        thisfieldname = fieldname{i};
        if not(isfield(database{1}, thisfieldname))
            error(sprintf('%s field not found', thisfieldname));
        else
            if ischar(database{1}.(thisfieldname)) || isstruct(database{1}.(thisfieldname))
                output.(thisfieldname) = {};
                cellmarker(i) = 1;
            else
                output.(thisfieldname) = [];
                cellmarker(i) = 0;
            end
        end
    end

        
    
    for i = 1:length(database)
        for j = 1:length(cellmarker)
            thisfield = fieldname{j};
            if cellmarker(j)
                if isfield(database{i},thisfield)
                    output.(thisfield){end + 1} = database{i}.(thisfield);
                else
                    output.(thisfield){end + 1} = 'NA';
                end
            else
                if isfield(database{i},thisfield)
                    output.(thisfield)(end + 1) = database{i}.(thisfield);
                else
                    output.(thisfield)(end + 1) = -1;
                end
            end
        end
    end
    
end