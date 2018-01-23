function [y,t] = stepresp(h,ts,n,trise)
%STEPRESP Compute the step response of a rational function object.
%   [Y,T] = STEPRESP(H,TS,N,TRISE) computes the output signal, Y, that
%   the rational function object, H, produces in response to the step input
%   signal U:
%
%     U(k*TS) = k*TS/TRISE, 0 <= k < TRISE/TS
%     U(k*TS) = 1,          TRISE/TS <= k <= N
%
%   H is the handle to the RFMODEL.RATIONAL object. TS is the sample time,
%   in seconds, of the step signal U. N is the total number of sample
%   points of U. TRISE is the rise time of U, the default is 0 seconds.
%   Y is the output signal at corresponding time, T, in seconds.
%
%   Example:
%
%   % Read a .S2P data file
%   S = sparameters('passive.s2p');
%   freq = S.Frequencies;
%   % Get S11 and convert to a TDR transfer function
%   s11 = rfparam(S,1,1);
%   Vin = 1;
%   tdrfreqdata = Vin*(s11+1)/2;
%   % Fit to a rational function object
%   tdrfit = rationalfit(freq,tdrfreqdata);
%   % Define parameters for a step signal
%   Ts = 1.0e-11;
%   N = 10000;
%   Trise = 1.0e-10;
%   % Calculate the step response for TDR and plot it
%   [tdr,t1] = stepresp(tdrfit,Ts,N,Trise);
%   figure
%   plot(t1*1e9,tdr)
%   ylabel('TDR')
%   xlabel('Time (ns)')
%
%   See also RFMODEL.RATIONAL, RFMODEL.RATIONAL/ISPASSIVE,
%   RFMODEL.RATIONAL/TIMERESP, RFMODEL.RATIONAL/FREQRESP,
%   RFMODEL.RATIONAL/WRITEVA, RATIONALFIT

%   Copyright 2015 The MathWorks, Inc.

% Check the input
narginchk(3,4)

if nargin == 3
    trise = 0;
end

% Check the inputs
if isempty(ts) || ~isscalar(ts) || ~isnumeric(ts) || isnan(ts) || ...
        ~isreal(ts) || ts <= 0 || isinf(ts)
    error(message('rf:rfmodel:rational:stepresp:WrongTsInput'))
end
if isempty(n) || ~isscalar(n) || ~isnumeric(n) || isnan(n) || ...
        ~isreal(n) || n <= 0 || isinf(n) || (n ~= floor(n))
    error(message('rf:rfmodel:rational:stepresp:WrongNsampleInput'))
end
if isempty(trise) || ~isscalar(trise) || ~isnumeric(trise) || ...
        isnan(trise) || ~isreal(trise) || trise < 0 || isinf(trise)
    error(message('rf:rfmodel:rational:stepresp:WrongTriseInput'))
end

% Check the property
checkproperty(h)

% Calculate the step response
u = ones(n,1);
if trise > 0
    u(1) = 0;
    k = ceil(trise/ts);
    u(1:k) = (0:k-1)*ts/trise;
end
[y,t] = timeresp(h,u(1:n),ts);