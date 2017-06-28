% Generates S-parameters in dB for the uncalibrated and calibrated data.
% Maintains sq_size variable to allow for arbitrarily sized square
% matrices.

function[mag_dutS,mag_dut_cal_S] = S_to_db(dut_cal_S, dutS, sq_size,depth)

% preallocate matrices
mag_dutS = zeros(sq_size,sq_size,depth);
mag_dut_cal_S = zeros(sq_size,sq_size,depth);

% convert the s-parameters to dB values
mag_dutS = 20*log10(abs(dutS));
mag_dut_cal_S = 20*log10(abs(dut_cal_S));