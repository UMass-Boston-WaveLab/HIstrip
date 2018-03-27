function [ MTL ] = ustripMTLABCD( w1, h1, w2, h2, eps1, eps2, f, len)

mu0 = pi*4e-7;
eps0=8.854e-12;
omega = 2*pi*f;

%see Elek et al., "Dispersion Analysis of the Shielded Sievenpiper 
%Structure Using Multiconductor Transmission-Line Theory" for an
%explanation of what's going on here

[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[Z2, C2G, L2G, epseff2] = microstrip(w2, h2, eps2);

C11=33.39e-12;
C12=29.03e-12;
C2G=117.57e-12;

% cap = [C12, -C12; -C12, C2G+C12]; %Symmetric; see MTL book for where this comes from

cap = [C12, -C12; -C12, C2G]; % HFSS cap


% HFSS model results

[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); 
[~, C2G0, ~, ~] = microstrip(w2, h2, 1);

C110=33.25e-12;
C120=29.18e-12;
C2G0=75.18e-12;

cap0 = [C120, -C120; -C120, C2G0]; %% HFSS cap

%alternative option for calculating PUL capacitance - also not so hot
%really
% cap = SellbergMTLC([0 h1-h2; h1-h2 0],[h1 h2],[w1 w2],[0.0001 0.0001],[1 2],[eps1 eps2]);
% cap0=SellbergMTLC([0 h1-h2; h1-h2 0],[h1 h2],[w1 w2],[0.0001 0.0001],[1 2],[1 1]);


MTL = nbynMTL(cap, cap0, f, len);
% plot(f*1e-9, real(Zw), f*1e-9, imag(Zw),'linewidth',2);
end
