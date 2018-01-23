function result = ispassive(h)
% For help, type: "help ispassive"

%   Copyright 2009-2015 The MathWorks, Inc.
 
% Check input data
narginchk(1,1)

% Set the default
result = true;

% Check the property
checkproperty(h)
if any(real(h.A)>0)
    error(message('rf:rfmodel:rational:ispassive:Unstable',h.Name))
end

nPoles = length(h.A); % Number of poles
for ii = 1:nPoles
    if sum(h.A == h.A(ii)) > 1
        error(message('rf:rfmodel:rational:ispassive:DuplicatedPoles'))
    end
    if (isreal(h.A(ii)) && ~isreal(h.C(ii))) || ...
            (~isreal(h.A(ii)) && any((h.A == conj(h.A(ii))) ~= ...
            (h.C == conj(h.C(ii)))))
        error(message('rf:rfmodel:rational:ispassive:MismatchedPolesandResidues'))
    end
end

% Determine the port number
[nPorts1,nPorts2,~] = size(h.C);
if nPorts1 == nPorts2
    nPorts = nPorts1;
	C_temp = h.C; 
else
    nPorts = 1;
	C_temp(1,1,:) = h.C(:);
end

% Reconstruct state-space matrix
A = zeros(nPorts*nPoles,nPorts*nPoles);
B = zeros(nPorts*nPoles,nPorts);
C = zeros(nPorts,nPorts*nPoles);
D = h.D;
if isscalar(h.D)
    D(1:nPorts,1:nPorts,1) = h.D;
end

for idx = 1:nPoles
    for ii = 1:nPorts
        A((idx-1)*nPorts+ii,(idx-1)*nPorts+ii) = h.A(idx);
        B((idx-1)*nPorts+ii,ii) = 1;
        for jj = 1:nPorts
            C(ii,jj+(idx-1)*nPorts) = C_temp(ii,jj,idx);  
        end
    end
end
    
% Build Hamiltonian matrix and calculate the eigenvalues
gamma = 1+sqrt(eps);   
I = eye(nPorts);
R = D'*D-gamma*gamma*I;
S = D*D'-gamma*gamma*I;
M = [A-(B/R)*D'*C -gamma*(B/R)*B';...
    gamma*(C'/S)*C -A'+((C'*D)/R)*B'];
EigOfM = eig(M);

% Determine the result
ii = 1; 
nEigOfM = length(EigOfM);
while result && ii <= nEigOfM
    result = ~(abs(imag(EigOfM(ii)))/abs(real(EigOfM(ii)))>1e+9);
    ii = ii + 1;
end