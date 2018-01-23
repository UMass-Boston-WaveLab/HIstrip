function varargout = plotyy(varargin)
%PLOTYY Plot the specified parameters on an X-Y plane with Y-axes on both
%the left and right sides.
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER) plots the specified
%   parameter on an X-Y plane using a predefined pair of formats. For
%   S-parameters, PLOTYY uses 'dB' on the left Y-axis and 'Degrees' on the
%   right Y-axis. The first input H is the handle to the RFCKT object, and
%   the second input PARAMETER is the parameter to be visualized.
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object.
%
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER1, ..., PARAMETERN) plots
%   the parameters PARAMETER1, ..., PARAMETERN on an X-Y plane using the
%   pre-defined pair of formats.  
%
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER, FORMAT1, FORMAT2) plots
%   the PARAMETER on an X-Y plane using the specified formats: FORMAT1 for
%   the left Y-axis and FORMAT2 for the right Y-axis.
%
%   Type LISTFORMAT(H, PARAMETER) to see the valid formats for the
%   specified parameter. 
%
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER1, ..., PARAMETERN,
%   FORMAT1, FORMAT2) plots the parameters PARAMETER1, ..., PARAMETERN on
%   an X-Y plane using the specified formats: FORMAT1 for the left Y-axis
%   and FORMAT2 for the right Y-axis.
%
%   [AX, HLINES1, HLINES2] = PLOTYY(H, PARAMETER1_1, ..., PARAMETER1_N1,
%   FORMAT1, PARAMETER2_1, ..., PARAMETER2_N2, FORMAT2) plots the
%   parameters PARAMETER1_1, ..., PARAMETER1_N1 on the left Y-axis using
%   FORMAT1, and PARAMETER2_1, ..., PARAMETER2_N2 on the right Y-axis using
%   FORMAT2. 
%     
%   This method returns the handles of the two axes created in AX and the
%   handles of the graphics objects from each plot in HLINES1 and HLINES1.
%   AX(1) is the left axes and AX(2) is the right axes. 
%
%   See also RFCKT, RFCKT.RFCKT/LISTPARAM, RFCKT.RFCKT/LISTFORMAT,
%   RFCKT.RFCKT/PLOT

%   Copyright 2006-2010 The MathWorks, Inc.

nargoutchk(0,3);

% Get the RFCKT object
h = varargin{1};

% Check the input number
if nargin < 2
    error(message('rf:rfckt:rfckt:plotyy:NotEnoughInput'));
end

% Get the data object
data = getdata(h);

% Plot data by calling the method of RFDATA.DATA object
[ax, hlines1, hlines2] = plotyy(data, varargin{2:end});

if nargout > 0
    varargout{1} = ax;
    if nargout > 1
        varargout{2} = hlines1;
        if nargout == 3
            varargout{3} = hlines2;
        end
    end
end