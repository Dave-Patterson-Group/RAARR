function savecsv(freqs,amps,filename)
M = zeros(2,length(freqs));
M(1,:) = freqs ;
M(2,:) = amps;
dlmwrite(filename,M','precision','%.4f');

