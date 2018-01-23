function [pl, freqout] = calcpout(h,pavs,freq,zl,zs,z0,varargin)
%CALCPOUT Calculate output power.
%   [PL, FREQOUT] = CALCPOUT(H, PAVS, FREQ, ZL, ZS, Z0) calculates the
%   output power.
%
%   See also RFCKT

%   Copyright 2006-2009 The MathWorks, Inc.

narginchk(6,8);

p = inputParser;
addParameter(p,'isspurcalc',false);
parse(p,varargin{:});

% Calculate output power
freqout = convertfreq(h,freq,false,'isSpurCalc',p.Results.isspurcalc);
idx = find(freqout >= 0);
freq = freq(idx);
nfreq = length(freq);
if ~isscalar(pavs); pavs = pavs(idx); end;
if ~isscalar(zl); zl = zl(idx); end;
if ~isscalar(zs); zs = zs(idx); end;
if ~isscalar(z0); z0 = z0(idx); end;
[type,cktparams,cktz0] = spurnwa(h,freq,'isSpurCalc',p.Results.isspurcalc);
s3d = convertmatrix(rfdata.network,cktparams,type,'S_Parameters',cktz0,z0);
gammas = z2gamma(zs, z0);
gammal = z2gamma(zl, z0);
gammaout = s3d(2,2,:) + s3d(1,2,:) .* s3d(2,1,:) .* gammas ./ ...
    (1 - s3d(1,1,:) .* gammas);
gammaout = reshape(gammaout, [nfreq,1]);
temp = (abs(1 - reshape(s3d(1,1,:),[nfreq,1]) .* gammas) .^ 2);
temp2 = temp .* (abs(1 - gammaout .* gammal) .^ 2);
temp3 = (1 - abs(gammas).^2) .* (abs(reshape(s3d(2,1,:), [nfreq,1])) .^ 2);
temp2(temp2 == 0) = eps;
gt = (temp3 .* (1 - abs(gammal) .^ 2)) ./ temp2;
pl = 10*log10(abs(gt)) + pavs;