function [hlines, hsm] = smith(varargin)
%SMITH Plot the specified parameters on a Smith chart.
%   [HLINES, HSM] = SMITH(H, PARAMETER1, ..., PARAMETERN) plots the
%   specified parameters on a Z Smith chart. The first input is the
%   handle to the RFCKT object, and the other inputs PARAMETER1, ...,
%   PARAMETERN are the parameters to be visualized.
%
%   [HLINES, HSM] = SMITH(H, PARAMETER1, ..., PARAMETERN, TYPE) plots the
%   specified parameters on the specified TYPE of Smith chart. TYPE could
%   be 'Z', 'Y', or 'ZY'.
%
%   Type LISTPARAM(H) to see the valid parameters for the RFCKT object. 
%
%   This method has two outputs. The first is a column vector of handles to
%   lineseries objects, one handle per plotted line. The second output is
%   the handle to the Smith chart. 
% 
%   See also RFCKT, RFCKT.RFCKT/LISTPARAM, RFCKT.RFCKT/POLAR,
%   RFCKT.RFCKT/PLOT

%   Copyright 2004-2010 The MathWorks, Inc.

% Get the RFCKT object
h = varargin{1};

% Get the data object
data = getdata(h);

% Plot data by calling the method of RFDATA.DATA object
[hlines, hsm] = smith(data, varargin{2:end});