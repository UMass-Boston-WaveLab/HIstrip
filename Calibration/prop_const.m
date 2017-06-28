% Calculates the propagation constants for the propagating modes on the
% thru and line standards. Also calculates eigenvalues and eigenvectors of
% P and Q matrices. 
%
% See Equations 3-14 for the derivation.

function[propagationConstants, eigenvalues, eigenvectors,Q] = ...
    prop_const(lineT,lineLength, thruT, thruLength, depth)

% Calculates the deltal term (eqn 11).
deltal = lineLength - thruLength; 

% Preallocate space for the Q matrix.
Q = zeros(4, 4, depth);

% Calculate the Q matrix (eqn 10).
for ii = 1:depth
    Q(:,:,ii) = lineT(:,:,ii) / thruT(:,:,ii); % lineT * inv(thruT)
end

% Get the eigenvectors and eigenvalues of Q (eqn 12, 13).
eigenvectors = zeros(4,4,depth);
eigenvalues = zeros(4,4,depth);
for ii = 1:depth
    [eigenvectors(:,:,ii),eigenvalues(:,:,ii)] = eig(Q(:,:,ii));
end

% Calculate the propagation constants from the eigenvalues (eqn 14).
propagationConstants = zeros(4,4,depth);
for ii = 1:depth
    for jj = 1:4
        propagationConstants(jj,jj,ii) = (1/deltal)*log(eigenvalues(jj,jj,ii));
    end
end