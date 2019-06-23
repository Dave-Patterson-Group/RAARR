function newFit = evolveFitSave(thisFit,kit,scoretype,nrepeats)
if nargin == 4
    save('efitfile','thisFit','kit','scoretype','nrepeats');
else
    load('efitfile','thisFit','kit','scoretype','nrepeats');
end
newFit = evolveFit(thisFit,kit,scoretype,nrepeats);