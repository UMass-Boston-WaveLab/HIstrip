% Calibration function. Designed to work on the 2x2 reflect standards. This
% version uses two reflect standards during the calibration.

function[mag_dutS,mag_dut_cal_S,sorted_prop2,sorted_evalues] = calibrate2(re_thru,im_thru,...
    re_reflect1,im_reflect1,re_reflect2,im_reflect2,re_line,im_line,...
    re_dut,im_dut,thrulength,linelength, testName)

% Stores relative paths so MATLAB can find the data.
addpath 'Data';
addpath 'Data/Cal-Set-5';

% Set the name of the test for graphing function to access
testName = 'Line';
% Here for convenience, want access to all output variables.
re_thru = 're_cs5thruband1_groundV2.csv'; 
im_thru = 'im_cs5thruband1_groundV2.csv';
re_line = 're_cs5line1band1_groundV2.csv'; 
im_line = 'im_cs5line1band1_groundV2.csv';
re_reflect1 = 're_cs5openband1_groundV2.csv';
im_reflect1 = 'im_cs5openband1_groundV2.csv';
re_reflect2 = re_reflect1;
im_reflect2 = im_reflect1;
re_secondreflect = '50load+openREAL.csv';
im_secondreflect = '50load+openIM.csv';
re_dut = '50load+shortREAL.csv';
im_dut = '50load+shortIM.csv';

thrulength = 11.558/1000;
linelength = 26.0055/1000;
% Thrulength is 30.598/1000 with connectors; 11.558/1000 without
% Linelength is 45.045/1000 with connectors; 26.0055/1000 without

% Reading in all the data from HFSS and converting to generalized S
% parameters (and T parameters for thru, line, DUT.)

% Thru Data
[thruS,thru_freq,tdepth,t_sq_size] = readin_HFSS(re_thru,im_thru);
[ts11,ts12,ts21,ts22,~] = generalized_S(thruS,tdepth,t_sq_size);
[~,~,~,~,tt] = genS_to_genT(ts11, ts12, ts21, ts22, ...
    tdepth, 2);

% Line Data
[lineS, line_freq,ldepth,l_sq_size] = readin_HFSS(re_line,im_line);
[ls11,ls12,ls21,ls22,~] = generalized_S(lineS,ldepth,l_sq_size);
[~,~,~,~,lt] = genS_to_genT(ls11,ls12,ls21,ls22,...
    ldepth, 2);

% Reflect1 Data
[reflect1S,reflect1_freq,r1depth,r1_sq_size] = readin_HFSS(re_reflect1,...
    im_reflect1);
[r1s11,r1s12,r1s21,r1s22,R1S] = generalized_S(reflect1S,r1depth,r1_sq_size);

% Reflect2 Data
[reflect2S,reflect2_freq,r2depth,r2_sq_size] = readin_HFSS(re_reflect2,...
    im_reflect2);
[r2s11,r2s12,r2s21,r2s22,R2S] = generalized_S(reflect2S,r2depth,r2_sq_size);

% Secondary Reflect Data - the mode conversion reflect standard.
[reflect2S,reflect2_freq,reflect2depth,reflect2_sq_size] = ...
    readin_HFSS(re_secondreflect,im_secondreflect);
[rs2111,rs2112,rs2121,rs2122,r21_sub_size] = generalized_S(reflect2S,...
    reflect2depth,reflect2_sq_size);
    
[reflect22S,reflect22_freq,reflect22depth,reflect22_sq_size] = ...
    readin_HFSS(re_secondreflect,im_secondreflect);
[rs2211,rs2212,rs2221,rs2222,r22_sub_size] = generalized_S(reflect22S,...
    reflect22depth,reflect22_sq_size);

% DUT Data
[dutS,dut_freq,dutdepth,dut_sq_size] = readin_HFSS(re_dut,im_dut);
[dutS11,dutS12,dutS21,dutS22,~] = generalized_S(dutS,...
    dutdepth,dut_sq_size);

