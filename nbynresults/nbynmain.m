close all;
clc
clear all;
%% DEFINE PARAMETERS

rows=3;
sf = 1/1; %scale factor
w1 = 0.01*1.89*sf; %depends on kind of antenna placed on top of HIS
h2 = 0.04*sf; %ground to patch distance
h1 = 0.02*sf; %antenna height above substrate
w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
a=w2+g;       %unit cell size

eps1 = 1;
eps2 = 2.2;

L_sub = 8*a;
w_slot = a; %each HIS row is terminated by an equivalent radiating slot, so slot width is width of one row
L_ant = 0.48*sf; 
f=(100:5:600)*10^6/sf;
omega = 2*pi*f;
L_ant_eff = L_ant+microstripdeltaL(w1, h1, eps1);
N=floor(0.5*L_ant_eff/a); % NUMBER OF COMPLETE UNIT CELLS UNDER ANTENNA HALF
remainder = 0.5*L_ant_eff-N*a; %partial unit cell distance under antenna
botn = floor((L_sub-L_ant_eff)/(2*a))-1; % Number of compelete unit cell not under antenna===HIS


%% Constants
mu0 = pi*4e-7;
eps0 = 8.854e-12;
viaflag = 1;
E = eye(4);

switch rows
    case 7
% %% load/enter per unit length capacitance matrices here
% Number arrangments
%         1 
%7  5  3  2  4  6  8
cap=(1e-12)*([26.38929695       -21.56630659        -1.557032277        -1.548053475        -339.1353558/1000	-338.4299533/1000	-192.911747/1000     -192.728434/1000;
            -21.56630659        115.7996112         -12.5283415         -12.51219546        -558.0638911/1000	-558.742025/1000     -295.2232676/1000	-295.4922494/1000;
            -1.557032277        -12.5283415         98.28730074         -739.8060885/1000	-13.72918238        -354.9318902/1000	-948.7542333/1000	-278.564168/1000;
            -1.548053475        -12.51219546        -739.8060885/1000	98.30450002         -354.9447591/1000	-13.76756897        -278.5456724/1000	-949.2607003/1000;
            -339.1353558/1000	-558.0638911/1000	-13.72918238        -354.9447591/1000	98.01901163         -231.0081113/1000	-13.99610537        -220.9227751/1000;
            -338.4299533/1000	-558.742025/1000    -354.9318902/1000	-13.76756897        -231.0081113/1000	98.12879961         -220.9009198/1000	-14.05487056;
            -192.911747/1000     -295.2232676/1000	-948.7542333/1000	-278.5456724/1000	-13.99610537        -220.9009198/1000	93.77320731         -250.2422739/1000;
            -192.728434/1000     -295.4922494/1000	-278.564168/1000    -949.2607003/1000	-220.9227751/1000	-14.05487056        -250.2422739/1000	93.87730752]);



%cap=cap(1:2, 1:2);%1ROW
%cap=cap(1:4, 1:4); %3ROW
% cap=cap(1:6, 1:6); %5ROW


          

cap0=(1e-12)*([26.03265875      -21.29961615        -1.538662297        -1.544162259        -338.7797159/1000	-338.67567/1000      -199.0698379/1000	-199.2821714/1000;
             -21.29961615       72.45807733         -9.127613888        -9.138017665        -570.9693251/1000	-569.7263095/1000	-311.7712801/1000	-311.7985607/1000;
             -1.538662297       -9.127613888        55.09853384         -749.5065656/1000	-10.38601413        -361.5174008/1000	-982.4815716/1000	-294.6444248/1000;
             -1.544162259       -9.138017665        -749.5065656/1000	55.19732189         -362.2964619/1000	-10.43111649        -294.8090053/1000	-984.7324824/1000;
             -338.7797159/1000	-570.9693251/1000	-10.38601413        -362.2964619/1000	54.94128109         -237.5618211/1000	-10.67868626        -236.8763125/1000;
             -338.67567/1000    -569.7263095/1000	-361.5174008/1000	-10.43111649/1000	-237.5618211/1000	54.95291643         -236.5163057/1000	-10.68392;
             -199.0698379/1000	-311.7712801/1000	-982.4815716/1000	-294.8090053/1000	-10.67868626        -236.5163057/1000	51.00988303         -280.9338645/1000;
             -199.2821714/1000	-311.7985607/1000	-294.6444248/1000	-984.7324824/1000	-236.8763125/1000	-10.68392           -280.9338645/1000	51.04225009]);

