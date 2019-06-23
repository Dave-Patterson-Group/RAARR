function data = combinedatabases(database1,database2)

if not(isempty(database1)) && iscell(database1{1})
    bigdatabase = {};
    for i = 1:length(database1)
        bigdatabase = horzcat(bigdatabase, database1{i});
    end
else
    bigdatabase = horzcat(database1,database2);
end

data = sortstructcellarraybyfield(bigdatabase,'realf');