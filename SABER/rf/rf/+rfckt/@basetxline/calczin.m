function Z_in = calczin(h, freq, zterm)
%Z_IN = CALCZIN(H, FREQ, ZTERM) calculate the input impedance of a
%transmission line stub.
%
%   See also RFCKT.BASETXLINE

%   Copyright 2004-2007 The MathWorks, Inc.

% must call calckl first, calckl sets pv, loss and z0.
e_negkl = calckl(h, freq);
termination = get(h, 'Termination');
z0 = get(h, 'Z0');
mode = get(h, 'StubMode');

% check if StubMode is NotAStub
if strcmpi(mode, 'NotAStub')
    error(message('rf:rfckt:basetxline:calczin:StubMode'));
end

% check zterm
if nargin > 2
    [row, col] = size(squeeze(zterm));
    if (~(row == 1) && ~(col == 1)) || ~isnumeric(zterm) ||             ...
            any(isnan(zterm))
        error(message('rf:rfckt:basetxline:calczin:ZTerm'));
    end
    zterm = zterm(:);
    % Check terminating impedance
    if length(zterm) ~= length(freq) && length(zterm) ~= 1
        error(message('rf:rfckt:basetxline:calczin:ZTermFreq'));
    end
elseif strcmpi(termination, 'Short')
    zterm = 0;
elseif strcmpi(termination, 'Open')
    zterm = inf;
else
    % if termination is empty
    warning(message('rf:rfckt:basetxline:calczin:TerminationEmpty'));
    zterm = inf;
end
    
% Check z0
if length(z0) == 1
    z0 = z0*ones(size(freq));
elseif length(z0) ~= length(freq);
    error(message('rf:rfckt:basetxline:calczin:Z0Freq'));
end
z0 = z0(:);

e_kl = 1./e_negkl;
% Refer to page 75 of RF Circuit Design by Reinhold Ludwig
tempA = e_kl + e_negkl;
tempB = e_kl - e_negkl;

% Handle stub terminated with Inf impedance
if isinf(zterm)
    Z_in = tempA./tempB.*z0;
else
    Z_in = (zterm.*tempA + z0.*tempB)./(zterm.*tempB + z0.*tempA).*z0;
end