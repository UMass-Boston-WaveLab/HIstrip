function [outmatrix, freq] = extract(varargin)
%EXTRACT Extract the specified network parameters.
%   [OUTMATRIX, FREQ] = EXTRACT(H, OUTTYPE, Z0) extracts the network
%   parameters specified by OUTTYPE.
%
%   OUTTYPE: 'ABCD_PARAMETERS', 'S_PARAMETERS', 'Y_PARAMETERS'
%            'Z_PARAMETERS', 'H_PARAMETERS', 'G_PARAMETERS', 'T_PARAMETERS'
%   Z0: Reference impedance is optional and for S-Parameters only, the
%   default is 50 ohms.
% 
%   See also RFCKT, RFCKT.RFCKT/ANALYZE, RFCKT.RFCKT/CALCULATE

%   Copyright 2003-2009 The MathWorks, Inc.

% Get the circuit object
h = varargin{1};

% Get the data object
data = getdata(h);

% Extract the required data by calling the method of RFDATA.DATA object
[outmatrix, freq] = extract(data, varargin{2:end});