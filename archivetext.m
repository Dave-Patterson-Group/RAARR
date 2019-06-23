function archivetext(archivestring,archivefile)
if nargin < 2
    archivefile = 'concisearchive.txt';
end

g = fopen(archivefile,'a');
fprintf(g,archivestring);
fclose(g);

fprintf(archivestring);

