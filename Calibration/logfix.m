% Corrects the complex logarithm. Has no effect on final dB results.

function[corrected_prop] = logfix(sorted_prop2,sq_size,sub_size,depth,...
    linelength,thrulength)

% multiplies by deltal so we can work with easier radian angles.

corrected_prop = sorted_prop2*(linelength - thrulength);

for ii = 1:depth
    for jj = 1:sub_size
        if imag(sorted_prop2(jj,jj,ii)) > 0
            corrected_prop(jj,jj,ii) = corrected_prop(jj,jj,ii) - (j*2*pi);
            corrected_prop(jj+sub_size,jj+sub_size,ii) = -1*...
                corrected_prop(jj,jj,ii);
        end
    end
end

corrected_prop = corrected_prop/(linelength - thrulength);

            
