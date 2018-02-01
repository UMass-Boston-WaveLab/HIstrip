function [ data ] = TestReadHfss()
%IMPORTHFSSZ imports impedance data that has been exported from a
%report/plot in HFSS.  Each line is assumed to list f, Re{Z}, Im{Z} in that
%order.
data = csvread('Para_antH.csv', 1, 0);
%% 2Ghz - 7Ghz with .25Ghz step Size
F = data(1:21,1);

%Different impedance curves for variable heights ant_h (0.0001-0.005)m with
%0.001 step size

Zh1 = data(1:21, 2);
Zh2 = data(1:21, 3);
Zh3 = data(1:21, 4);
Zh4 = data(1:21, 5);
Zh5 = data(1:21, 6);
Zh6 = data(1:21, 7);
Zh7 = data(1:21, 8);

%[fsim, Zsim]=TestREadHfss('');
%Zins = HISstub(1e6*(1:1000), 0.02, 0.12, 0.02, 0.04, 0.005, 1, 2.2, 0.02, 0.48, 0, 4*0.14,8*0.14,1);
%Z = squeeze(Zins(1,1,:));

figure
plot(F,Zh1,'b',F , Zh2, 'r', F, Zh3, 'b--', F , Zh4, ':', F, Zh5,'--', F , Zh6,'g', F, Zh7,':r')
grid on 
set(gca, 'fontSize',28)
xlabel('Frequency Ghz')
ylabel('Ohms')
legend({'ant_h = 0.0001m';'ant_h = 0.0011m';'ant_h = 0.0021m';'ant_h = 0.0031m';'ant_h = 0.0041m';'ant_h = 0.0051m'}, 'location','northwest')
title('HFSS Input Impedance of Half-Wave Wire Dipole at Variable Antenna Heights, L=0.48\lambda')

%%
data = csvread('Para_NomZin.csv', 1, 0);
%%
F = data(1:21,1);


Zh1 = data(1:21, 2);


figure
plot(F,Zh1,'b')
grid on 
set(gca, 'fontSize',28)
xlabel('Frequency Ghz')
ylabel('Ohms')
%legend({'ant_h = 0.0001m';'ant_h = 0.0011m';'ant_h = 0.0021m';'ant_h = 0.0031m';'ant_h = 0.0041m';'ant_h = 0.0051m'}, 'location','northwest')
title('HFSS Input Impedance of Half-Wave Wire Dipole Backed by HIS, L=0.48\lambda')

%%
data = csvread('Para_Gap.csv', 1, 0);
%%
F = data(1:21,1);
Zh1 = data(1:21, 2);
Zh2 = data(1:21, 3);
Zh3 = data(1:21, 4);


figure
plot(F,Zh1,'b',F , Zh2, 'r', F, Zh3)
grid on 
set(gca, 'fontSize',28)
xlabel('Frequency Ghz')
ylabel('Ohms')
legend({'G = 0.0m'; 'G = 0.001m';'G = 0.005';'G = 0.003m'}, 'location','northwest')
title('HFSS Input Impedance of Half-Wave Wire Dipole (Variable Gap Width), L=0.48\lambda')

end
