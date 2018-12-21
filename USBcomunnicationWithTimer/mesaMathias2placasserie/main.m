
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

% Dimensoes da placa solar
yDimension = 2*19e-3;
xDimension = 50e-3;
area = xDimension*yDimension;

base_dir = uigetdir();

files = readdir(base_dir)(3:end);

v = [];
c = [];

for file = files'
	data = dlmread(strcat(base_dir,'/',char(file)));
	v = [v data(:,1);];
	c = [c data(:,2);];
endfor

v = mean(v');
c = mean(c');

vg = [3.43 1.11];
cg = [31 326 3283];

v = v.*3.3./4096;
c = c.*3.3./4096;

v = v./vg(1);
c = c./cg(2);

pot = c.*v;
[maxPot,idxMaxPot] = max(pot);

powerArea = pot/area;

printf("\n-----------------------------------------------------------\n")
printf("Dimensoes:\n%e\t\t%e\n",xDimension,yDimension);
printf("Metricas importantes: \n\t\tVoc: %f \tIsc: %f\n",max(v),max(c))
printf("Máxima potência: \n\t\t%f W em %f V\n",maxPot,v(idxMaxPot))
printf("Pot.:\n\t\t%e W/cm2 @ MPPT\n",max(powerArea)*1e-4);
printf("Convertendo em 3.3V e 60/100 eficiencia: \n\t\t%f A\n",maxPot.*0.6/3.3);
printf("\n-----------------------------------------------------------\n")

save_dir = strcat(base_dir,'/',"resumo_dados.txt");
printf("Salvando dados resumidos em: %s\n",save_dir)
fd = fopen(save_dir,'w');
fprintf(fd,"Ganho de tensão:\t%d\nGanho de corrente:\t%d\n",vg(1),cg(2));
fprintf(fd,"MPPT: %e W @ %f V\n",maxPot,v(idxMaxPot));
fprintf(fd,"Potencia em MPPT: %e W/cm2\n",max(powerArea)*1e-4)
fprintf(fd,"Voc: %f\tIsc: %f",max(v),max(c))
fclose(fd);

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

a = waitforbuttonpress ()