[fsim, Zsim]=importHFSSZ('HISstub_L=48.csv');
Zins = HISstub(1e6*(1:1000), 0.02, 0.12, 0.02, 0.04, 0.005, 1, 2.2, 0.02, 0.48, 0, 4*0.14,8*0.14,1);
Z = squeeze(Zins(1,1,:));
figure; plot((1:1000), real(Z), 'b', (1:1000), imag(Z), 'r', fsim*1000, real(Zsim),'b--', fsim*1000, imag(Zsim),'r--','linewidth',2), ylim([-1000 1000]), grid on, xlim([0 700])
set(gca, 'fontSize',16)
legend({'Re[Z_{ckt}]';'Im[Z_{ckt}]';'Re[Z_{sim}]';'Im[Z_{sim}]'}, 'location','southeast')
title('Input impedance of single-sided HIS backed stub structure, L=0.48\lambda')

[fsim, Zsim]=importHFSSZ('HISstub_L=28.csv');
Zins = HISstub(1e6*(1:1000), 0.02, 0.12, 0.02, 0.04, 0.005, 1, 2.2, 0.02, 0.28, 0, 4*0.14,8*0.14,1);
Z = squeeze(Zins(1,1,:));
figure; plot((1:1000), real(Z), 'b', (1:1000), imag(Z), 'r', fsim*1000, real(Zsim),'b--', fsim*1000, imag(Zsim),'r--','linewidth',2), ylim([-1000 1000]), grid on, xlim([0 700])
set(gca, 'fontSize',16)
legend({'Re[Z_{ckt}]';'Im[Z_{ckt}]';'Re[Z_{sim}]';'Im[Z_{sim}]'}, 'location','southeast')
title('Input impedance of single-sided HIS backed stub structure, L=0.28\lambda')

[fsim, Zsim]=importHFSSZ('SteveDrayton.csv');
Z=seriesHISstub(1e6*(1:1000),0.02,0.12,0.02,0.04,0.005,1,2.2,0.02,0.47/2,0.47/2);
figure; plot((1:1000), real(Z), 'b', (1:1000), imag(Z), 'r', fsim*1000, real(Zsim),'b--', fsim*1000, imag(Zsim),'r--','linewidth',2), ylim([-1000 1000]), grid on, xlim([0 700])
set(gca, 'fontSize',16)
legend({'Re[Z_{ckt}]';'Im[Z_{ckt}]';'Re[Z_{sim}]';'Im[Z_{sim}]'}, 'location','southeast')
title('Input impedance of HIS backed dipole structure')