function [result,varargout] = ispassive(sp,varargin)
%ISPASSIVE Check passivity of N-port S-parameters
%   [RESULT,IDX_NON_PASSIVE] = ISPASSIVE(S_PARAMS) checks the passivity of
%   S-parameter data. If the S-parameters are passive at every frequency,
%   the RESULT is TRUE. Otherwise, it is FALSE. It also optionally returns
%   IDX_NON_PASSIVE, the indicies of the non-passive S-parameters.
%
%   S_PARAMS is either an sparameters object, or a complex NxNxK array
%   representing N-port S-parameters measured at K frequencies referenced
%   to 50 ohms.
%
%   [...] = ISPASSIVE(S_PARAMS_DATA,'Impedance',Z0) checks the passivity of
%   S-parameter data that is referenced to the impedance Z0, which can be
%   in general complex. S_PARAMS_DATA must be a a complex NxNxK array. Z0
%   is the reference impedance.  The default is 50.
%
%   [...] = ISPASSIVE(FIT_OBJ) checks the passivity of a scalar
%   RFMODEL.RATIONAL object (which is the output of the rationalfit
%   function).
%
%   % EXAMPLE:
%
%   % Read a Touchstone data file
%   S = sparameters('measured.s2p');
%
%   % Check the passivity of the S-parameters
%   [passivevar,idx] = ispassive(S);
%
%   % Get the non-passive S-parameters
%   if ~passivevar
%       nonpassivevals = S.Parameters(:,:,idx);
%   end
%
%   % Check the passivity of the rationalfit of S21
%   s21 = rfparam(S,2,1);
%   freq = S.Frequencies;
%   fit = rationalfit(freq,s21);
%   ispass = ispassive(fit);
%
%   See also MAKEPASSIVE, S2TF, SNP2SMP, RATIONALFIT, sparameters
 
%   Copyright 2009-2015 The MathWorks, Inc.

import rf.internal.PassivityCalculator

narginchk(1,3)

% Validate the input S-parameters
if isempty(sp) || ~isnumeric(sp)
    validateattributes(sp,{'numeric','sparameters'},{'nonempty'}, ...
        'ispassive','S-Parameters',1)
end
[nfreq,s_params] = CheckNetworkData(sp,'N','S_PARAMS');

% Parse inputs
P = inputParser;
addRequired(P,'SParameterData')
addParameter(P,'Impedance',50)
parse(P,sp,varargin{:})

% Grab the Impedance value
z0 = P.Results.Impedance;

% Validate z0
z0 = CheckZ(z0,nfreq,'Z0');

% Calculate passivity
s_params = PassivityCalculator.makeImpedanceReal(s_params,z0);
thresh = PassivityCalculator.DefaultThreshold;
if nargout > 1
    varargout{1} = PassivityCalculator.findNonPassiveIndicies(s_params,thresh);
    result = isempty(varargout{1});
else
    result = PassivityCalculator.ispassive(s_params,thresh);
end