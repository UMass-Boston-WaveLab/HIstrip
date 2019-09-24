close all;
clc
clear all;
%% DEFINE PARAMETERS

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

% %% load/enter per unit length capacitance matrices here
% Number arrangments
%         1 
%7  5  3  2  4  6  8
cap=(1e-12)*abs([33.46204493	-28.22827655	-1.739928478	-1.721216062	-374.8098762/1000	-373.3439528/1000	-217.3607914/1000	-216.8522841/1000
-28.22827655	127.020703	-14.72984097	-14.78096755	-544.6140827/1000	-546.0993423/1000	-292.9779764/1000	-293.37483/1000
-1.739928478	-14.72984097	103.2168733	-749.8532556/1000	-16.1565956	-361.1003223/1000	-984.3146476/1000	-290.4071761/1000
-1.721216062	-14.78096755	-749.8532556/1000	103.268834	-361.0717975/1000	-16.18077495	-290.3931901/1000	-983.9795153/1000
-374.8098762/1000	-544.6140827/1000	-16.1565956	-361.0717975/1000	103.0273435	-235.6747098/1000	-16.49248758	-231.4800603/1000
-373.3439528/1000	-546.0993423/1000	-361.1003223/1000	-16.18077495	-235.6747098/1000	103.033744	-231.4659673/1000	-16.45482113
-217.3607914/1000	-292.9779764/1000	-984.3146476/1000	-290.3931901/1000	-16.49248758	-231.4659673/1000	97.29199065	-270.5524356/1000
-216.8522841/1000	-293.37483/1000	-290.4071761/1000	-983.9795153/1000	-231.4800603/1000	-16.45482113	-270.5524356/1000	97.21426044
]); %7ROW 8BY8
%cap=cap(1:2, 1:2);%1ROW
% cap=cap(1:4, 1:4); %3ROW
% cap=cap(1:6, 1:6); %5ROW
         
      

HIScap=cap(2:end, 2:end);            

cap0=(1e-12)*[33.44452466	28.23279464	1.742718127	1.726828737	377.313140456686/1000	375.6701479/1000	226.3309807/1000	225.800243677983/1000
28.23279464	83.87876933	11.37704373	11.35181733	551.352520760138/1000	551.768498149938/1000	306.5883693592/1000	306.765049783535/1000
1.742718127	11.37704373	60.04783341	755.000382324365/1000	12.78653381	365.665183153584/1000	1.016393833	305.743592781701/1000
1.726828737	11.35181733	755.000382324365/1000	60.02429461	366.020515412755/1000	12.79605168	306.128024070026/1000	1.016157668
377.313140456686/1000	551.352520760138/1000	12.78653381	366.020515412755/1000	59.88811057	240.711773113332/1000	13.15607828	246.817073310121/1000
375.670147875817/1000	551.768498149938/1000	365.665183153584/1000	12.79605168	240.711773113332/1000	59.9249568723863	246.951434029937/1000	13.17456885
226.33098073185/1000	306.5883693592/1000	1.016393833	306.128024070026/1000	13.15607828	246.951434029937/1000	54.40477202	303.379677836058/1000
225.800243677983/1000	306.765049783535/1000	305.743592781701/1000	1.016157668	246.817073310121/1000	13.17456885	303.379677836058/1000	54.34184185
];
% figure(3);         
% imagesc((cap0));         
%cap0=cap0(1:2, 1:2);%1ROW
% cap0=cap0(1:4, 1:4); %3ROW
% cap0=cap0(1:6, 1:6); %5ROW

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
    Y(1,1) = slotSelfAdmittance(w1, h1, eps1, f(ii));
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