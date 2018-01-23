function varargout = smithchart(gamma)
%SMITHCHART Plot complex reflection coefficient data on a Smith chart
%   [HLINES, HSM] = SMITHCHART(GAMMA) plots complex reflection coefficient
%   data GAMMA on a Smith chart.
%
%   HSM = SMITHCHART draws a Smith chart.
%  
%   HLINES is a column vector of handles to lineseries objects, one handle
%   per plotted line. HSM is the handle to the Smith chart object. The
%   properties of the Smith chart include,
%
%   Property Name    Description
%   -----------------------------------------------------------------------
%   Name           - Object name. (read only)
%   Type           - Type of Smith chart. The choices are: 'Z', 'Y', 'ZY', or 'YZ'
%   Values         - 2*N matrix for the circles
%   Color          - Color for the main chart
%   LineWidth      - Line width for the main chart
%   LineType       - Line type for the main chart
%   SubColor       - Color for the sub chart
%   SubLineWidth   - Line width for the sub chart
%   SubLineType    - Line type for the sub chart
%   LabelVisible   - Visibility of the line labels. The choices are: 'On' or 'Off'
%   LabelSize      - Label size
%   LabelColor     - Label color
% 
%   See also RFCHART.SMITH
%
%   EXAMPLES:
% 
%   % Plot reflection data on a Smith chart
%   S = sparameters('passive.s2p');
%   s11 = rfparam(S,1,1);
%   figure
%   smithchart(s11)
% 
%   % Plot impedance data to a Smith chart
%   z = 0.1*50 + 1j*(0:0.1:50);
%   gamma = z2gamma(z);
%   figure
%   smithchart(gamma)

%   Copyright 2003-2010 The MathWorks, Inc.

narginchk(0,1);
nargoutchk(0,2);

hsm = [];

% Create the Smith chart for nargin == 0
if nargin == 0
    if nargout == 0
        rfchart.smith;
    else
        varargout{1} = rfchart.smith;
        if nargout == 2
            varargout{2} = hsm;
        end
    end
    return
end

% Create the Smith chart if needed for nargin > 0
hold_state = ishold;
if ~hold_state; hsm = rfchart.smith('NeedReset', false); end;

% Call PLOT to plot the complex data on Smith chart
hold on;
if isreal(gamma)
    gamma = complex(gamma);
end
hlines = plot(gamma);
if ~hold_state; hold off; end;

if nargout > 0
    varargout{1} = hlines;
    if nargout == 2
        varargout{2} = hsm;
    end
end