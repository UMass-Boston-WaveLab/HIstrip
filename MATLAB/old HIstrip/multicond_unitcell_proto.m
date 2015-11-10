function [ ABCD, gameig] = multicond_unitcell_proto( a, w1, w2, h1, h2, via_rad, eps1, eps2, freq, loadgap)
%MULTICOND_UNITCELL result is the 4x4 ABCD matrix of the HIstrip unit cell
%using the "multiconductor TL" formulation
gap = a-w2;
omega = 2*pi*freq;
mu0 = pi*4e-7;
eps0=8.854e-12;
c = 1/sqrt(mu0*eps0);
test_line = false;

%keep in mind that w/h for via_calc is outside the range tested in Goldfarb
%& Pucel's results - ours is more than 3, they only checked up to 2.2
%d/h is also too small (0.0397 vs. their minimum of 0.2)
if via_rad ~=0
    L_via = via_calc(h2, via_rad);
    Lmat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 (1/(j*omega*L_via)) 0 1];
else
    Lmat = eye(4);
end

[Cgap,Cp] = microstripGapCap2(w2,h2,eps2,gap, freq);
[~,Cptop] = microstripGapCap2(w1,h1-h2,eps1,gap, freq);
if loadgap ~=0
    [CL, CpL] = microstripGapCap2(w1, h1-h2, eps1, loadgap, freq);
    Cload = [1 0 1/(j*omega*Cgap) 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
else
    Cload = eye(4);
end

 
%see Elek et al., "Dispersion Analysis of the Shielded Sievenpiper 
%Structure Using Multiconductor Transmission-Line Theory" for an
%explanation of what's going on here
[~, C12, L12, ~] = microstrip(w1, h1-h2, eps1); %I'm using microstrip per-unit-length capacitance values here
[Z2, C2G, L2G, epseff2] = microstrip(w2, h2, eps2);

cap = [C12, -C12; -C12, C2G+C12]; %Symmetric; see MTL book for where this comes from

[~, C120, ~, ~] = microstrip(w1, h1-h2, 1); 
[~, C2G0, ~, ~] = microstrip(w2, h2, 1);
cap0 = [C120, -C120; -C120, C2G0+C120]; %symmetric
ind = mu0*eps0*inv(cap0); %symmetric

Z = (j*omega*ind); %symmetric
Y = (j*omega*cap); %symmetric
Gam = sqrtm(Z*Y);

[T,gamsq]=eig(Z*Y); %Z*Y not necessarily symmetric
%get gamma^2 because if you do the eigenvalues of sqrtm(Z*Y) you have a
%root ambiguity

gameig = [sqrt(gamsq(1,1)) 0; 0 sqrt(gamsq(2,2))];

Zw = Gam\Z; %symmetric 
Yw = Y/Gam; %symmetric


%L_via is too large (I know this because the band gap is too low, and
%halving L_via fixes it)


if test_line
    Cmat = eye(4);
    Cpmat = eye(4);
    Lmat = eye(4);
    Cptopmat = eye(4);
    
    %be careful with cosh - it produces 1 for input 0, so cosh(diagonal matrix)
    %is not diagonal as intended, the off-axis elements will be 1
    %I am dealing with T and gameig properly here - see MTL book by Faria
    MTL = [T*[cosh(gameig(1,1)*a/2) 0; 0 cosh(gameig(2,2)*a/2)]/T,...
        (T*sinh(gameig*a/2)/T)*Zw; Yw*T*sinh(gameig*a/2)/T, ...
        Yw*T*[cosh(gameig(1,1)*a/2) 0; 0 cosh(gameig(2,2)*a/2)]/T*Zw];
else

    %gap cap split in half because that's where the ref plane is
    Cmat = [1 0 0 0; 0 1 0 1/(j*omega*Cgap*2); 0 0 1 0; 0 0 0 1];
    Cpmat = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 j*omega*Cp 0 1];
    Cptopmat = [1 0 0 0; 0 1 0 0; j*omega*Cptop -j*omega*Cptop 1 0; -j*omega*Cptop j*omega*Cptop 0 1]; %this is a problematic capacitor
    % because the expression was for a gap in the "top" line but the gap is
    % actually in the "ground" which is physically much bigger (would it be
    % reasonable to say Cptopmat = Cptop*w1/w2?)
%     Cptopmat = eye(4);
    
    
    %be careful with cosh - it produces 1 for input 0, so cosh(diagonal matrix)
    %is not diagonal as intended, the off-axis elements will be 1
    %I am dealing with T and gameig properly here - see MTL book by Faria
    MTL = [T*[cosh(gameig(1,1)*w2/2) 0; 0 cosh(gameig(2,2)*w2/2)]/T,...
        (T*sinh(gameig*w2/2)/T)*Zw; Yw*T*sinh(gameig*w2/2)/T, ...
        Yw*T*[cosh(gameig(1,1)*w2/2) 0; 0 cosh(gameig(2,2)*w2/2)]/T*Zw];
end

ABCD = Cmat*Cpmat*Cptopmat*MTL*Lmat*Cload*MTL*Cptopmat*Cpmat*Cmat;

end

