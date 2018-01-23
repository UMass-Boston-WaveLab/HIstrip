function nf = noisefigure(~,cabcd,zs)
%NOISEFIGURE Calculate the noise figure.
%   NF = NOISEFIGURE(H,CABCD,ZS) calculates the noise figure from ABCD
%   noise correlation matrix. The first input is the handle to the data
%   object, the second input is a 2X2XM ABCD noise correlation matrix. The
%   third input is the source impedance.
%
%   See also RFDATA

%   Copyright 2003-2015 The MathWorks, Inc.

narginchk(2,3)
if nargin < 3
    zs = 50;
end
m = size(cabcd,3);
if isscalar(zs)
    zs = zs*ones(m,1);
end
K = physconst('Boltzmann');
T = 290;
nf = zeros(m,1);
for ii = 1:m
    z = [1,conj(zs(ii))]';
    const = 2*K*T*real(zs(ii));
    nf(ii) = 1 + (z' * cabcd(:,:,ii) * z) / const;
end
nf(abs(nf) == 0) = eps;
nf = 10.*log10(abs(nf));