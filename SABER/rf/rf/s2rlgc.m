function output = s2rlgc(s_params,linelength,freq,z0,port_reorder)
%S2RLGC Converts S-parameters of a transmission line to RLGC-parameters
%   OUTPUT = S2RLGC(S_PARAMS, LINELENGTH, FREQ, Z0, PORT_REORDER) converts
%   the scattering parameters S_PARAMS of a transmission line into
%   RLGC-matrices. S-parameter data assumed to be Symmetric (Sii=Sjj) and
%   reciporcal (Sij=Sji).
%
%   S_PARAMS is a complex 2N-by-2N-by-M array, where M is the number of
%   frequency points at which the S-parameters are specified and N is
%   the number of transmission lines.
%   LINELENGTH is the length of the transmission line 
%   FREQ is a real Mx1 frequency vector
%   Z0 is the reference impedance, the default is 50 ohms.
%   PORT_REORDER IS A 2Nx1 vector indicating the input and output ports
%   [IP... OP ...]
%
%   The outputs are per unit length transmission line parameters
%   OUTPUT.R is a real N-by-N-by-M Resistance matrix (ohm/m)
%   OUTPUT.L is a real N-by-N-by-M Inductance matrix (H/m)
%   OUTPUT.C is a real N-by-N-by-M Capacitance matrix (F/m)
%   OUTPUT.G is a real N-by-N-by-M Conductance matrix (S/m)
%   OUTPUT.Zc is a complex N-by-N-by-M Characteristic line impedance(ohm)
%   OUTPUT.alpha is a real N-by-N-by-M attenuation constant (Nepers/m)
%   OUTPUT.beta is a real N-by-N-by-M phase constant (radians/m)
%
%   See also ABCD2S, S2Y, S2Z, S2H, Y2ABCD, Z2ABCD, H2ABCD, RLGC2S
%   Copyright 2003-2016 The MathWorks, Inc.

narginchk(3,5)

freqpts  = size(freq(:),1);        % Number of frequency points
numLines = size(s_params,1)/2;     % Number of transmission lines

if nargin < 4
    z0 = 50;
else
    if ~isscalar(z0)
        error(message('rf:s2rlgc:InvalidInputZ0NonScalar'))
    end
    if (isnan(z0) || isinf(z0))
        error(message('rf:s2rlgc:InvalidInputZ0NanInf'))
    end
end

if nargin < 5
    port_reorder = [];
end

if ~isempty(port_reorder)
    if(size(port_reorder,2) ~= 2*numLines)
        error(message('rf:s2rlgc:InvalidInputPortReorder'))
    end
    s_params = snp2smp(s_params,z0,port_reorder);
end


% Check the input S-parameters
m = CheckNetworkData(s_params,2*numLines,'S_PARAMS');

% Check the S-parameters for passivity
if ~ispassive(s_params,'Impedance',z0)
    error(message('rf:s2rlgc:InvalidInputpassiveS'))
end

if (m ~= freqpts)
    error(message('rf:s2rlgc:InvalidInputFreqLength'))
end

if ~isscalar(linelength)
    error(message('rf:s2rlgc:InvalidInputscalarlen'))
end

if (linelength <= 0 || isnan(linelength) || isinf(linelength) || ...
        ~isnumeric(linelength) || isempty(linelength))
    error(message('rf:s2rlgc:InvalidInputLength'))
end

if(any(freq<0) || any(isinf(freq)) || any(isnan(freq)) || isempty(freq))
    error(message('rf:s2rlgc:InvalidInputFreq'));
end

if freq(1) == 0
    freq(1) = 1e-6;
end

if numLines == 1
    s11   = squeeze(s_params(1,1,:));
    s11_2 = s11.^2;
    s22 = squeeze(s_params(2,2,:));
    if any(s22~=s11)
%        warning(message('rf:s2rlgc:NotSymmetric'));
    end

    s21   = squeeze(s_params(2,1,:));
    s21_2 = s21.^2;
    s12 = squeeze(s_params(1,2,:));
    if any(s12~=s21)
