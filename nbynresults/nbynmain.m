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

cap=(1e-12)*[26.0810222263558       -21.309327302233        -1.53369520724211       -1.53334236498816       -334.940289915075/1000	-335.01106182871/1000	-190.44884750572/1000	-190.434535251413/1000
             -21.309327302233       115.298305424774        -12.3990364576114       -12.4077295829365       -560.682421521799/1000	-560.904302921997/1000	-296.395031282791/1000	-296.400482578556/1000
             -1.53369520724211      -12.3990364576114       98.0150178061708        -739.694210091396/1000	-13.6388151645985       -354.840397126214/1000	-947.3270413265/1000	-278.034219534066/1000	
             -1.53334236498816      -12.4077295829365       -739.694210091396/1000	98.0433197138981        -354.731725116177/1000	-13.6613814000693       -278.030589519426/1000	-947.192213938867/1000	
             -334.940289915075/1000	-560.682421521799/1000	-13.6388151645985       -354.731725116177/1000	97.8116346160382        -230.880344861278/1000	-13.9060589178966       -220.424771797978/1000	
             -335.01106182871/1000	-560.904302921997/1000	-354.840397126214/1000	-13.6613814000693       -230.880344861278/1000	97.8733324014165        -220.487172447691/1000	-13.9233112657497	
             -190.44884750572/1000	-296.395031282791/1000	-947.3270413265/1000	-278.030589519426/1000	-13.9060589178966       -220.487172447691/1000	93.5629506015802        -249.289676117687/1000	
             -190.434535251413/1000	-296.400482578556/1000	-278.034219534066/1000	-947.192213938867/1000	-220.424771797978/1000	-13.9233112657497       -249.289676117687/1000	93.5959631060769];


%cap=cap(1:2, 1:2);%1ROW
%cap=cap(1:4, 1:4); %3ROW
% cap=cap(1:6, 1:6); %5ROW

cap0=(1e-12)*[25.8736168231532      -21.1626220076164       -1.53237189989162       -1.53149357886327       -337.016602125515/1000	-336.790877095937/1000	-198.184960663145/1000	-198.243769562726/1000
             -21.1626220076164      72.1033256413102        -9.03719726808568       -9.02261705320107       -571.151265816757/1000	-570.907028869739/1000	-312.322480218773/1000	-312.461052802132/1000	
             -1.53237189989162      -9.03719726808568       54.9230269767165        -748.831748972935/1000	-10.3084168600138       -361.443901642032/1000	-982.690741766945/1000  -294.590205593849/1000	
             -1.53149357886327      -9.02261705320107       -748.831748972935/1000	54.9120252922855        -361.653998358165/1000	-10.3158574958713       -294.522270301057/1000	-983.503617187412/1000	
             -337.016602125515/1000	-571.151265816757/1000	-10.3084168600138       -361.653998358165/1000	54.7877218917472        -237.296119264042/1000	-10.6275455198255       -236.606974254244/1000	
             -336.790877095937/1000	-570.907028869739/1000	-361.443901642032/1000	-10.3158574958713       -237.296119264042/1000	54.7620269750663        -236.410349112416/1000	-10.6262059734689	
             -198.184960663145/1000	-312.322480218773/1000	-982.690741766945/1000	-294.522270301057/1000	-10.6275455198255       -236.410349112416/1000	50.9685100304226        -280.773972126474/1000	
             -198.243769562726/1000	-312.461052802132/1000	-294.590205593849/1000	-983.503617187412/1000	-236.606974254244/1000	-10.6262059734689       -280.773972126474/1000	50.9765809812836];
          
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
           0 0 1 1 2 2 3 3; %dist btw HIS edge slots for 7x7 (smaller sizes can use an appropriately sized upper left hand chunk of this matrix)
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