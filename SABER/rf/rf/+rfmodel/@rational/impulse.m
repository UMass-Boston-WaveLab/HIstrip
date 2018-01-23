function [resp, t] = impulse(h, ts, n)
%IMPULSE Compute the impulse response of a rational function object.
%   [RESP, T] = IMPULSE(H, TS, N) computes the impulse response, RESP, of
%   the rational function object, H, over the time period specified by TS
%   and N. 
%
%   H is the handle to the RFMODEL.RATIONAL object. TS is the sample time.
%   N is the total number of samples. RESP is the impulse response, and T
%   is the time samples of the impulse response. 
%
%   See also RFMODEL.RATIONAL, RFMODEL.RATIONAL/ISPASSIVE, 
%   RFMODEL.RATIONAL/TIMERESP, RFMODEL.RATIONAL/STEPRESP,
%   RFMODEL.RATIONAL/FREQRESP, RFMODEL.RATIONAL/WRITEVA, RATIONALFIT

%   Copyright 2006-2009 The MathWorks, Inc.

% Check the input
narginchk(3,3);

% Check the inputs
if isempty(ts) || ~isscalar(ts) || ~isnumeric(ts) || isnan(ts) ||       ...
        ~isreal(ts) || ts <= 0 || isinf(ts)
    error(message('rf:rfmodel:rational:impulse:WrongTsInput'));
end
if isempty(n) || ~isscalar(n) || ~isnumeric(n) || isnan(n) ||           ...
        ~isreal(n) || n <= 0 || isinf(n) || n ~= floor(n)
    error(message('rf:rfmodel:rational:impulse:WrongNInput'));
end

% Check the property
checkproperty(h);
% Get the property
poles = h.A;
c = h.C;
d = h.D;   
delay = h.Delay;

% Calculate time domain impulse response
delaynum = floor(delay/ts);
po_rank = length(c);
stop_t = ts*(n-1);
t = linspace(0,stop_t,n);
k=1;
resp = zeros(1,n);
if delaynum < n
    while k <= po_rank
        if imag(poles(k)) ~=0
            rep = real(poles(k));
            imp = imag(poles(k));
            rec = real(c(k));
            imc = imag(c(k));
            temp_t = 2*exp(t*rep).*(rec*cos(imp*t)-imc*sin(imp*t));
            k = k+2;
        else
            temp_t = c(k)*exp(t*poles(k));
            k = k+1;
        end
        resp = resp+temp_t;
    end
    if d ~= 0
       resp(1) = resp(1)+d/ts;
    end 
    resp(delaynum+1:n) = resp(1:n-delaynum);
    resp(1:delaynum) = 0;
else
    error(message('rf:rfmodel:rational:impulse:TooSmallNNInput'));
end
resp = real(resp(:));
t = t(:);