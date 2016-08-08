% Calculates the propagation constants for the propagating modes on the
% thru and line standards. The input files are rectangular S-parameters in
% .csv format; the lengths are the lengths of each standard in meters.

function[gamma, lambda] = prop_const(linefile, thrufile, linelength, thrulength)
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
for ii = 1:m
    Q(:,:,ii) = LT(:,:,ii)*X(:,:,ii);
end
lambda = zeros(1,4,m);
for ii = 1:m
    lambda(:,:,ii) = eig(Q(:,:,ii));
end
gamma = zeros(1,4,m);
for ii = 1:m
    gamma(:,:,ii) = (1/deltal)*log(lambda(:,:,ii));
end

    
