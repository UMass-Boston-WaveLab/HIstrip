function list = listparam(varargin)
%LISTPARAM List the valid parameters for the RFCKT object.
%   LIST = LISTPARAM(H) lists the valid parameters for plot.
%
%   LIST = LISTPARAM(H, 'BUDGET') lists the valid parameters for budget
%   plot.
%
%   See also RFCKT, RFCKT.RFCKT/LISTFORMAT, RFCKT.RFCKT/PLOT, 
%   RFCKT.RFCKT/TABLE, RFCKT.RFCKT/SMITH, RFCKT.RFCKT/ANALYZE, 
%   RFCKT.RFCKT/CALCULATE  

%   Copyright 2003-2010 The MathWorks, Inc.

h = varargin{1};

% Get the data object
data = getdata(h);

% Get the list by calling the method of RFDATA.DATA object
list = listparam(data, varargin{2:end});