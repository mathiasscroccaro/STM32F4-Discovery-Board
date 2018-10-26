
close all;
clear all;

format short eng

arguments = argv();

data = dlmread(char(arguments(1)));

voltage = data(1:4030,1);
current = data(1:4030,2);

figure;

subplot(2,2,1)
plot(voltage,current);
title('I-V')
xlabel('Tensao [V]')
ylabel('Corrente [A]')

subplot(2,2,2)
plot(voltage,voltage.*current);
title('P-V')
xlabel('Tensao [V]')
ylabel('Potencia [W]')

subplot(2,2,3)
plot(voltage)
title('Tensão da placa solar')

subplot(2,2,4)
plot(current)
title('Corrente da placa solar')

pot = voltage.*current;
[maxPot,idxMaxPot] = max(pot);

subplot(2,2,1);
hold on;
plot(voltage(idxMaxPot),current(idxMaxPot),'ro');

subplot(2,2,2);
hold on;
plot(voltage(idxMaxPot),(voltage.*current)(idxMaxPot),'ro');


printf("\n-----------------------------------------------------------\n")
printf("\nMetricas importantes: \n\t\tVoc: %f \tIsc: %f\n",max(voltage),max(current))
printf("Máxima potência: \n\t\t%f W em %f V\n\n",maxPot,voltage(idxMaxPot))
printf("Convertendo em 3.3V e 60/100 eficiencia: \n\t\t%f A\n",maxPot.*0.6/3.3);
printf("\n-----------------------------------------------------------\n")

%pause(10)
a = waitforbuttonpress ()
