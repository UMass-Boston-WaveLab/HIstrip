function [] = plotsurfwave(filename,unitcell)
[a,b,c] = xlsread(filename);

k = 2*pi*a(:,end)*1e9/(3e8);
beta =  2*pi*a(:,2:(end-1))*1e9/(3e8);
lightline = (a(:,1)/180)*300/unitcell;

figure;
set(gca, 'fontSize', 12)
plot(a(:,end)*1000,k*unitcell,'k','LineWidth',2)
hold on
for ii = 1:(size(beta,2))
    scatter(a(:,end)*1000,unwrap(wrapToPi(beta(:,ii)*unitcell)),20)
end
plot(a(:,end)*1000,-k*unitcell,'k','LineWidth',2)
for ii = 1:(size(beta,2))
    scatter(a(:,end)*1000,unwrap(wrapToPi(-beta(:,ii)*unitcell)),20)
end
set(gca, 'yticklabel', {'-pi','-3pi/4', '-pi/2','-pi/4', '0','pi/4', 'pi/2','3pi/4', 'pi'})
set(gca, 'ytick', -pi:pi/4:pi)
ylim([0 2*pi])
xlabel('Freq [MHz]')
ylabel('\beta * a')
for ii = 1:size(beta,2)
    legarray{ii} = ['Mode ' num2str(ii)];
end
legend([{'Light Line'}; legarray'])
title('Surface Wave Dispersion Diagram Derived from HFSS Eigenmode Simulation','fontsize',14)

figure;
set(gca, 'fontSize', 12)
plot(a(:,1),a(:,4)*1000,'k','LineWidth',2)
hold on
for ii = 1:size(beta,2)
    scatter(a(:,1),a(:,1+ii)*1000,20)
end
ylabel('Freq [MHz]')
xlabel('\beta * a [deg]')
for ii = 1:size(beta,2)
    legarray{ii} = ['Mode ' num2str(ii)];
end
legend([{'Light Line'}; legarray'])
title('Surface Wave Dispersion Diagram Derived from HFSS Eigenmode Simulation','fontsize',14)

figure;
set(gca, 'fontSize', 12)
plot(k*unitcell,a(:,end)*1000,'k','LineWidth',2)
hold on
for ii = 1:(size(beta,2))
    scatter(unwrap(wrapToPi(beta(:,ii)*unitcell)),a(:,end)*1000,20)
end
plot(-k*unitcell,a(:,end)*1000,'k','LineWidth',2)
for ii = 1:(size(beta,2))
    scatter(unwrap(wrapToPi(-beta(:,ii)*unitcell)),a(:,end)*1000,20)
end
% set(gca, 'yticklabel', {'-pi','-3pi/4', '-pi/2','-pi/4', '0','pi/4', 'pi/2','3pi/4', 'pi'})
% set(gca, 'ytick', -pi:pi/4:pi)
% ylim([0 pi])
ylabel('Freq [MHz]')
xlabel('\beta * a')
for ii = 1:size(beta,2)
    legarray{ii} = ['Mode ' num2str(ii)];
end
xlim([-pi pi])
legend([{'Light Line'}; legarray'])
title('Surface Wave Dispersion Diagram Derived from HFSS Eigenmode Simulation','fontsize',14)