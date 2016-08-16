% Double checks data to make sure all matrices are the same size that need
% to be, and that all data has been collected over the same number of
% frequency points. Returns general size parameters for other functions to
% use.

function[sq_size,sub_size,depth] = sanitycheck(thru_freq,line_freq,...
    reflect1_freq,reflect2_freq,dut_freq,tdepth,ldepth,r1depth,r2depth,...
    dutdepth,t_sq_size,l_sq_size,r1_sq_size,r2_sq_size,dut_sq_size)

% Checks that the same frequency points are imported for each TRL standard
% and the DUT.

test1 = isequal(thru_freq,line_freq,reflect1_freq,reflect2_freq,dut_freq);
if test1 ~= 1
    disp('Error importing data.');
end

% Checks the depth of each multidimensional matrix. (This might be
% equivalent to the test performed above).

test2 = isequal(tdepth,ldepth,r1depth,r2depth,dutdepth);
if test2 ~= 1
    disp('Error importing data.');
end
if test2 == 1
    depth = tdepth;
end

% Makes sure that T,L,DUT matrices are all the same size. Assigns variable
% sq_size to this size.

test3 = isequal(t_sq_size,l_sq_size,dut_sq_size);
if test3 ~= 1
    disp('Error importing data.');
end
if test3 == 1
    sq_size = t_sq_size;
    sub_size = sq_size/2;
end

test4 = isequal(r1_sq_size,r2_sq_size);
if test4 ~= 1
    disp('Error importing data.');
end