% figure(3);         
% imagesc((cap0));         

    case 3
        cap=(1e-12)*[26.29157166	-21.39523049	-1.355778074	-1.941103357;
                    -21.39523049	115.3791135     -12.77146166	-12.24322658;
                    -1.355778074	-12.77146166	94.15856411     -858.2074687;	
                    -1.941103357	-12.24322658	-858.2074687	94.26782472];
                
        cap0=(1e-12)*[26.07389978	-21.24835209	-1.385889529	-1.971260633;
                      -21.24835209	72.27247276     -9.525565843	-8.979896526;
                      -1.385889529	-9.525565843	51.79852842     -936.3465296;
                      -1.971260633	-8.979896526	-936.3465296	51.77420356];
end
HIScap=cap(2:end, 2:end);  
HIScap0=cap0(2:end, 2:end);  

M=size(cap,1);  %minimum 2 - total number of non-GND conductors in multiconductor line including antenna layer
                % this is up to the user - don't have to include all the HIS rows if
                % only some are important to the results.
                
midHISindex=2; %the index of the MTL conductor that is below the antenna.  If even geometry, this can be a 1x2 vector.  If very wide top conductor, this can be a 1xn vector.

Y=zeros(M);

%% input impedance calculation steps
for ii = 1:length(f)
    
    %% Assemble equivalent slot termination
    %gonna replace the line below with a Y matrix that works better
    %    Y(:,:) = HIS_admittance_saber_main(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, f,...
    %                w1, h1, L_ant,eps1, w2, h2, L_sub,eps2,f);  
    %the order of slot labeling  for 7x7 is
    %               1
    %   7   5   3   2   4   6   8
    % (according to our paper)
    
    %diagonal elements of Y matrix are self admittances
    %I suspect these widths also need a length correction but I'm not sure
    %how I'd do that
    Y(1,1) = slotSelfAdmittance(w1,h1, eps1, f(ii));
    for jj=2:M
        Y(jj,jj)=slotSelfAdmittance(w2, h2, eps2, f(ii));
    end
    
    %slots along HIS edge are collinear, uniform, and "infinitesimal-ish" so
    %calculating Y is heavily simplified
    X = (L_sub-L_ant)/2;
    d = a*[0 0 0 0 0 0 0 0;
           0 0 1 1 2 2 3 3; %dist btw HIS edge slots for 7x7
           0 1 0 2 1 3 3 4;
           0 1 2 0 3 1 4 2;
           0 2 1 3 0 4 1 5;
           0 2 3 1 4 0 5 1;
           0 3 3 4 1 5 0 6;
           0 3 4 2 5 1 6 0] +... %distances from ant edge to HIS edge slots
          [0 X sqrt(X^2+a^2) sqrt(X^2+a^2) sqrt(X^2+4*a^2) sqrt(X^2+4*a^2) sqrt(X^2+9*a^2) sqrt(X^2+9*a^2);
           X 0 0 0 0 0 0 0;
           sqrt(X^2+a^2) 0 0 0 0 0 0 0;
           sqrt(X^2+a^2) 0 0 0 0 0 0 0;
           sqrt(X^2+4*a^2) 0 0 0 0 0 0 0;
           sqrt(X^2+4*a^2) 0 0 0 0 0 0 0;
           sqrt(X^2+9*a^2) 0 0 0 0 0 0 0;
           sqrt(X^2+9*a^2) 0 0 0 0 0 0 0];
       
       thetas = asin([0 a/sqrt(X^2+a^2) a/sqrt(X^2+a^2) 2*a/sqrt(X^2+4*a^2) 2*a/sqrt(X^2+4*a^2) 3*a/sqrt(X^2+9*a^2) 3*a/sqrt(X^2+9*a^2)]);
                   
    for jj=2:(M)
        for kk=(jj+1):(M)
            Y(jj,kk)=collInfMutualY(w2, w2, d(jj,kk), 1, f(ii));
            Y(kk,jj)=Y(jj,kk);
        end
        %1,jj and jj,1 elements of Y matrix are not collinear so they have to
        %be calculated differently
        Y(jj, 1) = infMutualY(w1, w2, d(jj, 1), thetas(jj-1), 1, f(ii));
    end
    

    

    
    Zin(ii)=nbynHIStripZin(w1, h1, L_ant,eps1, w2, h2, L_sub, eps2, a, g, rad, cap, cap0, HIScap, HIScap0, f(ii), midHISindex, Y);
    S11(ii) = (Zin(ii)-50)/(Zin(ii)+50);
end

%% make plots
 figure; 
plot(f*1e-9, real(Zin), f*1e-9, imag(Zin),'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('Zin')
legend({'R';'X'})
grid on
set(gca,'fontsize',14)    
% xlim([0.1 0.6])
% ylim([-400 800])



figure; 
plot(f*1e-9, 20*log10(abs(S11)), 'linewidth',2)
xlabel('Frequency [GHz]')
ylabel('|S_{11} (dB)')
grid on
set(gca,'fontsize',14)
% xlim([0.1 0.6])