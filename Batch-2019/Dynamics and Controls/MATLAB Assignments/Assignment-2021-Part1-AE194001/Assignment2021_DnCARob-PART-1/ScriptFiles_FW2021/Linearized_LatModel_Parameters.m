% The paramters and coeffients employed in the Lateral dynamics state space model
%% Composite Coefficients used in  Lateral Dynamics
P_C_p_0 = P_gamma_3*P_C_ell_0 + P_gamma_4*P_C_n_0;
P_C_p_beta = P_gamma_3*P_C_ell_beta + P_gamma_4*P_C_n_beta;
P_C_p_p = P_gamma_3*P_C_ell_p + P_gamma_4*P_C_n_p;
P_C_p_r  = P_gamma_3*P_C_ell_r + P_gamma_4*P_C_n_r;
P_C_p_delta_a  = P_gamma_3*P_C_ell_delta_a + P_gamma_4*P_C_n_delta_a;
P_C_p_delta_r  = P_gamma_3*P_C_ell_delta_r + P_gamma_4*P_C_n_delta_r;
P_C_r_0 = P_gamma_4*P_C_ell_0 + P_gamma_8*P_C_n_0;
P_C_r_beta = P_gamma_4*P_C_ell_beta + P_gamma_8*P_C_n_beta;
P_C_r_p = P_gamma_4*P_C_ell_p + P_gamma_8*P_C_n_p;
P_C_r_r  = P_gamma_4*P_C_ell_r + P_gamma_8*P_C_n_r;
P_C_r_delta_a  = P_gamma_4*P_C_ell_delta_a + P_gamma_8*P_C_n_delta_a;
P_C_r_delta_r  = P_gamma_4*P_C_ell_delta_r + P_gamma_8*P_C_n_delta_r;
%% Define coeffiecients of the State Space Matrix for Lateral Dynamics
Yv  = (P_rho*P_S_wing*P_b/(4*P_mass))*(Tr_v/Tr_Va) + (P_rho*P_S_wing*Tr_v/P_mass)*(P_C_Y_0  + P_C_Y_beta*Tr_beta + P_C_Y_delta_a*Tr_delta_a + P_C_Y_delta_r*Tr_delta_r)+...
     (P_rho*P_S_wing*P_C_Y_beta/(2*P_mass))*(sqrt(Tr_u^2 + Tr_w^2));
Yp = Tr_w + (P_rho*P_S_wing*P_b*P_C_Y_p/(4*P_mass))*(Tr_Va);
Yr = -Tr_u + (P_rho*P_S_wing*P_b*P_C_Y_r/(4*P_mass))*(Tr_Va);
Ydel_a = (P_rho*P_S_wing*P_C_Y_delta_a/(2*P_mass))*(Tr_Va*Tr_Va);
Ydel_r = (P_rho*P_S_wing*P_C_Y_delta_r/(2*P_mass))*(Tr_Va*Tr_Va);
Lv = (P_rho*P_S_wing*P_b*P_b/4)*(Tr_v/Tr_Va)*(P_C_p_p*Tr_p + P_C_p_r*Tr_r)+...
    P_rho*P_S_wing*P_b*Tr_v*(P_C_p_0 + P_C_p_beta*Tr_beta+ P_C_p_delta_a*Tr_delta_a+ P_C_p_delta_r*Tr_delta_r)+...
    (P_rho*P_S_wing*P_b*P_C_p_beta/2)*(sqrt(Tr_u^2 + Tr_w^2));
Lp  = P_gamma_1*Tr_q + (P_rho*P_S_wing*P_b*P_b/4)*P_C_p_p*Tr_Va;
Lr  = -P_gamma_2*Tr_q + (P_rho*P_S_wing*P_b*P_b/4)*P_C_p_r*Tr_Va;
Ldel_a  = (P_rho*P_S_wing*P_b*Tr_Va*Tr_Va/2)*P_C_p_delta_a;
Ldel_r = (P_rho*P_S_wing*P_b*Tr_Va*Tr_Va/2)*P_C_p_delta_r;
Nv = (P_rho*P_S_wing*P_b*P_b/4)*(Tr_v/Tr_Va)*(P_C_p_p*Tr_p + P_C_p_r*Tr_r)+...
    P_rho*P_S_wing*P_b*Tr_v*(P_C_r_0 + P_C_r_beta*Tr_beta+ P_C_r_delta_a*Tr_delta_a+ P_C_r_delta_r*Tr_delta_r)+...
    (P_rho*P_S_wing*P_b*P_C_r_beta/2)*(sqrt(Tr_u^2 + Tr_w^2));
Np =  P_gamma_7*Tr_q + (P_rho*P_S_wing*P_b*P_b/4)*P_C_r_p*Tr_Va;
Nr =  -P_gamma_1*Tr_q + (P_rho*P_S_wing*P_b*P_b/4)*P_C_r_r*Tr_Va;
Ndel_a = (P_rho*Tr_Va*Tr_Va*P_S_wing*P_b/2)*P_C_r_delta_a;
Ndel_r = (P_rho*Tr_Va*Tr_Va*P_S_wing*P_b/2)*P_C_r_delta_r;
%---------------

A_lat = [Yv Yp Yr P_gravity*cos(Tr_theta)*cos(Tr_phi) 0;
     Lv Lp Lr 0 0;
     Nv Np Nr 0 0;
     0 1 cos(Tr_phi)*tan(Tr_theta) Tr_q*cos(Tr_phi)*tan(Tr_theta)-Tr_r*sin(Tr_phi)*tan(Tr_theta) 0;
     0 0 cos(Tr_phi)*sec(Tr_theta) Tr_p*cos(Tr_phi)*sec(Tr_theta)-Tr_r*sin(Tr_phi)*sec(Tr_theta) 0];
 
B_lat  = [Ydel_a Ydel_r; 
      Ldel_a Ldel_r;
      Ndel_a Ndel_r;
      0 0;
      0 0];
