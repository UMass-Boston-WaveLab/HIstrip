% Correctly orders the propagation constants and their associated
% eigenvalues and eigenvectors. This needs to get cleaned up.

function [sorted_prop2,sorted_evalues,Ao] = ...
    ordering(eigenvalues, propagation_constants, eigenvectors, depth)

% Creates 1x4 matrices from the diagonal matrices of eigenvalues and
% propagation constants. The Z matrix extracts the real components of the
% propagation constants for easier sorting. 

X = zeros(1,4,depth);
Z = zeros(1,4,depth);
sorted_prop = zeros(1,4,depth);
for ii = 1:depth
    for jj = 1:4
        X(:,jj,ii) = eigenvalues(jj,jj,ii);
        Z(:,jj,ii) = real(propagation_constants(jj,jj,ii));
        sorted_prop(:,jj,ii) = propagation_constants(jj,jj,ii);
    end
end

% Sorts the propagation constants matrix by real component and mirrors 
% the changes in the eigenvalue and eigenvector matrices. Can be rewritten
% for a more general case (replace 4 with sq_size/come up with better sort
% process).

for ii = 1:depth
    [k, big] = max(Z(1,:,ii));
    if big ~= 4
        temp1 = Z(1,4,ii);
        temp2 = X(1,4,ii);
        temp3 = eigenvectors(1:end,4,ii);
        temp4 = sorted_prop(1,4,ii);
        
        Z(1,4,ii) = Z(1,big,ii);
        X(1,4,ii) = X(1,big,ii);
        eigenvectors(1:end,4,ii) = eigenvectors(1:end,big,ii);
        sorted_prop(1,4,ii) = sorted_prop(1,big,ii);
        
        Z(1,big,ii) = temp1;
        X(1,big,ii) = temp2;
        eigenvectors(1:end,big,ii) = temp3;
        sorted_prop(1,big,ii) = temp4;
        
    else
        throwaway = 1;
    end
    
    [n, small] = min(Z(1,:,ii));
    if small ~= 2
        temp1 = Z(1,2,ii);
        temp2 = X(1,2,ii);
        temp3 = eigenvectors(1:end,2,ii);
        temp4 = sorted_prop(1,2,ii);
        
        Z(1,2,ii) = Z(1,small,ii);
        X(1,2,ii) = X(1,small,ii);
        eigenvectors(1:end,2,ii) = eigenvectors(1:end,small,ii);
        sorted_prop(1,2,ii) = sorted_prop(1,small,ii);
     
        Z(1,small,ii) = temp1;
        X(1,small,ii) = temp2;
        eigenvectors(1:end,small,ii) = temp3;
        sorted_prop(1,small,ii) = temp4;
        
    else
        throwaway = 1;
    end
    
    if Z(1,1,ii) > 0
        temp1 = Z(1,3,ii);
        temp2 = X(1,3,ii);
        temp3 = eigenvectors(1:end,3,ii);
        temp4 = sorted_prop(1,3,ii);
        
        Z(1,3,ii) = Z(1,1,ii);
        X(1,3,ii) = X(1,1,ii);
        eigenvectors(1:end,3,ii) = eigenvectors(1:end,1,ii);
        sorted_prop(1,3,ii) = sorted_prop(1,1,ii);
        
        Z(1,1,ii) = temp1;
        X(1,1,ii) = temp2;
        eigenvectors(1:end,1,ii) = temp3;
        sorted_prop(1,1,ii) = temp4;
        
    else
        throwaway = 1;
    end
    
    % This next section goes through and checks if the eigenvalues in slots
    % 1 and 2 are ordered in terms of ascending magnitude. If not, switches
    % slot 1 with 2 and slot 3 with 4.
    
    if abs(X(1,2,ii)) < abs(X(1,1,ii));
        temp1 = Z(1,2,ii);
        temp2 = X(1,2,ii);
        temp3 = eigenvectors(1:end,2,ii);
        temp4 = sorted_prop(1,2,ii);
        
        Z(1,2,ii) = Z(1,1,ii);
        X(1,2,ii) = X(1,1,ii);
        eigenvectors(1:end,2,ii) = eigenvectors(1:end,1,ii);
        sorted_prop(1,2,ii) = sorted_prop(1,1,ii);
        
        Z(1,1,ii) = temp1;
        X(1,1,ii) = temp2;
        eigenvectors(1:end,1,ii) = temp3;
        sorted_prop(1,1,ii) = temp4;
        
        temp1 = Z(1,4,ii);
        temp2 = X(1,4,ii);
        temp3 = eigenvectors(1:end,4,ii);
        temp4 = sorted_prop(1,4,ii);
        
        Z(1,4,ii) = Z(1,3,ii);
        X(1,4,ii) = X(1,3,ii);
        eigenvectors(1:end,4,ii) = eigenvectors(1:end,3,ii);
        sorted_prop(1,4,ii) = sorted_prop(1,3,ii);
        
        Z(1,3,ii) = temp1;
        X(1,3,ii) = temp2;
        eigenvectors(1:end,3,ii) = temp3;
        sorted_prop(1,3,ii) = temp4;   
    end
end

sorted_prop2 = zeros(4,4,depth);
for ii = 1:depth
    sorted_prop2(:,:,ii) = diag(sorted_prop(:,:,ii));
    sorted_evalues(:,:,ii) = diag(X(:,:,ii));
end
Ao = eigenvectors;