function h = createntwk(varargin)
%CREATENTWK Create LC highpass tee ladder filter network
%
%   See also RFCKT.LCHIGHPASSTEE

%   Copyright 2003-2007 The MathWorks, Inc.

% Get object handle
h = varargin{1};

% Get object properties
l = get(h, 'L');
c = get(h, 'C');

ckts = {};
% Create LC highpass tee network
numSections = floor((numel(l)+numel(c)+1)/2);

indx = 0;
for num = 1:numSections
    % For every iteration in the for loop, two circuits
    % are computed - one shunt and one series
    indx = indx+1;
    ckts{indx} = rfckt.seriesrlc('C', c(num));
    indx = indx+1;
    if num <= numel(l)
        ckts{indx} = rfckt.shuntrlc('L', l(num));
    end
end

% Create cascade from individual RLC circuits
set(h, 'Ckts', ckts);