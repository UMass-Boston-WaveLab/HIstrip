clc
clear all
%%%%%%%%%%%%%%%%%%%%%%%%%cst
hs_hfss=importdata('Zin_7row_HFSS.csv');
S1=hs_hfss.data;
Freq = S1(:,1);
S11=S1(:,2);%1raw
plot(Freq,S11,':b','LineWidth',3);

hold on

S11=S1(:,3);%3raw
plot(Freq,S11,':r','LineWidth',3);


hold on

S11=S1(:,4);%5raw
plot(Freq,S11,':g','LineWidth',3);

hold on

S11=S1(:,5);%7raw
plot(Freq,S11,'-r','LineWidth',3);


legend('1 raw','3 raws','5 raws','7 raws');


% hold on
% x=hs1.Frequencies./10^9;
% plot(x,-10,'-k','LineWidth',.5);
set(gca,'fontsize',12,'fontweight','b','FontName','Times New Roman');
% title('Sine Function','fontsize',12,'fontweight','b','FontName','Times New Roman');
xlabel('Frequency (GHz)','fontsize',12,'fontweight','b','FontName','Times New Roman');
ylabel('S_1_1 (dB)','fontsize',12,'fontweight','b','FontName','Times New Roman');
