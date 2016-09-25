function [Y_31, Y_43, Y_21, Y_41, Y_23, Y_24] = HIS_admittance(sep_43, sep_31, sep_12, sep_42, sep_41, sep_32, slot_4_x, slot_3_x, slot_1_x, slot_2_x, frequency)

Y_31 = AdmittanceAcrossEntireSlot_matrix(slot_1_x, slot_3_x, sep_31, frequency)
Y_43 = AdmittanceAcrossEntireSlot_matrix(slot_3_x, slot_4_x, sep_43, frequency)
Y_21 = AdmittanceAcrossEntireSlot_matrix(slot_2_x, slot_1_x, sep_12, frequency)
Y_41 = AdmittanceAcrossEntireSlot_matrix(slot_4_x, slot_1_x, sep_41, frequency)
Y_23 = AdmittanceAcrossEntireSlot_matrix(slot_2_x, slot_3_x, sep_32, frequency)
Y_24 = AdmittanceAcrossEntireSlot_matrix(slot_2_x, slot_4_x, sep_42, frequency)

end