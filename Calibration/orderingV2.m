% Correctly orders the eigenvalues and the associated eigenvectors and
% propagation constants.
%
% See section II.B for a discussion on sorting order and its importance.
% See Equations 15 - 27 for the derivation of the Ao matrix.
%
% Ao is the correctly sorted eigenvector matrix; other names should be
% self-explanatory.

function[sortedPropagationConstants, sortedEigenvalues, Ao] = ...
    orderingV2(propagationConstants, eigenvalues, eigenvectors, depth)

% The easiest way to sort all three matrices is to calculate the magnitudes
% of the eigenvalues. The forward traveling waves have eigenvalues less
% than 1, and are sorted in ascending order in the first and second
% positions along the diagonal. The backward traveling waves
% are then sorted into descending order along the diagonal. This produces a
% correctly sorted and paired propagation constants matrix.

% Eigenvalues and propagationConstants matrices only have values on the
% main diagonal. This extracts them into a single row vector for easier
% sorting.

% Preallocate the 1x4 matrices.
rowEigenvalues = zeros(1, 4, depth);
rowPropagationConstants = zeros(1, 4, depth);

% Populate the 1x4 matrices.
for ii = 1:depth
    for jj = 1:4
        rowEigenvalues(:,jj,ii) = eigenvalues(jj, jj, ii);
        rowPropagationConstants(:,jj,ii) = propagationConstants(jj, jj, ii);
    end
end

% Calculate the magnitudes of the eigenvalues.
eigenvalueMagnitudes = abs(rowEigenvalues);

% Uses selection sort algorithm to sort the eigenvalues into ascending
% order. Mirrors the changes to the rowPropagationConstants,
% rowEigenvalues, and eigenvectors matrices.

% iterate through the frequency points
for ii = 1:depth
    % search the row vector for the minimum
    for jj = 1:3
        minIndex = jj;
        for kk = jj+1:4
            % if we find a new minimum, store the index and keep searching
            if eigenvalueMagnitudes(1, kk, ii) < eigenvalueMagnitudes(1, minIndex, ii)
                minIndex = kk;
            end
        end
        % have the minimum index, now we swap the correct values into
        % the first position
        if minIndex ~= jj
            % get the temp values
            tempEigenvalueMagnitudes = eigenvalueMagnitudes(1, jj, ii);
            tempRowEigenvalue = rowEigenvalues(1, jj, ii);
            tempEigenvector = eigenvectors(1:end, jj, ii);
            tempPropagationConstant = rowPropagationConstants(1, jj, ii);
            
            % swap the values - put min in the jj'th spot
            eigenvalueMagnitudes(1, jj, ii) = ...
                eigenvalueMagnitudes(1, minIndex, ii);
            rowEigenvalues(1, jj, ii) = rowEigenvalues(1, minIndex, ii);
            eigenvectors(1:end, jj, ii) = eigenvectors(1:end, minIndex, ii);
            rowPropagationConstants(1, jj, ii) = ...
                rowPropagationConstants(1, minIndex, ii);
            
            % replace the old value
            eigenvalueMagnitudes(1, minIndex, ii) = ...
                tempEigenvalueMagnitudes;
            rowEigenvalues(1, minIndex, ii) = tempRowEigenvalue;
            eigenvectors(1:end, minIndex, ii) = tempEigenvector;
            rowPropagationConstants(1, minIndex, ii) = ...
                tempPropagationConstant;
        end
    end
end



% Now we switch the position of the last two entries in each matrix
for (ii = 1:depth)
    % store last entry as a temp variable
    tempEigenvalueMagnitudes = eigenvalueMagnitudes(1, 4, ii);
    tempRowEigenvalue = rowEigenvalues(1, 4, ii);
    tempEigenvector = eigenvectors(1:end, 4, ii);
    tempPropagationConstant = rowPropagationConstants(1, 4, ii);
    
    % put the third entry in the fourth spot
    eigenvalueMagnitudes(1, 4, ii) = eigenvalueMagnitudes(1, 3, ii);
    rowEigenvalues(1, 4, ii) = rowEigenvalues(1, 3, ii);
    eigenvectors(1:end, 4, ii) = eigenvectors(1:end, 3, ii);
    rowPropagationConstants(1, 4, ii) = rowPropagationConstants(1, 3, ii);
    
    % put the fourth entry in the third spot
    eigenvalueMagnitudes(1, 3, ii) = tempEigenvalueMagnitudes;
    rowEigenvalues(1, 3, ii) = tempRowEigenvalue;
    eigenvectors(1:end, 3, ii) = tempEigenvector;
    rowPropagationConstants(1, 3, ii) = tempPropagationConstant;
end


% Put the row vectors back into 4x4 diagonal matrices.
sortedPropagationConstants = zeros(4,4,depth);
sortedEigenvalues = zeros(4,4,depth);
for ii = 1:depth
    sortedPropagationConstants(:,:,ii) = diag(rowPropagationConstants(:,:,ii));
    sortedEigenvalues(:,:,ii) = diag(rowEigenvalues(:,:,ii));
end
Ao = eigenvectors;