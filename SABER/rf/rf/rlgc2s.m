function [s_params] = rlgc2s(resistance, inductance, conductance, capacitance, linelength, freq, z0)
% RLGC2S Converts RLGC-parameters of transmission lines to S-parameters
%   S_PARAMS = RLGC2S(RESISTANCE,INDUCTANCE,CONDUCTANCE,CAPACITANCE,LINELENGTH,FREQ,Z0)
%   converts the RLGC-matrices of a transmission line into its scattering
%   parameters
%   
%   RESISTANCE is a real N-by-N-by-M Resistance matrix (ohm/m) 
%   INDUCTANCE is a real N-by-N-by-M Inductance matrix (H/m) 
%   CONDUCTANCE is a real N-by-N-by-M Conductance matrix (S/m) 
%   CAPACITANCE is a real N-by-N-by-M Capacitance matrix (F/m) 
%   LINELENGTH is the length of the transmission line 
%   FREQ is the Mx1 frequency vector 
%   Z0 is the reference impedance, the default is 50 ohms.
%   
%   The output S_PARAMS is a complex 2N-by-2N-by-M array, where M is the
%   number of frequency points at which the RLGC-matrices are specified and
%   N is the number of transmission lines.
% 
% Properties of RLGC matrices
%   R,L,G,C matrices are symmetric. 
%   Diagonal terms of L and C are positive, non-zero.
% 	Diagonal terms of R and G are non-negative (can be zero).
% 	Off-diagonal terms of the L matrix are non-negative. 
%   Off-diagonal terms of C and G matrices are non-positive. 
%   Off-diagonal terms of all matrices can be zero.
% 
%   See also ABCD2S, S2Y, S2Z, S2H, Y2ABCD, Z2ABCD, H2ABCD, S2RLGC
%   Copyright 2003-2011 The MathWorks, Inc.


narginchk(6,7);

if nargin < 7
    z0 = 50;
else
    if(~isscalar(z0))
        error(message('rf:rlgc2s:InvalidInputZ0NonScalar'));
    end
    if(isnan(z0) || isinf(z0))
        error(message('rf:rlgc2s:InvalidInputZ0NanInf'));
    end
end

[num_lines, m] = check_rlgc(resistance,inductance,conductance,capacitance, freq);
freqpts        = size(freq,1);

if(m ~= freqpts)
    error(message('rf:rlgc2s:InvalidInputFreqLength'));
end

if(~isscalar(linelength))
    error(message('rf:rlgc2s:InvalidInputscalarlen'));
end

if (linelength <= 0 || isnan(linelength) || isinf(linelength) || ~isnumeric(linelength) ...
        || isempty(linelength))
    error(message('rf:rlgc2s:InvalidInputLength'));
end

if(any(freq<0) || any(isinf(freq)) || any(isnan(freq)) || isempty(freq))
    error(message('rf:rlgc2s:InvalidInputFreq'));
end


% Allocate the memory for S matrix
s_params = zeros(2*num_lines, 2*num_lines,freqpts);

for m=1:freqpts    
    Z     = complex(resistance(:,:,m) , 2*pi*freq(m).*inductance(:,:,m));
    Y     = complex(conductance(:,:,m) , 2*pi*freq(m).*capacitance(:,:,m));

    % Calculate the ABCD matices
    W1       = Y*Z;    
    P        = sqrtm(W1)*linelength;
    
    A       = Y\funm(P,@cosh)*Y;
    B       = sqrtm(Y\Z)*funm(P, @sinh);
    C       = funm(P, @sinh)* sqrtm(Z\Y);
    D       = funm(P, @cosh);
                   
    % Convert ABCD matrix to S-parameters
    den      = A + B./z0 + C.*z0 + D;
    S11      = (A + B./z0 - C.*z0 - D)/den;
    S12      = 2*(A*D - B*C)/den;
    S21      = 2*eye(num_lines)/den;
    S22      = (-A + B./z0 - C.*z0 + D)/den;
    
    s_params(1:num_lines, 1:num_lines,m)         = 0.5*(S11 + S11.');
    s_params(1:num_lines, num_lines+1:end,m)     = 0.5*(S12 + S12.');
    s_params(num_lines+1:end, 1:num_lines,m)     = 0.5*(S21 + S21.');
    s_params(num_lines+1:end, num_lines+1:end,m) = 0.5*(S22 + S22.');
end

function [num_lines, freq_pts] = check_rlgc(allR,allL,allG,allC,freq)
% Test the properties of RLGC matrices 

% Must be numeric
if (~isnumeric(allR) || isempty(allR) || ...
        any(any(any(isnan(allR)))) || any(any(any(isinf(allR)))))
    error(message('rf:check_rlgc:isnumericR'));
end

if (~isnumeric(allL) || isempty(allL) || ...
        any(any(any(isnan(allL)))) || any(any(any(isinf(allL)))))
    error(message('rf:check_rlgc:isnumericL'));
end

if (~isnumeric(allG) || isempty(allG) || ...
        any(any(any(isnan(allG)))) || any(any(any(isinf(allG)))))
    error(message('rf:check_rlgc:isnumericG'));
end

if (~isnumeric(allC) || isempty(allC) || ...
        any(any(any(isnan(allC)))) || any(any(any(isinf(allC)))))
    error(message('rf:check_rlgc:isnumericC'));
end

if((size(allR) == size(allL)) & (size(allG) == size(allC)) ...
        & (size(allR) == size(allC))) %#ok<AND2>
    num_lines = size(allR,1);       % Number of transmission lines
    freq_pts  = size(allR,3);       % number of frequency points
else
    error(message('rf:check_rlgc:samesizeRLGC'));
end

num_terms = num_lines*num_lines;
for m=1:freq_pts    
    R = allR(:,:,m);
    L = allL(:,:,m);
    G = allG(:,:,m);
    C = allC(:,:,m);
    
    % All matrices are symmetric. 
    if( ~isequal(R, R.') || ~isequal(L, L.') || ~isequal(G, G.') || ~isequal(C, C.'))
        error(message('rf:check_rlgc:symmetric'));
    end
    
    % The diagonal terms of L and C are positive, non-zero. 
    if((any(diag(L)<= 0) ||  any(diag(C)<= 0)) &&  freq(m) ~= 0.0)
        error(message('rf:check_rlgc:diagLC'));
    end
    
    % The diagonal terms of R and G are non-negative (can be zero). 
    if(any(diag(R)< 0) ||  any(diag(G)< 0))
        error(message('rf:check_rlgc:diagRG'));        
    end
        
    % Off-diagonal terms of the L matrix are non-negative.
    if(any(any(L <0)) && num_lines>1)
        error(message('rf:check_rlgc:offdiagL'));
    end
        
    % Off-diagonal terms of C and G matrices are non-positive. 
    if((sum(sum(C <=0)) == num_terms*(num_terms-1)) && num_lines>1)
        error(message('rf:check_rlgc:offdiagC'));        
    end
    
    if((sum(sum(G <=0)) == num_terms*(num_terms-1)) && num_lines>1)
        error(message('rf:check_rlgc:offdiagG'));
    end
end