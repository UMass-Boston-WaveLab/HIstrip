% The ordering of Ao and the propagation constants might be incorrect.
% This function puts them into new orders to try and see if it improves the
% overall calibration results.
%
% Extends and replaces the resort.m function

function [sorted_prop2,sorted_evalues,Ao] = ...
    reorder(eigenvalues, propagation_constants, eigenvectors, depth,...
    caseSwitcher)

switch caseSwitcher
    case 1
        % Switches positions (1,1) <--> (2,2)
        % Switches positions (3,3) <--> (4,4)
        for ii = 1:depth
            % switch the propagation constants matrix
            temp = propagation_constants(1,1,ii);
            propagation_constants(1,1,ii) = propagation_constants(2,2,ii);
            propagation_constants(2,2,ii) = temp;
            
            temp2 = propagation_constants(3,3,ii);
            propagation_constants(3,3,ii) = propagation_constants(4,4,ii);
            propagation_constants(4,4,ii) = temp2;
            
            % switch the eigenvectors matrix
            temp3 = eigenvectors(1:end, 2, ii);
            eigenvectors(1:end, 2, ii) = eigenvectors(1:end, 1, ii);
            eigenvectors(1:end, 1, ii) = temp3;
            
            temp4 = eigenvectors(1:end, 4, ii);
            eigenvectors(1:end, 4, ii) = eigenvectors(1:end, 3, ii);
            eigenvectors(1:end, 3, ii) = temp4;
        end
    case 2
        % Switches positions (1,1) <--> (3,3)
        % Switches positions (2,2) <--> (4,4)
        for ii = 1:depth
            % switch the propagation constants matrix
            temp = propagation_constants(1,1,ii);
            propagation_constants(1,1,ii) = propagation_constants(3,3,ii);
            propagation_constants(3,3,ii) = temp;
            
            temp2 = propagation_constants(2,2,ii);
            propagation_constants(2,2,ii) = propagation_constants(4,4,ii);
            propagation_constants(4,4,ii) = temp2;
            
            % switch the eigenvectors matrix
            temp3 = eigenvectors(1:end, 3, ii);
            eigenvectors(1:end, 3, ii) = eigenvectors(1:end, 1, ii);
            eigenvectors(1:end, 1, ii) = temp3;
            
            temp4 = eigenvectors(1:end, 4, ii);
            eigenvectors(1:end, 4, ii) = eigenvectors(1:end, 2, ii);
            eigenvectors(1:end, 2, ii) = temp4;
        end
    case 3
        % Switches positions (1,1) <--> (4,4)
        % Switches positions (2,2) <--> (3,3)
        for ii = 1:depth
            % switch the propagation constants matrix
            temp = propagation_constants(1,1,ii);
            propagation_constants(1,1,ii) = propagation_constants(4,4,ii);
            propagation_constants(4,4,ii) = temp;
            
            temp2 = propagation_constants(2,2,ii);
            propagation_constants(2,2,ii) = propagation_constants(3,3,ii);
            propagation_constants(3,3,ii) = temp2;
            
            % switch the eigenvectors matrix
            temp3 = eigenvectors(1:end, 4, ii);
            eigenvectors(1:end, 4, ii) = eigenvectors(1:end, 1, ii);
            eigenvectors(1:end, 1, ii) = temp3;
            
            temp4 = eigenvectors(1:end, 3, ii);
            eigenvectors(1:end, 3, ii) = eigenvectors(1:end, 2, ii);
            eigenvectors(1:end, 2, ii) = temp4;
        end
    otherwise
        warning('Enter a valid caseSwitcher argument - 1, 2, 3');
end

sorted_prop2 = propagation_constants;
sorted_evalues = eigenvalues;
Ao = eigenvectors;