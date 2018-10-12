
close all;
clear all;

arguments = argv();

data = dlmread(char(arguments(1)));

voltage = data(1:4030,1);
current = data(1:4030,2);

figure;

subplot(1,2,1)
plot(voltage,current);
title('Curva corrente em funcao da tensao')
xlabel('Tensao [V]')
ylabel('Corrente [A]')

subplot(1,2,2)
plot(voltage,voltage.*current);
title('Curva da potencia em funcao da tensao')
xlabel('Tensao [V]')
ylabel('Potencia [W]')

%pause(10)
a = waitforbuttonpress ()