%         warning(message('rf:s2rlgc:NotReciprocal'));
    end

    Z2_num = (1 + s11).^2 - s21_2;
    Z2_den = (1 - s11).^2 - s21_2;
    knum2 = Z2_num.*Z2_den;
    knum = sqrt(knum2);
    % Determine which branch of exponent has positive real values
    % Equation is exp(-gamma*l)
    expGammaLenPos = (1 - s11_2 + s21_2 + knum) ./ (2*s21);

    logexp = log(expGammaLenPos);
    gamma = (real(logexp) + 1i*unwrap(imag(logexp)))/linelength;
    if ~all(real(gamma)>=0)
        expGammaLenNeg = (1 - s11_2 + s21_2  - knum) ./ (2*s21);
        logexp = log(expGammaLenNeg);
        gamma = (real(logexp) + 1i*unwrap(imag(logexp)))/linelength;
        if any(isnan(gamma))
            warning(message('rf:s2rlgc:InvalidRLGC'));
        elseif ~all(real(gamma>=0))
            warning(message('rf:s2rlgc:GammaHasNegVals'));
        end
    end

    Z2 = z0^2*Z2_num./Z2_den;
    Zc = sqrt(Z2);

    R = real(gamma.*Zc);
    L = imag(gamma.*Zc)./(2*pi*freq);
    G = real(gamma./Zc);
    C = imag(gamma./Zc)./(2*pi*freq);
    if any(isnan(R) || isnan(L) || isnan(G) || isnan(C))
        warning(message('rf:s2rlgc:InvalidRLGC'));
    end

    alpha = (real(gamma));
    beta  = (imag(gamma));

elseif numLines > 1
    % Allocate the memory for RLGC matrix
    R   = zeros(numLines,numLines,freqpts);      % Resistance matrix
    L   = R;                                     % Inductance matrix
    C   = R;                                     % Capacitance matrix
    G   = R;                                     % Conductance matrix
    Zc  = R;                                     % Characteristic impedance
    Td  = R;                                     % D term of ABCD matrix
    z21 = R;                                     % z21 of impedance matrix
    V   = R;                                     % Right Eigenvectors of Td
%     gamma = R;                                   % Propagation term
%     ZcGamma = R;                                 %
%     GamOverZc = R;                               %
    D = zeros(numLines,freqpts);                 % Eigenvalues of Td

    % Group s-parameters for N coupled transmission line
    % S-parameter matrix size is [2*numLines, 2*numLines]
    I = eye(numLines,numLines);
    s11 = s_params(1:numLines,     1:numLines,     :);
    s12 = s_params(1:numLines,     numLines+1:end, :);
    s21 = s_params(numLines+1:end, 1:numLines,     :);
    s22 = s_params(numLines+1:end, numLines+1:end, :);

    % Calculate Td, the D term of the Transmission line matrix
    % Calculate z21 term of impedance matrix
    Zbig = zeros(2*numLines,2*numLines,freqpts);
    I4 = eye(2*numLines,2*numLines);
    for idx=1:freqpts
        Td(:,:,idx) =  ((I-s11(:,:,idx))*(I+s22(:,:,idx))        +      ...
            s12(:,:,idx)*s21(:,:,idx)) / (2*s21(:,:,idx));
        z21(:,:,idx) = 2*s21(:,:,idx)*z0  /                             ...
            ((I-s11(:,:,idx))*(I-s22(:,:,idx))-s12(:,:,idx)*s21(:,:,idx));
        Zbig(:,:,idx) = z0*(I4+s_params(:,:,idx)) / (I4-s_params(:,:,idx));
        % Calculate the eigenvalues and eigenvectors
        % for the D term of the ABCD-matrix
        [V(:,:,idx),D(:,idx)] = eig(Td(:,:,idx),'vector');
    end

%     % Method 1
%     % Compute quantities without diagonalization
%     gAcosh = acosh(Td);
%     gamma1 = zeros(numLines,numLines,freqpts);
%     for row_idx = 1:numLines
%         for col_idxidx = 1:numLines
%             gamma1(row_idx,col_idxidx,:) =                              ...
%                 1i*unwrap(squeeze(imag(gAcosh(row_idx,col_idxidx,:))));
%         end
%     end
%     gamma1 = (real(gAcosh)+gamma1)/linelength;
% %     for idx = 1:freqpts
% %         Zc1(:,:,idx) = z21(:,:,idx)*sinh(gamma1(:,:,idx)*linelength);
% %         ZcGamma1(:,:,idx) = Zc1(:,:,idx)*gamma1(:,:,idx);
% %         GamOverZc1(:,:,idx) = gamma1(:,:,idx)/Zc1(:,:,idx);
% %     end

    % Method 2
    % Compute quantities with diagonalization from sort
    gammaTrLen = acosh(D);
    % Eigen values need to be sorted at each frequency
    [~, idxGammaTrLenSorted] = sort(abs(real(gammaTrLen)));
    gammaTrLenSorted = cell2mat(arrayfun(                               ...
        @(idx) gammaTrLen(idxGammaTrLenSorted(:,idx),idx), 1:freqpts,   ...
        'UniformOutput', false));
    gammaTrLenSortedUnwrap = real(gammaTrLenSorted)    +                ...
        1i*unwrap(imag(gammaTrLenSorted),[],2);
    Vsorted = reshape(cell2mat(                                         ...
        arrayfun(@(idx) V(:,idxGammaTrLenSorted(:,idx),idx),1:freqpts,  ...
        'UniformOutput', false)),numLines,numLines,freqpts);
    gamma2 = zeros(numLines,numLines,freqpts);
    for idx=1:freqpts
        gamma2(:,:,idx) = Vsorted(:,:,idx)                        *     ...
            ((diag(gammaTrLenSortedUnwrap(:,idx)))/linelength)    /     ...
            Vsorted(:,:,idx);
    end
    
    
