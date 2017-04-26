function [] = call_multicond()
% this block of parameters is for Steve & Drayton's antenna at 300 MHz
a = 0.14;
w1 = 0.01;
h2 = 0.04;
h1= 0.02+h2;
eps1=1;
w2 = 0.12;
eps2=2.2;
freq = 100:5:500; %in MHz
via_rad = 0.0015875;

% % this block of parameters is for my L-band antenna
% freq = 800:10:2500;
% w2 = 0.07;
% h2 = 0.003175*2;
% via_rad = 0.0005;
% a = 0.0705;
% h1 = h2 + 0.005;
% eps1 = 1;
% eps2 = 1;
% w1 = 0.0025;
% 
% %this block is for an L-band antenna without vias (remember to comment out
% %Lmat in the unit cell calc
% freq = 900:0.5:1200;
% w2 = 0.08;
% h2 = 0.003175*2;
% via_rad = 0.0005;
% a = 0.0805;
% h1 = h2 + 0.005;
% eps1 = 1;
% eps2 = 2.2;
% w1 = 0.0025;
% 
% %this block is for an L-band antenna without vias (remember to comment out
% %Lmat in the unit cell calc
% freq = 900:10:2500;
% w2 = 0.08;
% h2 = 0.003175*2;
% via_rad = 0.0005;
% a = 0.0805;
% h1 = h2 + 0.005;
% eps1 = 1;
% eps2 = 1;
% w1 = 0.0025;

lambda = 3e8./(freq*1e6);
k = 2*pi./lambda;


for ii = 1:length(freq)
    %vratio is the ratio of V1 and V2 that happens if you excite V1 and
    %leave V2 open.
    [ABCD] = multicond_unitcell(a,w1, w2, h1, h2, via_rad, eps1, eps2, freq(ii)*1e6, 1); %use vias
    %make the parts of V normalized in the way described in Faria, 2004.
    %we want to find T0, W0, Tl, Wl that diagonalize the ABCD matrix into
    %modes as described there.
    
    [zf(ii,:), zb(ii,:), Zterm0(:,:,ii), gamma(ii,:),~,~,~] = fariamodal(ABCD, a);
    Zin(ii) = Zterm0(1,1,ii);
    
end
colors = ['b' 'r'; 'c' 'm'];
markers = ['o', '+'; 's', '^'];
figure
set(gca, 'fontSize', 12)
for ii = 1:2
    plot(freq,real(zf(:,ii)), colors(ii,1), freq, imag(zf(:,ii)), colors(ii,2),'linewidth',2)
    hold on
end
grid on
title('Forward-Propagating Mode Impedance (Z = R+jX)','fontsize',12)
xlabel('Frequency [MHz]')
ylabel('Ohms')
legend({'R1';'X1';'R2';'X2'})
ylim([-1000 1000])

figure
set(gca, 'fontSize', 12)
for ii = 1:2
    plot(freq,real(zb(:,ii)), colors(ii,1), freq, imag(zb(:,ii)), colors(ii,2),'linewidth',2)
    hold on
end
grid on
title('Backward-Propagating Mode Impedance (Z = R+jX)','fontsize',12)
xlabel('Frequency [MHz]')
ylabel('Ohms')
legend({'R1';'X1';'R2';'X2'})
ylim([-1000 1000])

figure
set(gca, 'fontsize', 12)
for ii = 1:2
    scatter(real(gamma(:,ii))*a, freq,20, 'k',markers(ii,1))
    hold on
    scatter(imag(gamma(:,ii))*a, freq,20,'k',markers(ii,2))
end
plot(k*a, freq, 'k')
% xlim([-pi pi])
title('Dispersion Diagram Derived from Circuit Model')
legend({'\alpha_1 a'; '\beta_1 a';  '\alpha_2 a'; '\beta_2 a';  'Light Line'})
[hx, hy] = format_ticks(gca, {'$-\pi/2$', '$-\pi/4$','$0$', '$\pi/4$', '$\pi/2$', '$3\pi/4$', '$\pi$','$5\pi/4$','$3\pi/2$'},[],(-(pi/2):(pi/4):(1.5*pi)));
xlim([-pi/2 1.5*pi])
ylabel('Frequency [MHz]')
xlabel('Normalized Propagation Constant')
    set(get(gca,'XLabel'),'Units','pixels')
     posLabel = get(get(gca,'XLabel'),'Position');
     set(get(gca, 'Xlabel'),'Position', posLabel+[0 -14 0])

figure
set(gca, 'fontSize', 12)
plot(freq,real(Zin), 'k', freq, imag(Zin), '--k','linewidth',2)
grid on
title('Port 1 Terminal 1 Input Impedance, Terminal 2 Open (Z = R+jX)','fontsize',12)
xlabel('Frequency [MHz]')
ylabel('Ohms')
legend({'R1';'X1'})
ylim([-500 1000])
grid on
set(gca, 'ytick',[-500 -250 0 250 500 750 1000 1250 1500])

figure
plot(freq,real(squeeze(Zterm0(1,1,:))), freq, real(squeeze(Zterm0(1,2,:))), freq, real(squeeze(Zterm0(2,2,:))), freq,imag(squeeze(Zterm0(1,1,:))), freq, imag(squeeze(Zterm0(1,2,:))), freq, imag(squeeze(Zterm0(2,2,:))),'linewidth',2)
legend({'R11';'R12';'R22';'X11';'X12';'X22'})
title('Terminal Impedance Matrix at Port 1', 'fontsize', 12)
xlabel('Frequency [MHz]')
ylabel('Ohms')
ylim([-1000 1000])


