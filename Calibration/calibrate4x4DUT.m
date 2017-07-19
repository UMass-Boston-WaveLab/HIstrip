% Multimode calibration function. This version works for a 4x4
% DUT. After initial processing of data, the program will prompt the user
% to select which algorithm to run: no simplifying assumptions, reciprocal
% error networks, identical and reciprocal error networks, or calibrate the
% reflect assuming reciprocal error networks.
%
% Input:
%   Real and imaginary parts of raw S-parameters from thru, line, reflect,
%        and DUT, as .csv files.
%   Length of thru and line, in meters.
%   Name for the DUT, as a string ("thru", etc).
% Output:
%   Calibrated S-parameters of the DUT.
%   Graph of modal S-parameters of the DUT.
%
% Source: Wojnowski et al, "Multimode TRL Calibration Techniques
%   for Characterization of Differential Devices", IEEE Transactions on
%   Microwave Theory and Techniques, Vol. 60, No. 7, July 2012.

function[mag_dut_cal_S] = calibrate4x4DUT(realThru, imagThru, ...
    realReflect, imagReflect, realLine, imagLine, realDUT, imagDUT, ...
    thruLength, lineLength, testName)

% Stores relative paths so MATLAB can find the data. Each subset of the
% Data folder points to a different set of calibration standards.
%addpath 'Data';
%addpath 'Data/Cal-Set-5';
%addpath 'Data/shorter cs5';
%addpath 'Data/ConductorLosses';
%addpath 'Data/LinearTapers/Diamond';
%addpath 'Data/Exponential Tapers';
%addpath 'Data/full range';
%addpath 'Data/band2';
addpath 'Data/DUT FIX';

% HERE RIGHT NOW FOR TESTING/TROUBLESHOOTING
% Set the name of the test for graphing function to access
testName = 'DUT';
% Here for convenience, want access to all output variables.
realThru = 'thruReal.csv';
imagThru = 'thruImag.csv';
realLine = 'lineReal.csv';
imagLine = 'lineImag.csv';
realReflect = 'dutReal.csv';
imagReflect = 'dutImag.csv';
realDUT = 'thruReal.csv';
imagDUT = 'thruImag.csv';
thruLength=8.6685/1000;
lineLength=17.337/1000;

% Processes all of the raw data from the experiment into correctly
% formatted 4x4 matrices.

% Thru data.
thruT = rawDataToTransmissionParameters(realThru, imagThru);

% Line data.
lineT = rawDataToTransmissionParameters(realLine, imagLine);

% Reflect data. Might need to incorporate a second set of reflect data for
% the actual measurements.
reflectS = rawDataToScatteringParameters(realReflect, imagReflect, 2);

% DUT data.
dutS = rawDataToScatteringParameters(realDUT, imagDUT, 4);
dutT = rawDataToTransmissionParameters(realDUT, imagDUT);

% Validate the sizes of the processed raw data.
depth = validateSizes(thruT, lineT, dutT, reflectS);

% Calculates the propagation constants,eigenvalues, and eigenvectors needed
% for the calibration.
[propagationConstants, eigenvalues, eigenvectors] = ...
    prop_const(lineT,lineLength, thruT, thruLength, depth);

% Sorts the eigenvalues, eigenvectors, and propagation constants. Ao is the
% correctly sorted eigenvector matrix.
[sortedPropagationConstants, sortedEigenvalues, Ao] = ...
    orderingV2(propagationConstants, eigenvalues, eigenvectors, depth);
%{
% Correct the angles in the sorted propagation constants matrix.
sortedPropagationConstants = angleCorrect(sortedPropagationConstants, ...
    depth);
    %}

% Calculate the Bo error matrix.
Bo = Ao_and_Bo(Ao, thruT, thruLength, sortedPropagationConstants, depth);

% Calculates G10 and G20 matrices. Right now, the same reflect is passed
% in for both reflect measurements.
[G10,G20] = G10_and_G20(Ao, Bo, reflectS, reflectS, depth);

% At this point, the calibration algorithms diverge in how the Ko and Lo
% matrices are calculated. A menu will display prompting the user to select
% which simplifying assumptions, if any, they would like to use.

% Build up the menu
msg = 'Please select an algorithm to run:';
msg = [msg newline '1. No simplifying assumptions'];
msg = [msg newline '2. Reciprocal error networks'];
msg = [msg newline '3. Identical and reciprocal error networks'];
msg = [msg newline '4. Calibrate the reflect standard'];
msg = [msg newline 'Please enter your selection: '];

% Prompt user for input and make sure it's valid
response = 0;
while true
    % get the input
    response = input(msg);
    % make sure it's valid
    if response < 1 || response > 4
        disp('Please select a valid menu option');
        continue
    end
    % if input is valid, break the loop and continue
    break
end

% Switch/case statement processes data according to the chosen algorithm
switch response
    % no simplifying assumptions
    case 1 
        % Calculates the L0 matrix.
        [L0,L10,L20,L12] = Lo(G10,G20,depth);
        
        % Calculates the K0 matrix.
        [K0] = Ko(G10,G20,L0,depth);
        
    % reciprocal error networks    
    case 2 
        % Calculates the L0 matrix.
        [L0,L10,L20,L12] = Lo(G10,G20,depth);
        
        % Calculates the K0 matrix.
        [K0] = knought(Ao,L10,L20,depth);
        
    % identical and reciprocal networks    
    case 3 
        % Calculates the L0 matrix - uses identical error network assumption
        [L0, L2, L3, L4] = identicalErrorNetworksLo(Ao, Bo, depth);
        
        % Get the elements from L0 to use in knought function
        L10 = zeros(1,1,depth);
        L20 = zeros(1,1,depth);
        for ii = 1:depth
            L10(1,1,ii) = L0(1,1,ii);
            L20(1,1,ii) = L0(2,2,ii);
        end
        % Calculates the K0 matrix - uses reciprocal error networks assumption
        [K0] = knought(Ao,L10,L20,depth);
        
    % calibrate the reflect standard
    % assumes reciprocal error networks, just outputs the reflect and then
    % keeps chugging for now
    case 4
        % Calculates the L0 matrix.
        [L0,L10,L20,L12] = Lo(G10,G20,depth);
        
        % Calculates the K0 matrix.
        [K0, K10, K20] = knought(Ao,L10,L20,depth);
        
        % Calculates the de-embedded G (reflect) matrix
        G = calibrateReflectStandard(K10, K20, L10, L20, G10, depth);
    % base case for invalid input   
    otherwise
        error('Invalid menu option, program exiting');
end

% Finish the calibration procedure

% Calculates the Nxo matrix.
NX0 = Nxo(Ao,Bo,K0,dutT,depth);

% Generates submatrices of Nxo.
[dut_cal_T11,dut_cal_T12,dut_cal_T21,dut_cal_T22] = ...
    conversion(NX0,depth);

% Returns (mostly) calibrated S-parameters of DUT. Sign ambiguities still
% need to be corrected.
[~,~,~,~,dut_cal_S] = genT_to_genS(dut_cal_T11,dut_cal_T12,dut_cal_T21,...
    dut_cal_T22, depth, 2);

% Need to figure out the phase/sign ambiguities; function goes here.

% Converts the uncalibrated and calibrated S-parameters to dB for graphing.
[mag_dutS, mag_dut_cal_S] = S_to_db(dut_cal_S, dutS, 4, depth);

% Plots the DUT modal S-Parameters.
modal_graphs;