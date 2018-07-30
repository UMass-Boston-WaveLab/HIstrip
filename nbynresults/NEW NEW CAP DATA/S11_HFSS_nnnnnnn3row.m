clc
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%cst
% 
% load ('8by8 new paper.mat');
% 
% plot(f*1e-6, real(Zd), f*1e-6, imag(Zd),'linewidth',2)
% hold on
% 

hs_hfss=importdata('Terminal S Parameter_3row.csv');
S1=hs_hfss.data;
Freq = S1(:,1);
S11=S1(:,2);%1raw
plot(Freq/10^3,S11,':k','LineWidth',3);

% hold on
% S11=S1(:,3);%1raw
% plot(Freq/10^3,S11,':k','LineWidth',3);


% S11=S1(:,3);%3raw
% plot(Freq,S11,':r','LineWidth',3);
% 
% 
% hold on
% 
% S11=S1(:,4);%5raw
% plot(Freq,S11,':g','LineWidth',3);
% 
% hold on
% 
% S11=S1(:,5);%7raw
% plot(Freq,S11,'-r','LineWidth',3);


% legend('Re. Model: 3 row','Im. Model: 3 row','Re. HFSS: 1 row','Im. HFSS: 1 row');

legend('HFSS: 3 row');

% hold on
% x=hs1.Frequencies./10^9;
% plot(x,-10,'-k','LineWidth',.5);
set(gca,'fontsize',14,'fontweight','b','FontName','Times New Roman');
% title('Sine Function','fontsize',12,'fontweight','b','FontName','Times New Roman');
xlabel('Frequency (GHz)','fontsize',14,'fontweight','b','FontName','Times New Roman');
ylabel('|S_{11} |(dB)','fontsize',14,'fontweight','b','FontName','Times New Roman');
