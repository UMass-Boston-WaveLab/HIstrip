function [data, params, freq] = calculate(varargin)
%CALCULATE Calculate the specified parameters.
%   [DATA, PARAMS, FREQ] = CALCULATE(H,PARAMETER1, ...,PARAMETERN,FORMAT) 
%   calculates the specified parameters for the RFCKT object and returns
%   them in cell array data.
%
%   The first input is the handle to the RFCKT object, the last input is
%   the FORMAT, and the other inputs (PARAMETER1, ..., PARAMETERN) are the
%   parameters that can be visualized from the RFCKT object. 
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object.  
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified PARAMETER.
%
%   See also RFCKT, RFCKT.RFCKT/ANALYZE, RFCKT.RFCKT/LISTPARAM,
%   RFCKT.RFCKT/LISTFORMAT

%   Copyright 2003-2010 The MathWorks, Inc.

% Get the circuit object
h = varargin{1};

% Get the data object
data = getdata(h);
if isfield(get(h), 'IntpType')
    set(data, 'IntpType', get(h, 'IntpType'));
end

% Calculate the required data by calling the method of RFDATA.DATA object
[data, params, freq] = calculate(data, varargin{2:end});