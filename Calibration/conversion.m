% Builds submatrices of T matrix to help with conversion back to
% S parameters.

function[dut_cal_T11,dut_cal_T12,dut_cal_T21,dut_cal_T22] = ...
    conversion(Nxo,depth)

dut_cal_T11 = zeros(2,2,depth);
dut_cal_T12 = zeros(2,2,depth);
dut_cal_T21 = zeros(2,2,depth);
dut_cal_T22 = zeros(2,2,depth);

for ii = 1:depth
    dut_cal_T11(:,:,ii) = Nxo(1:2,1:2,ii);
    dut_cal_T12(:,:,ii) = Nxo(1:2,3:4,ii);
    dut_cal_T21(:,:,ii) = Nxo(3:4,1:2,ii);
    dut_cal_T22(:,:,ii) = Nxo(3:4,3:4,ii);
end