%     % Method 3
%     % Compute quantities with diagonalization from eigenshuffle
%     [Vsh,Dsh] = eigenshuffle(Td);
%     gsh = acosh(Dsh);
%     gammaDsh = real(gsh) + 1i*unwrap(imag(gsh),[],2);
%     gamma3 = zeros(numLines,numLines,freqpts);
%     for idx=1:freqpts
%         gamma3(:,:,idx) = Vsh(:,:,idx)            *                     ...
%             ((diag(gammaDsh(:,idx)))/linelength)  /   Vsh(:,:,idx);
%     end
    
%     for idx=1:freqpts
%         Zc(:,:,idx) = z21(:,:,idx)*sinh(gamma2(:,:,idx)*linelength);
%         ep(:,:,idx) = Vsh(:,:,idx)                               *      ...
%             exp(diag(gammaTrLenSortedUnwrap(:,idx))*linelength)  /      ...
%             Vsh(:,:,idx);
%         en(:,:,idx) = Vsh(:,:,idx)                               *      ...
%             exp(diag(-gammaTrLenSortedUnwrap(:,idx))*linelength) /      ...
%             Vsh(:,:,idx);
%         Zc1(:,:,idx) = z21(:,:,idx)*(ep(:,:,idx)-en(:,:,idx))/2;
%         ZcGamma1(:,:,idx) = Zc1(:,:,idx)*gamma2(:,:,idx);
%         ZcGamma(:,:,idx) = Zc(:,:,idx)*gamma2(:,:,idx);
%         GamOverZc(:,:,idx) = gamma2(:,:,idx)/Zc(:,:,idx);
%     end


    alpha = real(gamma2);
    beta  = imag(gamma2);

    for m = 1:numLines
        for n = 1:numLines
            beta(m,n,:)  = abs(beta(m,n,:));
            alpha(m,n,:) = abs(alpha(m,n,:));
        end
    end
    gamma = complex(alpha,beta);

    Z_params = s2z(s_params,z0);
    for m = 1:freqpts
        sinh_gamma = funm(gamma(:,:,m)*linelength,@sinh);
        if abs(sinh_gamma) < eps
            Zc(:,:,m) = eps;
        else
            Zc(:,:,m) = Z_params(numLines+1:end,1:numLines,m)*sinh_gamma;
        end
    end

    % Calculate the RLCG matrices
    num_terms = numLines*numLines;
    for m= 1:freqpts
        R_temp = real(Zc(:,:,m)*gamma(:,:,m));
        L_temp = imag(Zc(:,:,m)*gamma(:,:,m))./(2*pi*freq(m));
        G_temp = real(gamma(:,:,m)/Zc(:,:,m));
        C_temp = imag(gamma(:,:,m)/Zc(:,:,m))./(2*pi*freq(m));

        R(:,:,m) = 0.5*(R_temp + R_temp.');
        L(:,:,m) = 0.5*(L_temp + L_temp.');
        G(:,:,m) = 0.5*(G_temp + G_temp.');
        C(:,:,m) = 0.5*(C_temp + C_temp.');

        %    Check if calcuated vaues are correct
        %    The diagonal terms of L and C are positive, non-zero.
        %    The diagonal terms of R and G are non-negative (can be zero).
        %    Off-diagonal terms of the L matrix are non-negative.
        %    Off-diagonal terms of C and G matrices are non-positive.
        if ( ((any(diag(L(:,:,m))<= 0)||                                ...
             any(diag(C(:,:,m))<= 0)) && freq(m) ~= 0.0)          ||    ...
             (any(diag(R(:,:,m))< 0)  || any(diag(G(:,:,m))< 0))  ||    ...
             (any(any(L(:,:,m) <0))   && numLines>1)              ||    ...
             ((sum(sum(C(:,:,m) <=0)) == num_terms*(num_terms-1)) &&    ...
             numLines>1)                                          ||    ...
             ((sum(sum(G(:,:,m) <=0)) == num_terms*(num_terms-1)) &&    ...
             numLines>1))
           error(message('rf:s2rlgc:InvalidRLGC'))
        end
    end
end

output = struct('R',R,'L',L,'G',G,'C',C,'alpha',alpha,'beta',beta,'Zc',Zc);