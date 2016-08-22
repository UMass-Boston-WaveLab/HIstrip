% Calibration function. Adding functions to it as I go.

function[calibrated_DUT] = calibrate(thrufile,reflect1file,reflect2file,...
    linefile,dutfile,thrulength,linelength)

% Reads in all the data and converts each measurement from S-parameters to
% T-parameters.

% Thru Data
[thruS,thru_freq,tdepth,t_sq_size] = readin_HFSS(thrufile);
[ts11,ts12,ts21,ts22,ts_sub_size] = generalized_S(thruS,tdepth,t_sq_size);
[~,~,~,~,tt] = genS_to_genT(ts11, ts12, ts21, ts22, ...
    tdepth, ts_sub_size);

% Line Data
[lineS, line_freq,ldepth,l_sq_size] = readin_HFSS(linefile);
[ls11,ls12,ls21,ls22,ls_sub_size] = generalized_S(lineS,ldepth,l_sq_size);
[~,~,~,~,lt] = genS_to_genT(ls11,ls12,ls21,ls22,...
    ldepth, ls_sub_size);

% Reflect1 Data
[reflect1S,reflect1_freq,r1depth,r1_sq_size] = readin_HFSS(reflect1file);
[r1s11,r1s12,r1s21,r1s22,r1_sub_size] = generalized_S(reflect1S,r1depth,...
    r1_sq_size);
[~,~,~,~,r1t] = genS_to_genT(r1s11,r1s12,r1s21,r1s22,...
    r1depth, r1_sub_size);

% Reflect2 Data
[reflect2S,reflect2_freq,r2depth,r2_sq_size] = readin_HFSS(reflect2file);
[r2s11,r2s12,r2s21,r2s22,r2_sub_size] = generalized_S(reflect2S,r2depth,...
    r2_sq_size);
[~,~,~,~,r2t] = genS_to_genT(r2s11,r2s12,r2s21,r2s22,...
    r2depth, r2_sub_size);

% DUT Data
[dutS,dut_freq,dutdepth,dut_sq_size] = readin_HFSS(dutfile);
[dutS11,dutS12,dutS21,dutS22,dut_sub_size] = generalized_S(dutS,...
    dutdepth,dut_sq_size);
[~,~,~,~,dutT] = genS_to_genT(dutS11,dutS12,dutS21,...
    dutS22,dutdepth,dut_sub_size);

% Checks to make sure that all of the data has the same number of frequency
% points, and that the thru,line, and DUT matrices are all the same size,
% and the reflect matrices are of identical size. Displays a message if
% something has gone awry.

[sq_size,sub_size,depth] = sanitycheck(thru_freq,line_freq,...
    reflect1_freq,reflect2_freq,dut_freq,tdepth,ldepth,r1depth,r2depth,...
    dutdepth,t_sq_size,l_sq_size,r1_sq_size,r2_sq_size,dut_sq_size,...
    r1s12,r1s21,r2s12,r2s21);

% Calculates the propagation constants,eigenvalues, and eigenvectors needed
% for the calibration, and then sorts them into the correct order.
[propagation_constants, eigenvalues, eigenvectors] = ...
    prop_const(lt,linelength, tt, thrulength, depth);
    
[sorted_prop2,sorted_evalues,sorted_evectors] = ...
    ordering(eigenvalues, propagation_constants, eigenvectors);
    
% Calculates the partially known error boxes Ao and Bo. 
[Ao,Bo] = Ao_and_Bo(sorted_evectors,tt,thrulength,sorted_prop2,...
    sq_size,sub_size,depth);

% Calculates G10 and G20 matrices.
[G10,G20] = G10_and_G20(Ao,Bo,r1t,r2t,r1s11,r1s12,r1s21,r1s22,...
    r2s11,r2s12,r2s21,r2s22,sq_size,sub_size,depth);

% Calculates the L0 matrix.
[Lo] = Lo(G10,G20,sub_size,depth);

% Calculates the K0 matrix.
[Ko] = Ko(G10,G20,Lo,sq_size,sub_size,depth);

% Calculates the Nxo matrix.
[Nxo] = Nxo(Ao,Bo,Ko,dutT,sq_size,depth);





