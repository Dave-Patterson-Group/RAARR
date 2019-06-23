function seriestypes

k1 = 2700;

k2 = -100;
jtyp = 0.5;
js = 1:20;

rawfs = js * k1;

for
f = (js * k1) + (k2 * atan(js/jtyp));

(js + jtyp) ./ (js .* (js+1)));

figure;
subplot(211);
plot(js,f);
subplot(212);
plot(js(1:end-1),diff(f));
