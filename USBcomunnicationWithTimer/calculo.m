close all;
clear all;

n = 0:4095;

r1 = 100e3;
r2 = 230e3;

# V1 fixo, V2 variante

v2 = n;
v1 = 1000;

vo = (v1.*r2+v2.*r1)./(r1+r2);

figure;
plot(vo)
title('v1 fixo, v2 variante');


# V2 fixo, V1 variante

v1 = n;
v2 = 1000;

vo = (v1.*r2+v2.*r1)./(r1+r2);

figure;
plot(vo)
title('v2 fixo, v1 variante');
