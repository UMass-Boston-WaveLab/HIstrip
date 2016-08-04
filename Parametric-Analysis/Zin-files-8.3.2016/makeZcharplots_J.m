load ustripcalcZ %Zw calculated using microstrip design equations
[a, b, c] = xlsread('E:\kkerby\HIstrip\multicond_Zmatrix.csv');
HFSSfreq = a(:,1);
Z22 = a(:,3)+j*a(:,2);
Z12 = a(:,5)+j*a(:,4);
Z11 = a(:,7)+j*a(:,6);

set(0,'DefaultAxesColorOrder',[0 0 0;0.7 0.7 0.7],...
      'DefaultAxesLineStyleOrder','-|--|-.|:');
figure
set(gca, 'fontsize', 12)
plot(freq*1e-6, squeeze(real(Zw(1,1,:))), HFSSfreq, real(Z11), freq*1e-6, squeeze(imag(Zw(1,1,:))),  HFSSfreq, imag(Z11),'linewidth',3)
title('Z_{11}')
xlabel('Frequency [MHz]')
ylabel('\Omega')
ylim([-50 250])
set(gca, 'plotboxaspectratio', [3 1 1])

figure
set(gca, 'fontsize', 12)
set(gca, 'plotboxaspectratio', [3 1 1])
plot(freq*1e-6, squeeze(real(Zw(1,2,:))), HFSSfreq, real(Z12), freq*1e-6, squeeze(imag(Zw(1,2,:))),  HFSSfreq, imag(Z12),'linewidth',3)
title('Z_{12}')
xlabel('Frequency [MHz]')
ylabel('\Omega')
ylim([-10 50])
set(gca, 'plotboxaspectratio', [3 1 1])

figure
set(gca, 'fontsize', 12)
plot(freq*1e-6, squeeze(real(Zw(2,2,:))), HFSSfreq, real(Z22), freq*1e-6, squeeze(imag(Zw(2,2,:))),  HFSSfreq, imag(Z22),'linewidth',3)
title('Z_{22}')
xlabel('Frequency [MHz]')
ylabel('\Omega')
ylim([-10 50])
set(gca, 'plotboxaspectratio', [3 1 1])