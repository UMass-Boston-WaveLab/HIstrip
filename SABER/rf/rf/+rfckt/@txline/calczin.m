function Z_in = calczin(h, freq, zterm)
%Z_IN = CALCZIN(H, FREQ, ZTERM) calculate the input impedance of a
%   transmission line stub.
%
%   See also RFCKT.TXLINE

%   Copyright 2003-2007 The MathWorks, Inc.

% must call getexpnegkl first, getexpnegkl sets pv, loss and z0.
e_negkl = calckl(h, freq);
termination = get(h, 'Termination');
z0 = get(h, 'Z0');
mode = get(h, 'StubMode');

% check if StubMode is NotAStub
if strcmpi(mode, 'NotAStub')
    error(message('rf:rfckt:txline:calczin:StubMode'));
end

% check zterm
if nargin > 2
    [row, col] = size(squeeze(zterm));
    if (~(row == 1) && ~(col == 1)) || ~isnumeric(zterm) ||             ...
            any(isnan(zterm))
        error(message('rf:rfckt:txline:calczin:ZTerm'));
    end
    zterm = zterm(:);
    % Check terminating impedance
    if length(zterm) ~= length(freq) && length(zterm) ~= 1
        error(message('rf:rfckt:txline:calczin:ZTermFreq'));
    end
elseif strcmpi(termination, 'Short')
    zterm = 0;
elseif strcmpi(termination, 'Open')
    zterm = inf;
else
    % if termination is empty
    warning(message('rf:rfckt:txline:calczin:TerminationEmpty'));
    zterm = inf;
end

% Check z0
if length(z0) == 1
    z0 = z0*ones(size(freq));
else
    z0 = interpolate(h, h.Freq, z0, freq, h.IntpType);
end
z0 = z0(:);

% beta = 2*pi*freq./pv;
e_kl = 1./e_negkl;
% Refer to page 75 of RF Circuit Design by Reinhold Ludwig
tempA = e_kl + e_negkl;
tempB = e_kl - e_negkl;

% Handle stub terminated with Inf impedance
if isinf(zterm)
    % Lossless just for test purpose remove later
    %     if all(h.Loss == 0)
    %         Z_in = -j*z0./tan(len*beta);
    %     else
    Z_in = tempA./tempB.*z0;
    %     end
else
    % Lossless for test purpose remove later
    %     if all(h.Loss == 0)
    %         Z_in = (zterm.*cos(len*beta) + j*z0.*sin(len*beta))./...
    %             (z0.*cos(len*beta) + j*zterm.*sin(len*beta)).*z0;
    %     else
    Z_in = (zterm.*tempA + z0.*tempB)./(zterm.*tempB + z0.*tempA).*z0;
    %     end
end
