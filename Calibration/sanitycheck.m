% Double checks data to make sure all matrices are the same size that need
% to be, and that all data has been collected over the same number of
% frequency points. Returns general size parameters for other functions to
% use.

function[sq_size,sub_size,depth] = sanitycheck(thru_freq,line_freq,...
    reflect1_freq,reflect2_freq,dut_freq,tdepth,ldepth,r1depth,r2depth,...
    dutdepth,t_sq_size,l_sq_size,r1_sq_size,r2_sq_size,dut_sq_size,...
    r1s12,r1s21,r2s12,r2s21)
% Checks that the same frequency points are imported for each TRL standard
% and the DUT.

test1 = isequal(thru_freq,line_freq,reflect1_freq,reflect2_freq,dut_freq);
if test1 ~= 1
    disp('Error importing data test1.');
end

% Checks the depth of each multidimensional matrix. (This might be
% equivalent to the test performed above).

test2 = isequal(tdepth,ldepth,r1depth,r2depth,dutdepth);
if test2 ~= 1
    disp('Error importing data test2.');
end
if test2 == 1
    depth = tdepth;
end

% Makes sure that T,L,DUT matrices are all the same size. Assigns variable
% sq_size and sub_size based off of these figures. 

test3 = isequal(t_sq_size,l_sq_size,dut_sq_size);
if test3 ~= 1
    disp('Error importing data test3.');
end
if test3 == 1
    sq_size = t_sq_size;
    sub_size = sq_size/2;
end

% Checks the reflect matrices for size equality and reciprocality. 
test4 = isequal(r1_sq_size,r2_sq_size);
if test4 ~= 1
    disp('Error importing data test4.');
end

% Cannot do a direct comparison of matrix transposes due to slight
% numerical inaccuracies in the last few decimal places of the imported
% data. Since we know the reflect S-matrices will be 2x2, we compare S12 vs
% S21 for the data and make sure that the difference is smaller than
% epsilon.

epsilon = 1e-5;

for ii = 1:depth
    
    if r1s12(1,1,ii) - r1s21(1,1,ii) > epsilon
        disp('Reflect1 reciprocal error.');
    end
    
    if r2s12(1,1,ii) - r2s21(1,1,ii) > epsilon
        disp('Reflect2 reciprocal error.');
    end
end

    



