% Calculates the propagation constants for the propagating modes on the
% thru and line standards. Also calculates eigenvalues and eigenvectors of
% P and Q matrices. The input files are rectangular S-parameters in
% .csv format; the lengths are the lengths of each standard in meters. 

function[propagation_constants, eigenvalues, Q, Y, test] = prop_const(linefile, thrufile, linelength, thrulength)

%This section reads in the data and processes it for further use.

deltal = linelength - thrulength;
[LS11, LS12, LS21, LS22, LS] = readin_4x4S(linefile);
[LT11, LT12, LT21, LT22, LT] = S_to_T(LS11, LS12, LS21, LS22, LS);
[TS11, TS12, TS21, TS22, TS] = readin_4x4S(thrufile);
[TT11, TT12, TT21, TT22, TT] = S_to_T(TS11, TS12, TS21, TS22, TS);

[k, l, m] = size(LS);
Q = zeros(4, 4, m);
for ii = 1:m
    X(:,:,ii) = inv(TT(:,:,ii));
end

% This section calculates the propagation constants, eigenvalues, and
% eigenvectors to be sorted.
for ii = 1:m
    Q(:,:,ii) = LT(:,:,ii)*X(:,:,ii);
end
Y = zeros(4,4,m);
eigenvalues = zeros(4,4,m);
for ii = 1:m
    [Y(:,:,ii),eigenvalues(:,:,ii)] = eig(Q(:,:,ii));
end
for ii = 1:m
    propagation_constants(:,:,ii) = (1/deltal)*log(eigenvalues(:,:,ii));
end
for ii = 1:m
    for k = 1:4
        for l = 1:4
            if k ~= l
                propagation_constants(k,l,ii) = 0;
            end
        end
    end
end





    