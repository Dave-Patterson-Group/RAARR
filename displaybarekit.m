function displaybarekit(kit)
%load(kitfilename);
figure('Name',kit.kitfilename,'Position',[69   181   781   817]);
M = csvread(kit.csvfilename);
if length(M) ~= numel(M)
    freqs = M(:,1);
    amps = M(:,2);
else % case pulegone csv file is 1 array alternating btwn freqs and amps
    freqs = M(1:2:end);
    amps = M(2:2:end);
end
if max(amps) < 1
    amps = amps * 1000 / max(amps);
end
hold all;
plot(freqs,amps,'c');
stickplot(kit.onedpeakfs,kit.onedpeakhs,'k');
title(kit.kitfilename);
xlabel('frequency, MHz');
ylabel('volts');
fancystickies;
hold all;
legend(kit.barekitdescriptor);
pause(0.001);