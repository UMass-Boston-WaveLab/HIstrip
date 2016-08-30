% Builds submatrices of T matrix to help with conversion back to S parameters.

function[dut_cal_T11,dut_cal_T12,dut_cal_T21,dut_cal_T22] = ...
    conversion(Nxo,sq_size,sub_size,depth)

dut_cal_T11 = zeros(sub_size,sub_size,depth);
dut_cal_T12 = zeros(sub_size,sub_size,depth);
dut_cal_T21 = zeros(sub_size,sub_size,depth);
dut_cal_T22 = zeros(sub_size,sub_size,depth);

for ii = 1:depth
    dut_cal_T11(:,:,ii) = Nxo(1:sub_size,1:sub_size,ii);
    dut_cal_T12(:,:,ii) = Nxo(1:sub_size,sub_size+1:sq_size,ii);
    dut_cal_T21(:,:,ii) = Nxo(sub_size+1:sq_size,1:sub_size,ii);
    dut_cal_T22(:,:,ii) = Nxo(sub_size+1:sq_size,sub_size+1:sq_size,ii);
end

