% testing selection sort why won't you work

function[sortedPropagationConstants, sortedEigenvalues, Ao] = ...
    testingSelectionSort(propagationConstants, eigenvalues, eigenvectors, depth, extraInput)

% Populate the 1x4 matrices.
for ii = 1:depth
    for jj = 1:4
        rowEigenvalues(:,jj,ii) = eigenvalues(jj, jj, ii);
        rowPropagationConstants(:,jj,ii) = propagationConstants(jj, jj, ii);
    end
end

% Calculate the magnitudes of the eigenvalues.
eigenvalueMagnitudes = abs(rowEigenvalues);


ii = extraInput;
for jj = 1:3
        minIndex = jj;
        for kk = jj+1:4
            % if we find a new minimum, store the index and keep searching
            if eigenvalueMagnitudes(1, kk, ii) < eigenvalueMagnitudes(1, minIndex, ii)
                minIndex = kk;
            end
            % have the minimum index, now we swap the correct values into
            % the first position
            if minIndex ~= jj
                % get the temp values
                tempEigenvalueMagnitudes = eigenvalueMagnitudes(1, jj, ii);
                tempEigenvalue = rowEigenvalues(1, jj, ii);
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
                rowEigenvalues(1, minIndex, ii) = tempEigenvalue;
                eigenvectors(1:end, minIndex, ii) = tempEigenvector;
                rowPropagationConstants(1, minIndex, ii) = ...
                    tempPropagationConstant;
            end
        end
    end


% Put the row vectors back into 4x4 diagonal matrices.
sortedPropagationConstants = zeros(4,4,depth);
sortedEigenvalues = zeros(4,4,depth);
for ii = 1:depth
    sortedPropagationConstants(:,:,ii) = diag(rowPropagationConstants(:,:,ii));
    sortedEigenvalues(:,:,ii) = diag(rowEigenvalues(:,:,ii));
end
Ao = eigenvectors;