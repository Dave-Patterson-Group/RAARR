function output = sortcellarraybyfield(database,fieldname,upordown)
if nargin < 3
    upordown = 'ascend';
end
if (strcmp(upordown,'ascend') == 0) && (strcmp(upordown,'descend') == 0)
    error('have to ascend or descend');
end
output = {};
fields = zeros(1,length(database));
for i = 1:length(database)
    fields(i) = getfield(database{i},fieldname);
end

[sorted XI] = sort(fields,upordown);
for i = 1:length(database)
    output{i} = database{XI(i)};
end