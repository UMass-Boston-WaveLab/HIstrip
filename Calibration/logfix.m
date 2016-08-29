% Corrects the complex logarithm. Unfinished but it's a start.

function[corrected_prop] = logfix(sorted_prop2,sq_size,sub_size,depth,...
    linelength,thrulength)

% multiplies by deltal so we can work with easier radian angles.

corrected_prop = sorted_prop2*(linelength - thrulength);

for ii = 1:depth
    for jj = 1:sub_size
        if imag(sorted_prop2(jj,jj,ii)) > 0
            corrected_prop(jj,jj,ii) = corrected_prop(jj,jj,ii) - (j*2*pi);
        end
    end
end

corrected_prop = corrected_prop/(linelength - thrulength);

            