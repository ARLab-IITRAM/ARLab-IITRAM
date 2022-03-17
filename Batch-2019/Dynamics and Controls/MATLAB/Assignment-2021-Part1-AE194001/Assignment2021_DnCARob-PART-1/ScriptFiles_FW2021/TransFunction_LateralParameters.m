% The paramters and coeffients employed in the Lateral dynamics transfer
% function models
% Three TF models
%1 - TF_phi_delta_a, TF_chi_phi , T_v_delta_r (or T_beta_delta_r) 
Va_trim = sqrt(Tr_u^2 + Tr_v^2 + Tr_w^2) ;
alpha_trim = atan(Tr_w/Tr_u) ;
P_C_p_p = P_gamma_3*P_C_ell_p + P_gamma_4*P_C_n_p;
P_C_p_delta_a  = P_gamma_3*P_C_ell_delta_a + P_gamma_4*P_C_n_delta_a;




