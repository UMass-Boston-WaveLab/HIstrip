function varargout = plot(varargin)
%PLOT Plot the specified parameters on an X-Y plane.
%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN) plots the specified
%   parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using the
%   default format. All the parameters must have same default format.
%
%   HLINES = PLOT(H, PARAMETER1, ..., PARAMETERN, FORMAT) plots the
%   specified parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using
%   the specified FORMAT. FORMAT must be a valid format for all the
%   parameters.
%
%   Type LISTPARAM(H) to see the valid parameters for plot.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified parameter. The first listed format is the default format for
%   the specified parameter.
%
%   HLINES = PLOT(H, 'BUDGET', ...) plots the specified budget parameters
%   of an RFCKT.CASCADE object. For detail, please type help
%   rfckt.cascade/plot.
%
%   HLINES = PLOT(H, 'MIXERSPUR', ...) plots the spur power of an
%   RFCKT.MIXER object or an RFCKT.CASCADE object that contains one or more
%   mixers. For detail, please type help rfckt.cascade/plot or help
%   rfckt.mixer/plot.
%
%   This method returns a column vector of handles to lineseries objects,
%   one handle per plotted line.
%
%   See also RFCKT, RFCKT.RFCKT/LISTPARAM, RFCKT.RFCKT/LISTFORMAT,
%   RFCKT.RFCKT/TABLE, RFCKT.RFCKT/SMITH, RFCKT.RFCKT/POLAR

%   Copyright 2004-2010 The MathWorks, Inc.

nargoutchk(0,1);

% Get the RFCKT object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfckt:rfckt:plot:NotEnoughInput'));
end

% Get the data object
data = getdata(h);
if isfield(get(h), 'IntpType')
    set(data, 'IntpType', get(h, 'IntpType'));
end

if strcmpi(varargin{2}, 'budget')
    error(message('rf:rfckt:rfckt:plot:NoBudgetDataForThisObject'));
elseif strcmpi(varargin{2}, 'mixerspur')
    error(message('rf:rfckt:rfckt:plot:NoMixerSpurDataForThisObject'));
end
% Plot data by calling the method of RFDATA.DATA object
hlines = plot(data, varargin{2:end});

if nargout == 1
    varargout{1} = hlines;
end