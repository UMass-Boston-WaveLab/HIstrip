function [ Zin ] = seriesHISstub_J( f, w_ant, w2, h_ant, rad, eps0, eps1, eps2, g, L1,L2, startpos, visflag, L_sub, W_sub, H_sub, a)
%SERIESHISSTUB finds the two-terminal (upper to ground) input impedance of a
%combination of two HIS-backed stubs in series (i.e. differential feed like
%a dipole)
%% All values are scaled from Best & Hanna paper 
% they use a folded straight 1/2lambda wire dipole at 300Mhz
    
%HIS Scalable dimensions

% W_Sub = 1.12*lambda
% L_Sub = 1.12*lambda
% H_sub = 0.04*lambda
% w2 = 0.12*lambda.......HIS Patch width
% g = 0.02*lambda........gap between patches
% rad = 0.005*lambda.....via Radius

%Dipole scalable dimensions 

% w_ant = 0.01*lambda
% h_ant = 0.02*lambda 
% L_ant = .48*lambda....We divide this into L1 & L2 for Zin solutions of individual stubs 


%% Antenna Dimensions
w_ant = 0.0005;                                                          
h_ant = 0.001; 
L1 = 0.012;                                                             
L2 = 0.012;

%% HIS/Substrate Dimensions
w2 = 0.006;                                                           
g = 0.001;                                                                
rad = .00025;
a = 0.007;     
H_sub = 0.002;  
L_sub = 0.056;
W_sub = 0.056;
startpos = a/2;                                                             
                                                           
%% Constants 
eps0 = 8.854e-12;
eps1 = 1;
eps2 = 2.2;       
viaflag = 1;                                                              
startpos = 0;                                                              
mu0 = pi*4e-7;
c = 3e8;
%f = 6e9;
%% Vectors for Para Analysis 

f = 2e9:250e6:7e9;
%h_ant = [0.0001:0.001:0.005];
%t = [0.0001:0.001:0.005];

%% Frequency & Para Sweep
%consider parfor once whole code is implemented

for ii=1:length(f)
   %for nn= 1:length(t)
    
        Zin1(:,:,ii) = HISstub_J(f(ii), w_ant, w2, h_ant,  rad, eps0, eps1, eps2, g, L1, startpos, viaflag, 4*a,8*a, H_sub,  a)
        Zin2(:,:,ii) = HISstub_J(f(ii), w_ant, w2, h_ant,  rad, eps0, eps1, eps2, g, L2, startpos, viaflag, 4*a,8*a, H_sub,  a)
        Y = inv((Zin1(:,:,ii)+ Zin2(:,:,ii)));
        Zin(ii,:,:) = 1/Y(1,1);
        f(:)
        h_ant(:)
        
   %end
end


%% Graphing Para-Sweep 
   
%Hant_1 = real(Zin(:,1));
%Hant_2 = real(Zin(:,2));
Re = sqrt(real(Zin).^2)
Im = imag(Zin);
X = sqrt(Re.^2+Im.^2)/sqrt(2);
T = real(Zin);
%% Import Simulation data
   %nominal Z values HFSS vs Model
   
            data = csvread('Para_NomZin.csv', 1, 0);
            F = data(1:21,1);
            Zh1 = data(1:21, 2);
            D = Re(17,1)
            G = [F, Zh1];
            HfssZin = G(17,2);
            
            figure
            plot(F,Zh1,'b',F, Re,'r',F(17,1), HfssZin,'bo', F(17,1), Re(17,1), 'ro')
            grid on 
            set(gca, 'fontSize', 16)
            xlabel('Frequency Ghz')
            ylabel('Ohms (\Omega)')
            legend({'HFSS Simulation';'Transmission Line Model';'HFSS Zin = 153.26\Omega'; 'Model Zin = 125.85\Omega'}, 'location','northwest')
            title('Zin Vs. Freq for Half-Wave Dipole Backed by HIS, L = 0.48\lambda')

         
            
            % %% Para antenna Height 
% data = csvread('Para_antH.csv', 1, 0);
% 
% F = data(1:21,1);
% 
% 
% 
% Zh1 = data(1:21, 2);
% Zh2 = data(1:21, 3);
% Zh3 = data(1:21, 4);
% Zh4 = data(1:21, 5);
% Zh5 = data(1:21, 6);
% Zh6 = data(1:21, 7);
% Zh7 = data(1:21, 8);
% 
% %[fsim, Zsim]=TestREadHfss('');
% %Zins = HISstub(1e6*(1:1000), 0.02, 0.12, 0.02, 0.04, 0.005, 1, 2.2, 0.02, 0.48, 0, 4*0.14,8*0.14,1);
% %Z = squeeze(Zins(1,1,:));
% 
% 
% figure
% plot(F,Zh1,'b-.',F , Zh2, 'r-.', F, Zh7,'k-.', F, Re(:,1), 'b', F, Re(:,2), 'r', F, Re(:,5), 'k')
% grid on 
% set(gca, 'fontSize', 16)
% xlabel('Frequency Ghz')
% ylabel('Ohms(\Omega)')
% legend({'ant_h_1HFSS = 0.0001m';'ant_h_2 = 0.0011m';'ant_h_3 = 0.0051m';'ant_h_1Model = 0.0001m';'ant_h_2 = 0.0011m';'ant_h_3 = 0.0051m' }, 'location','northwest')
% title('Zin Vs. Freq for Half-Wave Dipole at Variable Antenna Heights, L = 0.48\lambda')

end

%% Non-swept parameters
%%invoke to check single values of the parameter sweep. 

%             Zin1 = HISstub_J(f, w_ant, w2, h_ant,  rad, eps0, eps1, eps2, g, L1, startpos, viaflag, 4*a,8*a, H_sub,  a)
%             Zin2 = HISstub_J(f, w_ant, w2, h_ant,  rad, eps0, eps1, eps2, g, L2, startpos, viaflag, 4*a,8*a, H_sub,  a)
%             
%             for ii = 1:length(f)
%                 Y = inv((Zin1(:,:,ii)+ Zin2(:,:,ii)));
%                 Zin(ii,:,:) = 1/Y(1,1);
%             end