% For reflect, dutS is a 2x2 matrix, and each subcomponent is a singleton.
% This calculates the T matrix for the 2x2 dut.
T11 = dutS12 - (dutS11.*dutS22./dutS21);
T12 = dutS11./dutS21;
T21 = -1.*dutS22./dutS21;
T22 = 1./dutS21;

% The 4x4 S/T matrix for the reflect is [G 0; 0 G] where each subcomponent
% is a 2x2 matrix. This populates the 4x4 T matrix for the reflect
% standard.
dutT = zeros(4,4,dutdepth);
for ii = 1:dutdepth
    dutT(1,1,ii) = T11(1,1,ii);
    dutT(1,2,ii) = T12(1,1,ii);
    dutT(2,1,ii) = T21(1,1,ii);
    dutT(2,2,ii) = T22(1,1,ii);
    dutT(3,3,ii) = T11(1,1,ii);
    dutT(3,4,ii) = T12(1,1,ii);
    dutT(4,3,ii) = T21(1,1,ii);
    dutT(4,4,ii) = T22(1,1,ii);
end

% Checks to make sure that all of the data has the same number of frequency
% points, and that the thru,line, and DUT matrices are all the same size,
% and the reflect matrices are of identical size. Displays a message if
% something has gone awry.

[depth] = sanitycheck(thru_freq,line_freq,...
    reflect1_freq,reflect2_freq,dut_freq,tdepth,ldepth,r1depth,r2depth,...
    dutdepth,t_sq_size,l_sq_size,r1_sq_size,r2_sq_size,dut_sq_size,...
    R1S,R2S);

% Calculates the propagation constants,eigenvalues, and eigenvectors needed
% for the calibration, and then sorts them into the correct order.
[propagation_constants, eigenvalues, eigenvectors] = ...
    prop_const(lt,linelength, tt, thrulength, depth);
 
[sorted_prop2,sorted_evalues,Ao] = ...
    ordering(eigenvalues, propagation_constants, eigenvectors, depth);

% Correct the angles in the sorted propagation constants matrix.
sorted_prop2 = angleCorrect(sorted_prop2, depth);
    
% Calculates the partially known error boxes Ao and Bo. 
[~,Bo] = Ao_and_Bo(Ao,tt,thrulength,sorted_prop2,depth);

% Calculates G10 and G20 matrices. 
[G10,G20,G10new,G20new] = reflectG10_and_G20(Ao,Bo,r1s11,r1s12,r1s21,r1s22,...
    r2s11,r2s12,r2s21,r2s22,rs2111,rs2112,rs2121,rs2122,...
    rs2211,rs2212,rs2221,rs2222,4,2,depth);

% Calculates the L0 matrix.
[L0,L10,L20,L12] = reflectLo(G10,G20,G10new,G20new,2,depth);

% Calculates the K0 matrix.
[K0] = reflectKo(G10,G20,G10new,G20new,L0,4,2,depth);

% Calculates the Nxo matrix.
[NX0] = Nxo(Ao,Bo,K0,dutT,depth);

% Generates submatrices of Nxo.
[dut_cal_T11,dut_cal_T12,dut_cal_T21,dut_cal_T22] = ...
    conversion(NX0,depth);

% Returns (mostly) calibrated S-parameters of DUT. Sign ambiguities still
% need to be corrected.
[~,~,~,~,dut_cal_S] = genT_to_genS(dut_cal_T11,dut_cal_T12,dut_cal_T21,...
    dut_cal_T22, depth, 2);

% Need to figure out the phase/sign ambiguities; function goes here.

% Builds 2x2 zero matrix to plug in during the next step.
zeroBlock = zeros(2,2,depth);

% Converts the uncalibrated and calibrated S-parameters to dB for graphing.
[mag_dutS,mag_dut_cal_S] = S_to_db(dut_cal_S,R1S,zeroBlock,zeroBlock,...
    R1S,4,depth);

% Plots the DUT modal S-Parameters.
modal_graphs;
