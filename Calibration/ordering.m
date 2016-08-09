% Correctly orders the propagation constants and their associated
% eigenvalues and eigenvectors that were previously generated.

function [lambda,gamma2,Yo] = ordering(eigenvalues, propagation_constants, eigenvectors)
[k,l,m] = size(eigenvalues);

% Creates 1x4 matrices from the 4x4 diagonal matrices of eigenvalues and
% propagation constants. The Z matrix extracts the real components of the
% propagation constants for easier sorting.

X = zeros(1,4,m);
Z = zeros(1,4,m);
gamma = zeros(1,4,m);
for ii = 1:m
for jj = 1:4
X(:,jj,ii) = eigenvalues(jj,jj,ii);
Z(:,jj,ii) = real(propagation_constants(jj,jj,ii));
gamma(:,jj,ii) = propagation_constants(jj,jj,ii);
end
end

% Sorts the 1x4 propagation constants matrix and mirrors the changes in the
% eigenvalue and eigenvector matrices. 

for ii = 1:m
    [k, big] = max(Z(1,:,ii));
    if big ~= 2
        temp1 = Z(1,2,ii);
        temp2 = X(1,2,ii);
        temp3 = eigenvectors(1:end,2,ii);
        temp4 = gamma(1,2,ii);
        
        Z(1,2,ii) = Z(1,big,ii);
        X(1,2,ii) = X(1,big,ii);
        eigenvectors(1:end,2,ii) = eigenvectors(1:end,big,ii);
        gamma(1,2,ii) = gamma(1,big,ii);
        
        Z(1,big,ii) = temp1;
        X(1,big,ii) = temp2;
        eigenvectors(1:end,big,ii) = temp3;
        gamma(1,big,ii) = temp4;
        
    else
        throwaway = 1;
    end
    
    [n, small] = min(Z(1,:,ii));
    if small ~= 4
        temp1 = Z(1,4,ii);
        temp2 = X(1,4,ii);
        temp3 = eigenvectors(1:end,4,ii);
        temp4 = gamma(1,4,ii);
        
        Z(1,4,ii) = Z(1,small,ii);
        X(1,4,ii) = X(1,small,ii);
        eigenvectors(1:end,4,ii) = eigenvectors(1:end,small,ii);
        gamma(1,4,ii) = gamma(1,small,ii);
     
        Z(1,small,ii) = temp1;
        X(1,small,ii) = temp2;
        eigenvectors(1:end,small,ii) = temp3;
        gamma(1,small,ii) = temp4;
        
    else
        throwaway = 1;
    end
    
    if Z(1,1,ii) < 0
        temp1 = Z(1,3,ii);
        temp2 = X(1,3,ii);
        temp3 = eigenvectors(1:end,3,ii);
        temp4 = gamma(1,3,ii);
        
        Z(1,3,ii) = Z(1,1,ii);
        X(1,3,ii) = X(1,1,ii);
        eigenvectors(1:end,3,ii) = eigenvectors(1:end,1,ii);
        gamma(1,3,ii) = gamma(1,1,ii);
        
        Z(1,1,ii) = temp1;
        X(1,1,ii) = temp2;
        eigenvectors(1:end,1,ii) = temp3;
        gamma(1,1,ii) = temp4;
        
    else
        throwaway = 1;
    end
    
end

for ii = 1:m
    gamma2(:,:,ii) = diag(gamma(:,:,ii));
    lambda(:,:,ii) = diag(X(:,:,ii));
end
Yo = eigenvectors;

        