function cascdata = cascadesparams(varargin)
%CASCADESPARAMS Cascade S-parameters
%   S_PARAMS = CASCADESPARAMS(S1_PARAMS, S2_PARAMS, ..., SQ_PARAMS)
%   cascades the S-parameters of Q networks: S1_PARAMS, S2_PARAMS, ...,
%   SQ_PARAMS. All inputs must be either three 2Nx2NxK arrays of K 2N-port
%   S-parameters, or 2N-port sparameters objects. The output S_PARAMS is
%   the cascaded S-parameters of the 2N-port network.  The type of S_PARAMS
%   will be the same as the type of the inputs.
%
%   The port ordering of each 2N-port network is
%
%                          1               N+1
%                          --|-----------|--
%                            |    DUT    |
%                          --|-----------|--
%                          N               2N
%
%   Based on this ordering, ports N+1 through 2N of the first network are
%   connected to ports 1 through N of the second network.  If any input
%   S-parameters have a different port ordering, use the SNP2SMP function
%   to reorder the port indexes.
%
%   S_PARAMS = CASCADESPARAMS(S1_PARAMS, S2_PARAMS, ..., SQ_PARAMS, Nconn)
%   cascades the S-parameters of Q networks: S1_PARAMS, S2_PARAMS, ...,
%   SQ_PARAMS based on the number of cascade connections between networks
%   specified by Nconn. Nconn is a positive scalar or a vector of size Q-1.
%   When using this syntax, the number of ports in each network does not
%   have to be even, nor do all the networks need to have the same number
%   of ports.
%
%   The ith element of Nconn indicates the number of connections between
%   the ith and the (i+1)th networks.  If Nconn is a scalar, the same
%   number of connections are made between each pair of networks.
%   CASCADESPARAMS always establishes connections between the last
%   Nconn(i) ports of the ith network and the first Nconn(i) ports of the
%   (i+1)th network.
%
%   The ports of the entire cascaded network are the unconnected ports of
%   each individual network, taken in order from the first network to the
%   Qth network.
%
%   If the inputs are 2Nx2NxK arrays, CASCADESPARAMS assumes that all of
%   the S-parameters have the same reference impedance and that they all
%   correspond to the same K frequency samples.  If the inputs are provided
%   as sparameters objects, these restrictions are enforced.
%
%   See also DEEMBEDSPARAMS, SNP2SMP, sparameters

%   Copyright 2004-2015 The MathWorks, Inc.

narginchk(1,Inf)

if (nargin > 1) && (isreal(varargin{end}) && isvector(varargin{end}))
    % Assume last input is "nconn"
    numsparams = nargin - 1;
    nconn = varargin{end};
else
    % Assume all inputs are sparameters objects: use default "nconn"
    numsparams = nargin;
    nconn = 'default';
end

% Validate 
sparamdata = varargin(1:numsparams);
for n = 1:numsparams
    validateattributes(sparamdata{n},{'numeric','sparameters'},{}, ...
        'cascadesparams','',n)
    CheckNetworkData(sparamdata{n},'N','S_PARAMS');
end

cascdata = rf.internal.cascadesparams(sparamdata,nconn);
