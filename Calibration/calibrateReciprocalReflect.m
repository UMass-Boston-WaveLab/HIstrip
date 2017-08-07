% Calibration function. Uses one reflect standard, and is designed to work
% on the 2x2 reflect standard. Assumes error networks are reciprocal.

function[mag_dutS,mag_dut_cal_S,sorted_prop2,sorted_evalues] = calibrateReflect(re_thru,im_thru,...
    re_reflect1,im_reflect1,re_reflect2,im_reflect2,re_line,im_line,...
    re_dut,im_dut,thrulength,linelength, testName)

% Stores relative paths so MATLAB can find the data.
addpath 'Data';
addpath 'Data/Cal-Set-5';
addpath 'Data/ConductorLosses';
addpath 'Data/LinearTapers/Diamond';

% Set the name of the test for graphing function to access
testName = 'Reflect';
% Here for convenience, want access to all output variables.
re_thru = 'ThruExpTaperBand1GroundV2Real.csv'; 
im_thru = 'ThruExpTaperBand1GroundV2Im.csv';
re_line = 'LineExpTaperNotThruBand1GroundV2Real.csv'; 
im_line = 'LineExpTaperNotThruBand1GroundV2Im.csv';
re_reflect1 = 'ReflectExpTaperBand1GroundV2Real.csv';
im_reflect1 = 'ReflectExpTaperBand1GroundV2Im.csv';
re_reflect2 = re_reflect1;
im_reflect2 = im_reflect1;
re_dut = 'ReflectExpTaperBand1GroundV2Real.csv';
im_dut = 'ReflectExpTaperBand1GroundV2Im.csv';

thrulength=11.558/1000;
linelength=26.0055/1000;
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
[~,~,~,~,R1S] = generalized_S(reflect1S,r1depth,r1_sq_size);

% Reflect2 Data
[reflect2S,reflect2_freq,r2depth,r2_sq_size] = readin_HFSS(re_reflect2,...
    im_reflect2);
[~,~,~,~,R2S] = generalized_S(reflect2S,r2depth,r2_sq_size);

% DUT Data - convert the gammaIn first and put in individual matrices
dutS = GammaIn(ts11, ts12, ts21, ts22, R1S);
dutS11 = zeros(1,1,r2depth);
dutS12 = zeros(1,1,r2depth);
dutS21 = zeros(1,1,r2depth);
dutS22 = zeros(1,1,r2depth);
for ii = 1:r2depth
    dutS11(1,1,ii) = dutS(1,1,ii);
    dutS12(1,1,ii) = dutS(1,2,ii);
    dutS21(1,1,ii) = dutS(2,1,ii);
    dutS22(1,1,ii) = dutS(2,2,ii);
end

% For reflect, dutS is a 2x2 matrix, and each subcomponent is a singleton.
% This calculates the T matrix for the 2x2 dut.
T11 = dutS12 - (dutS11.*dutS22./dutS21);
T12 = dutS11./dutS21;
T21 = -1.*dutS22./dutS21;
T22 = 1./dutS21;

% The 4x4 S/T matrix for the reflect is [G 0; 0 G] where each subcomponent
% is a 2x2 matrix. This populates the 4x4 T matrix for the reflect
% standard.
dutT = zeros(4,4,r2depth);
for ii = 1:r2depth
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

% THIS TEST HERE NEEDS FIXIN' (dut parameters changed)
[depth] = sanitycheck(thru_freq,line_freq,...
    reflect1_freq,reflect2_freq,thru_freq,tdepth,ldepth,r1depth,r2depth,...
    r2depth,t_sq_size,l_sq_size,r1_sq_size,r2_sq_size,2,...
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
[G10,G20] = G10_and_G20(Ao,Bo,R1S,R2S,depth);

% Calculates the L0 matrix.
[L0,L10,L20,L12] = Lo(G10,G20,depth);

% Calculates the K0 matrix.
[K0] = knought(Ao,L10,L20,depth);

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
    R1S, 4, depth);

% Plots the DUT modal S-Parameters.
modal_graphs;
