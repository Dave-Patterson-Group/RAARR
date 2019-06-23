function check_alpha_pinene

% [alphatheoryfilename,alphafreqs,alphaamps] = makefakecsv('alphapinene',1);
% [benzOD1theoryfilename,benzOD1freqs,benzOD1amps] = makefakecsv('benzOD1',1);
% [benzOD2theoryfilename,benzOD2freqs,benzOD2amps] = makefakecsv('benzOD2',1);
% [prop3theoryfilename,prop3freqs,prop3amps] = makefakecsv('prop3',1);

%save('tfile');
load('tfile');
benzOD_exp_filename = 'Molecules/BenzOD/BenzODhighsensitivity.csv';
M = csvread(benzOD_exp_filename);
    benzOD_exp_freqs = M(:,1);
    benzOD_exp_amps = M(:,2);

alpha_exp_filename = 'Molecules/alpha_pinene_1d/alpha_pinene.csv';
M = csvread(alpha_exp_filename);
    alpha_exp_freqs = M(:,1);
    alpha_exp_amps = M(:,2);
    
etoh_exp_filename = 'Molecules/ethanol/ethanol.csv';
M = csvread(etoh_exp_filename);
    etoh_exp_freqs = M(:,1);
    etoh_exp_amps = M(:,2);
    
    
alphaamps = alphaamps * max(benzOD_exp_amps) / max(alphaamps);
benzOD1amps = benzOD1amps * max(benzOD_exp_amps) / max(benzOD1amps);
benzOD2amps = benzOD2amps * max(benzOD_exp_amps) / max(benzOD2amps);
prop3amps = prop3amps * max(benzOD_exp_amps) / max(prop3amps);
etoh_exp_amps = etoh_exp_amps * max(benzOD_exp_amps)/ max(etoh_exp_amps);

figure('Position',[36         245        1194         519]);
plot(benzOD_exp_freqs,benzOD_exp_amps.*5,'b');
hold all;
plot(alphafreqs,-alphaamps);
plot(benzOD1freqs,-benzOD1amps);
plot(benzOD2freqs,-benzOD2amps);
plot(prop3freqs,-prop3amps);
plot(etoh_exp_freqs, -etoh_exp_amps);
legend('benzOD experiment','alpha_pinene theory','benzOD1 theory','benzOD2theory','propanediol theory','ethanol expt');

alphaamps = alphaamps * max(alpha_exp_amps) / max(alphaamps);

figure;
plot(alpha_exp_freqs,alpha_exp_amps,'b');
hold all;
plot(alphafreqs,-alphaamps,'r');
legend('alpha pinene experiment','alpha_pinene theory');
title('Alpha pinene contains theoretical alpha pinene');

