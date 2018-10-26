close all;
clear all;

n = 0:1/4096:1;

dac1_max = 3.3;
dac2_max = 5;

r1 = 300e3;
r2 = 1e6;

dac1 = dac1_max*n;
dac2 = dac2_max*n;

figure;
palavra = 2700;
Vgs = (dac1*r1 + dac2_max*r2*palavra/4096)/(r1+r2);
plot(Vgs)
title('Para palavra = 2700');

figure;
palavra = 2500;
Vgs = (dac1*r1 + dac2_max*r2*palavra/4096)/(r1+r2);
plot(Vgs)
title('Para palavra = 2500');

figure;
palavra = 3000;
Vgs = (dac1*r1 + dac2_max*r2*palavra/4096)/(r1+r2);
plot(Vgs)
title('Para palavra = 3000');

figure;
palavra = 4096;
Vgs = (dac1*r1 + dac2_max*r2*palavra/4096)/(r1+r2);
plot(Vgs)
title('Para palavra = 4096');
