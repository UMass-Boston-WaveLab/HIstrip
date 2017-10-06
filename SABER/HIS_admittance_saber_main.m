function [Y_matrix,Ys_ant,Ys_sub,Y_12, Y_13, Y_14, Y_23, Y_24, Y_34] = HIS_admittance_saber_main(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, frequency,w_ant, h_ant, L_ant,eps1, w_sub, h_sub, L_sub,eps2, freq)

[Y_12, Y_13, Y_14, Y_23, Y_24, Y_34] = HIS_admittance_saber(sep_12, sep_13, sep_14, sep_23, sep_24, sep_34, slot_1_x, slot_2_x, slot_3_x, slot_4_x, frequency);


[ Ys_ant,Ys_sub ] = HISantYmat_self(w_ant, h_ant, L_ant,eps1, w_sub, h_sub, L_sub,eps2, freq);


Y_matrix = [Ys_ant Y_12 Y_13 Y_14;
    Y_12 Ys_sub Y_23 Y_24;
    Y_13 Y_23 Ys_ant Y_34;
    Y_14 Y_24 Y_34 Ys_sub];

 end