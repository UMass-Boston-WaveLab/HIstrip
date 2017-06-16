% Calculates the propagation constants for the propagating modes on the
% thru and line standards. Also calculates eigenvalues and eigenvectors of
% P and Q matrices. 

function[propagation_constants, eigenvalues, eigenvectors,Q] = ...
    prop_const(line,linelength, thru, thrulength, depth)

% Creates empty Q matrix and performs initial calculations.
deltal = linelength - thrulength;
Q = zeros(4,4,depth);
for ii = 1:depth
    invthru(:,:,ii) = inv(thru(:,:,ii));
end

% Calculates the propagation constants, eigenvalues, and eigenvectors to be
% sorted.
for ii = 1:depth
    Q(:,:,ii) = line(:,:,ii)*invthru(:,:,ii);
end

% Get the eigenvectors and eigenvalues
eigenvectors = zeros(4,4,depth);
eigenvalues = zeros(4,4,depth);
for ii = 1:depth
    [eigenvectors(:,:,ii),eigenvalues(:,:,ii)] = eig(Q(:,:,ii));
end

% Calculate the propagation constants from the eigenvalues
propagation_constants = zeros(4,4,depth);
for ii = 1:depth
    for jj = 1:4
        propagation_constants(jj,jj,ii) = (1/deltal)*log(eigenvalues(jj,jj,ii));
    end
end