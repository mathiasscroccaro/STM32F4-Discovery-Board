
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%
%	Algoritmo para testar ganho e validar circuito do IV
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% #1
% Ganho tensao teorico = 5
% Ganho corrente teorico = 333

close all;
clear all;

format short eng

arguments = argv();

files = readdir('./data/')(3:end);

v = [];
c = [];

for file = files'
	data = dlmread(strcat('./data/',char(file)));
	v = [v data(:,1);];
	c = [c data(:,2);];
endfor

%v = mean(v');
%c = mean(c');

vg = [3.43 1.11];
cg = [31 326 3283];

%v = v.*3.3./4096;
%c = c.*3.3./4096;

%v = v./vg(1);
%c = c./cg(2);

pot = c.*v;

[maxPot,idxMaxPot] = max(pot);

figure;
subplot(2,2,1);
plot(v,c);
title('I-V')
xlabel('Tensao [V]')
ylabel('Corrente [A]')

subplot(2,2,2);
plot(v,pot);
title('P-V')
xlabel('Tensao [V]')
ylabel('Potencia [W]')

subplot(2,2,3);
plot(v);

subplot(2,2,4);
plot(c);

subplot(2,2,1);
hold on;
plot(v(idxMaxPot),c(idxMaxPot),'ro');

subplot(2,2,2);
hold on;
plot(v(idxMaxPot),(pot)(idxMaxPot),'ro');

printf("\n-----------------------------------------------------------\n")
printf("\nMetricas importantes: \n\t\tVoc: %f \tIsc: %f\n",max(v),max(c))
printf("Máxima potência: \n\t\t%f W em %f V\n\n",maxPot,v(idxMaxPot))
printf("Convertendo em 3.3V e 60/100 eficiencia: \n\t\t%f A\n",maxPot.*0.6/3.3);
printf("\n-----------------------------------------------------------\n")

a = waitforbuttonpress ()

%data = dlmread(strcat('./data/',char(files(1))))
%
%voltage = data(20:4000,1);
%current = data(20:4000,2);
%
%figure;
%
%subplot(2,2,1)
%plot(voltage,current);
%title('I-V')
%xlabel('Tensao [V]')
%ylabel('Corrente [A]')
%
%subplot(2,2,2)
%plot(voltage,voltage.*current);
%title('P-V')
%xlabel('Tensao [V]')
%ylabel('Potencia [W]')
%
%subplot(2,2,3)
%plot(voltage)
%title('Tensão da placa solar')
%
%subplot(2,2,4)
%plot(current)
%title('Corrente da placa solar')
%
%pot = voltage.*current;
%[maxPot,idxMaxPot] = max(pot);
%
%subplot(2,2,1);
%hold on;
%plot(voltage(idxMaxPot),current(idxMaxPot),'ro');
%
%subplot(2,2,2);
%hold on;
%plot(voltage(idxMaxPot),(voltage.*current)(idxMaxPot),'ro');
%
%
%printf("\n-----------------------------------------------------------\n")
%printf("\nMetricas importantes: \n\t\tVoc: %f \tIsc: %f\n",max(voltage),max(current))
%printf("Máxima potência: \n\t\t%f W em %f V\n\n",maxPot,voltage(idxMaxPot))
%printf("Convertendo em 3.3V e 60/100 eficiencia: \n\t\t%f A\n",maxPot.*0.6/3.3);
%printf("\n-----------------------------------------------------------\n")
%
%%pause(10)
%a = waitforbuttonpress ()
