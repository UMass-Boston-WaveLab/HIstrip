% Generates S-parameters in dB for the uncalibrated and calibrated data.

function[mag_dutS,mag_dut_cal_S] = S_to_db(thru_freq,dut_cal_S,dutS11,...
    dutS12,dutS21,dutS22,sq_size,depth)

% Calculates the S-parameters of the uncalibrated and calibrated DUT in dB.

dutS = [dutS11 dutS12;dutS21 dutS22];

mag_dutS = zeros(sq_size,sq_size,depth);

for ii = 1:depth
    mag_dutS(:,:,ii) = abs(dutS(:,:,ii));
    mag_dutS(:,:,ii) = 20*log10(mag_dutS(:,:,ii));
end

mag_dut_cal_S = zeros(sq_size,sq_size,depth);

for ii = 1:depth
    mag_dut_cal_S(:,:,ii) = abs(dut_cal_S(:,:,ii));
    mag_dut_cal_S(:,:,ii) = 20*log10(mag_dut_cal_S(:,:,ii));
end


