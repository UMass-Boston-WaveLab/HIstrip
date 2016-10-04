% Calibration function. 

function[mag_dutS,mag_dut_cal_S,sorted_prop2,sorted_evalues] = calibrate2(re_thru,im_thru,...
    re_reflect1,im_reflect1,re_reflect2,im_reflect2,re_line,im_line,...
    re_dut,im_dut,thrulength,linelength)

% Reads in all the data and converts each measurement from S-parameters to
% T-parameters.

addpath 'Data';
addpath 'Data/Cal-Set-4';

% Here for convenience, want access to all output variables.
re_thru = 're_cs4thru.csv'; 
im_thru = 'im_cs4thru.csv';
re_line = 're_cs4line1.csv'; 
im_line = 'im_cs4line1.csv';
re_reflect1 = 're_cs4short.csv';
im_reflect1 = 'im_cs4short.csv';
re_reflect2 = re_reflect1;
im_reflect2 = im_reflect1;
re_secondreflect = 're_cs4modalreflect.csv';
im_secondreflect = 'im_cs4modalreflect.csv';
re_dut = 're_cs3thru.csv';
im_dut = 'im_cs3thru.csv';

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

% Secondary Reflect Data
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
[~,~,~,~,dutT] = genS_to_genT(dutS11,dutS12,dutS21,...
    dutS22,dutdepth,2);

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
    
% Trying this out, fixes the complex log issue.

% [corrected_prop] = logfix(sorted_prop2,sq_size,sub_size,depth,...
%        linelength,thrulength);

%sorted_prop2 = corrected_prop;

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

% Converts the uncalibrated and calibrated S-parameters to dB for graphing.
[mag_dutS,mag_dut_cal_S] = S_to_db(dut_cal_S,dutS11,...
    dutS12,dutS21,dutS22,4,depth);

modal_graphs;