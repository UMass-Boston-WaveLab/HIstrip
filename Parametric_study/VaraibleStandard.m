%% This file is used for variable standardization in the HISTRIP project. 
% This is the standardized execution script which should be used to call
% all other functions in a routine. 
%(1) All geometries are based on the Steve Best/Drayton paper which evaultures
%       several antennas above a HIS @300MHz
%(2) the scale factor (sf) reflects the change in geometries for a
%       different frequency mainly for 6Ghz our sf will be 300E6/6E9 = 1/20
%(3) you may want to sweep frequencies. in that case:
%       you may want the sf to change with the sweep - sfflag = 1
%       you may want the sf to stay the same based on the operating
%           frequency - (you don't want the geometry to change)- sfflag = 0
%(4) If a function, or sub-fuction, you're calling uses a variable not
%    defined here (1) remove the variable(s) from the function file
%                       and declare them here (the execution script)
 
%% Constants
c = 3e8;
eps2 = 2.2; %need to check rest of code is named the same for these values
eps0 = 8.854e-12;
mu0 = pi*4e-7;
viaflag = 1;
startpos = 0;
sfflag = 0; %read above for setting sfflag
parametric_flag = 0; %set for parametric sweep

%% Frequency Components
f = 3e9:100e6:6.5e9;
omega = 2*pi.*f;
lambda0 = c./f; %freespace wavelength
lambda = c./(f.*sqrt(eps2)); %wavelength in material
k0 = 2*pi./lambda0;
k = 2*pi./lambda;

if sfflag == 1 %sf scales with frequency
        sf = 300e6./f;
    else sfflag = 0;
        sf = 300e6/f(1,1);
end

%% Geometry
    %% Antenna
w_ant = 0.01*sf; %depends on kind of antenna placed on top of HIS
h_ant = 0.02*sf; %antenna height above substrate
L_ant = .48*sf;  %based on length of dipole at 6ghz which is .48lamba
    %% HIS 
H_sub = 0.04*sf; %ground to patch distance
L_sub = 1.12*sf; %substrate length
W_sub = 1.12*sf; %substrate width
w2 = .12*sf;     %patch width
rad = .005*sf;   %via radius
g = 0.02*sf;     %patch spacing
a =.14*sf;       %edge to edge patch length
len =.14*sf;     %length of microstrip ((a) for MTL section) segment above patches 
