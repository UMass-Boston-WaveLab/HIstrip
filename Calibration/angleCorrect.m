% The complex logarithm function used to generate the propagation constants
% is restricted to angle outputs of [-pi, pi]. This produces propagation 
% constants with incorrect angles. 
%
% This function corrects the angles of the propagation constants. Vectors 
% not lying in the first or third quadrants must be corrected. Forward
% travelling waves (III) are corrected by subtracting 2pi from their 
% imaginary component. Backward travelling waves (I) are corrected by
% adding 2pi to their imaginary component.

function[sortedProp] = angleCorrect(sortedProp, depth)

% Correct for the factor of 100 in sortedProp. This needs to be automated
% somehow.
sortedProp = sortedProp * (1/100);

% iterate through the diagonal, adding or subtracting 2*pi*i as needed
for ii = 1:depth
    for jj = 1:4
        if real(sortedProp(jj, jj, ii)) < 0 ...
                && imag(sortedProp(jj, jj, ii)) > 0
            sortedProp(jj, jj, ii) = sortedProp(jj, jj, ii) - 2*pi*i;
            continue;
        end
        if real(sortedProp(jj, jj, ii)) > 0  ...
                && imag(sortedProp(jj, jj, ii)) < 0
            sortedProp(jj, jj, ii) = sortedProp(jj, jj, ii) + 2*pi*i;
        end
    end
end

% Restore the original scaling to sortedProp matrix.
sortedProp = sortedProp * (100);