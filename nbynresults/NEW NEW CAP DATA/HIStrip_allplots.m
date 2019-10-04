
%%%%%%%%%%%%%%%%%%%%%%%%%cst
%
clc
clear all
nrows= [3 7];
for row=nrows

    switch row
        case 3
            load ('oct1_3row.mat');
        case 7
            load ('oct1_7row.mat')'
    end
    figure
    %
    p1=plot(f*1e-6, real(Zin), 'linewidth',2);
    hold on
    p2=plot(f*1e-6, imag(Zin),':k','linewidth',2);
    p1.Color=[0.7 0.7 0.7];
    p2.Color=[0.7 0.7 0.7];
    
    switch row
        case 3
            hs_hfss=importdata('Zin_3row_HFSS.csv');
        case 7
            hs_hfss=importdata('Zin_7row_HFSS.csv');
    end
    S1=hs_hfss.data;
    Freq = S1(:,1);
    S11=S1(:,2);%1raw
    plot(Freq,S11,'k','LineWidth',2);
    
    hold on
    S11=S1(:,3);%1raw
    plot(Freq,S11,':k','LineWidth',2);
    switch row
        case 3
            legend('Re. Model: 3 row','Im. Model: 3 row','Re. HFSS: 3 row','Im. HFSS: 3 row');
        case 7
            legend('Re. Model: 7 row','Im. Model: 7 row','Re. HFSS: 7 row','Im. HFSS: 7 row');
    end
    grid on
    set(gca, 'PlotBoxAspectRatio', [1 0.5 0.5])
    
    
    
    % hold on
    % x=hs1.Frequencies./10^9;
    % plot(x,-10,'-k','LineWidth',.5);
    set(gca,'fontsize',14,'fontweight','b','FontName','Times New Roman');
    % title('Sine Function','fontsize',12,'fontweight','b','FontName','Times New Roman');
    xlabel('Frequency (MHz)','fontsize',14,'fontweight','b','FontName','Times New Roman');
    ylabel('Input Impedance(\Omega)','fontsize',14,'fontweight','b','FontName','Times New Roman');
    
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
    figure
    S11_h=20*log10(abs((S1(:,2)+j*S1(:,3)-50)./(S1(:,2)+j*S1(:,3)+50)));%7raw
    S11_m=20*log10(abs((Zin-50)./(Zin+50)));
    plot(Freq,S11_h,'k',f*1e-6, S11_m, '--k','LineWidth',2);
    hold on
    
    %legend('HFSS: 3 row','Model: 3 row');
    set(gca, 'PlotBoxAspectRatio', [1 0.5 0.5])
    
    % hold on
    % x=hs1.Frequencies./10^9;
    % plot(x,-10,'-k','LineWidth',.5);
    set(gca,'fontsize',14,'fontweight','b','FontName','Times New Roman');
    % title('Sine Function','fontsize',12,'fontweight','b','FontName','Times New Roman');
    xlabel('Frequency (MHz)','fontsize',14,'fontweight','b','FontName','Times New Roman');
    ylabel('|S_{11}| (dB)','fontsize',14,'fontweight','b','FontName','Times New Roman');
end
