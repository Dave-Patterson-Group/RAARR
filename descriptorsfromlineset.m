function [descriptor,longdescriptor] = descriptorsfromlineset(lineset)
longdescriptor = sprintf('%d line set:',length(lineset));
for i = 1:length(lineset)
    longdescriptor = sprintf('%s\n%s',longdescriptor,lineset{i}.descriptor);
end
descriptor = sprintf('%s %c\n%s %c\n%s %c\n%s %c \n%d lines total',lineset{1}.descriptor,lineset{1}.transitiontype,lineset{2}.descriptor,lineset{2}.transitiontype,lineset{3}.descriptor,lineset{3}.transitiontype,lineset{4}.descriptor,lineset{4}.transitiontype,length(lineset));


