function newy = interpam(h, x, y, newx)
%INTERPAM Interpolate AM using INTERP1 function.
%   INTERPAM(H, X, Y, NEWX) interpolates Y(X) at NEWX by using MATLAB
%   function INTERP1.
%
%   See also RFDATA.POWER
  
%   Copyright 2006-2007 The MathWorks, Inc.

% Set the defaults
newy = [];
if isempty(y)
    return
end
x = x(:);
y = y(:);
newx = newx(:);

method = 'linear';
N = numel(newx);

% Check the data to determine if an interpolation is needed
M = numel(x);
if (M==0)||(M==1) 
    % No need interpolation
    newy(1:N) = y(1);
    newy = newy(:);
elseif (numel(x) == numel(newx)) && all(x == newx)
    % No need interpolation
    newy = y;
else
    % Sort the data 
    [x, xindex] = sort(x);
    y = y(xindex);

    % Interpolate
    newy = interp1(x, y, newx, lower(method), NaN);
    
    % Saturate    
    index = find(newx > x(end));
    if ~isempty(index)
        newy(index) = y(end);
    end  
    
    % Extrapolate for small signal
    index = find(newx < x(1));
    if ~isempty(index)
        lingain = y(1)/x(1);
        newy(index) = lingain*newx(index);
    end
end