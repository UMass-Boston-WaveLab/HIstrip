% Calculates the propagation constants for the propagating modes on the
% thru and line standards. Also calculates eigenvalues and eigenvectors of
% P and Q matrices. 

function[propagation_constants, eigenvalues, eigenvectors] = ...
    prop_const(line,linelength, thru, thrulength, sq_size, depth)

% Creates empty Q matrix and performs initial calculations.

deltal = linelength - thrulength;
Q = zeros(sq_size,sq_size, depth);
for ii = 1:depth
    invthru(:,:,ii) = inv(thru(:,:,ii));
end

% Calculates the propagation constants, eigenvalues, and eigenvectors to be
% sorted.

for ii = 1:depth
    Q(:,:,ii) = line(:,:,ii)*invthru(:,:,ii);
end

eigenvectors = zeros(sq_size,sq_size,depth);
eigenvalues = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    [eigenvectors(:,:,ii),eigenvalues(:,:,ii)] = eig(Q(:,:,ii));
end

propagation_constants = zeros(sq_size,sq_size,depth);
for ii = 1:depth
    for jj = 1:sq_size
        propagation_constants(jj,jj,ii) = (1/deltal)*log(eigenvalues(jj,jj,ii));
    end
end






    