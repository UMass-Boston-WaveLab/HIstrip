function s2_params = deembedsparams(s_params,s1_params,s3_params)
%DEEMBEDSPARAMS De-embed 2N-port S-parameters
%   S2_PARAMS = DEEMBEDSPARAMS(S_PARAMS, S1_PARAMS, S3_PARAMS) de-embeds
%   the S-parameters S_PARAMS by removing the effects of S1_PARAMS and
%   S3_PARAMS. The three inputs must be either three 2Nx2NxK arrays
%   representing 2N-port S-parameter data measured at K frequencies, or
%   three sparameters objects.
%
%   The port ordering of each 2N-port network is
%
%                            1               N+1
%                            --|-----------|--
%                              |    DUT    |
%                            --|-----------|--
%                            N               2N
%
%   S_PARAMS is the measured S-parameter array of the cascaded network
%   S1_PARAMS, S2_PARAMS and S3_PARAMS. S1_PARAMS represents the first
%   network of the cascade, and S3_PARAMS represents the third network. The
%   output S2_PARAMS is the de-embedded S-parameters of the 2N-port device
%   under test (DUT).  The type of S2_PARAMS will be the same as the type
%   of the inputs.
%
%   If the inputs are 2Nx2NxK arrays, DEEMBEDSPARAMS assumes that all of
%   the S-parameters have the same reference impedance and that they all
%   correspond to the same K frequency samples.  If the inputs are provided
%   as sparameters objects, these restrictions are enforced.
%
%  EXAMPLES:
%     % Read measured S-parameters
%     S_measuredBJT = sparameters('samplebjt2.s2p');
%     freq = S_measuredBJT.Frequencies;
%
%     % Calculate S-parameters for the left fixture
%     leftpad = circuit('left');
%     add(leftpad,[1 2],inductor(1e-9))
%     add(leftpad,[2 3],capacitor(100e-15))
%     setports(leftpad,[1 3],[2 3])
%     S_leftpad = sparameters(leftpad,freq);
%
%     % Calculate S-parameters for the right fixture
%     rightpad = circuit('right');
%     add(rightpad,[1 3],capacitor(100e-15))
%     add(rightpad,[1 2],inductor(1e-9))
%     setports(rightpad,[1 3],[2 3])
%     S_rightpad = sparameters(rightpad,freq);
%
%     % De-embed
%     S_DUT = deembedsparams(S_measuredBJT,S_leftpad,S_rightpad);
%
%   See also CASCADESPARAMS, SNP2SMP, sparameters

%   Copyright 2004-2015 The MathWorks, Inc.

narginchk(3,3)

% Check the S-parameters
validateattributes(s_params,{'numeric','sparameters'},{}, ...
    'deembedsparams','',1)
validateattributes(s1_params,{'numeric','sparameters'},{}, ...
    'deembedsparams','',2)
validateattributes(s3_params,{'numeric','sparameters'},{}, ...
    'deembedsparams','',3)

s2_params = rf.internal.deembedsparams(s_params,s1_params,s3_params);
