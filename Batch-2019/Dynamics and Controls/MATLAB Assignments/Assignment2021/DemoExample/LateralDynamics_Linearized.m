
% Load UAV Parameters
Parameters_UAV; 
%% Trim Values
% Scenario: wings-level, constant-altitude flight. 
load('Trim_UAVAerosonde'); 
Tr_delta_a = u_trim(3);
Tr_delta_r = u_trim(4);
Tr_u     = x_trim(4);  % initial velocity along body x-axis
Tr_v     = x_trim(5);  % initial velocity along body y-axis
Tr_w     = x_trim(6);  % initial velocity along body z-axis
Tr_phi   = x_trim(7);  % initial roll angle
Tr_theta = x_trim(8);  % initial pitch angle
Tr_p     = x_trim(10);  % initial body frame roll rate
Tr_q     = x_trim(11);  % initial body frame pitch rate
Tr_r     = x_trim(12);  % initial body frame yaw rate
Tr_Va = 35; % Airspeed
Tr_gamma = 0; % Desired flight path angle
Tr_R = 100000000000000000; % Radius (Cant take infinity!!) 
Tr_psi = (Tr_Va/Tr_R)*cos(Tr_gamma); % Heading
Tr_beta = (Tr_v/Tr_Va);
%%  Initial Conditions
Init.v = x_trim(5);
Init.p = x_trim(10);
Init.r = x_trim(12);
Init.phi = x_trim(7);
Init.psi = Tr_psi;
%% ---- Compute constant values for linear system based on trim values and system parameters
Yv  = (P_rho*P_S_wing*P_b/4*P_mass)*(Tr_v/Tr_Va) + (P_rho*P_S_wing/P_mass)*(P_C_Y_0  + P_C_Y_beta*Tr_beta + P_C_Y_delta_a*Tr_delta_a + P_C_Y_delta_r*Tr_delta_r)+...
     (P_rho*P_S_wing*P_C_Y_beta/2*P_mass)*(sqrt(Tr_u^2 + Tr_w^2));
 
 
Yp = Tr_w + (P_rho*P_S_wing*P_b*P_C_Y_p/4*P_mass)*(Tr_Va);
Yr = -Tr_u + (P_rho*P_S_wing*P_b*P_C_Y_r/4*P_mass)*(Tr_Va);
Ydel_a = (P_rho*P_S_wing*P_C_Y_delta_a/2*P_mass)*(Tr_Va*Tr_Va);
Ydel_r = (P_rho*P_S_wing*P_C_Y_delta_r/2*P_mass)*(Tr_Va*Tr_Va);
Lv = (P_rho*P_S_wing*P_b*P_b/4)*(Tr_v/Tr_Va)*(P_C_p_p*Tr_p + P_C_p_r*Tr_r)+...
    P_rho*P_S_wing*P_b*Tr_v*(P_C_p_0 + P_C_p_beta*Tr_beta+ P_C_p_delta_a*Tr_delta_a+ P_C_p_delta_r*Tr_delta_r)+...
    (P_rho*P_S_wing*P_b*P_C_p_beta/2)*(sqrt(Tr_u^2 + Tr_w^2));
Lp  = P_gamma_1*Tr_q + (P_rho*P_S_wing*P_b*P_b/4)*P_C_p_p*Tr_Va;
Lr  = -P_gamma_2*Tr_q + (P_rho*P_S_wing*P_b*P_b/4)*P_C_p_r*Tr_Va;
Ldel_a  = (P_rho*P_S_wing*P_b*Tr_Va*Tr_Va/2)*P_C_p_delta_a;
Ldel_r = (P_rho*P_S_wing*P_b*Tr_Va*Tr_Va/2)*P_C_p_delta_r;
Nv = (P_rho*P_S_wing*P_b*P_b/4)*(Tr_v/Tr_Va)*(P_C_p_p*Tr_p + P_C_p_r*Tr_r)+...
    P_rho*P_S_wing*P_b*Tr_v*(P_C_r_0 + P_C_r_beta*Tr_beta+ P_C_r_delta_a*Tr_delta_a+ P_C_r_delta_r*Tr_delta_r)+...
    (P_rho*P_S_wing*P_b*P_C_p_beta/2)*(sqrt(Tr_u^2 + Tr_w^2));
Np =  P_gamma_7*Tr_q + (P_rho*P_S_wing*P_b*P_b/4)*P_C_r_p*Tr_Va;
Nr =  -P_gamma_1*Tr_q + (P_rho*P_S_wing*P_b*P_b/4)*P_C_r_r*Tr_Va;
Ndel_a = (P_rho*Tr_Va*Tr_Va*P_S_wing*P_b/2)*P_C_r_delta_a;
Ndel_r = (P_rho*Tr_Va*Tr_Va*P_S_wing*P_b/2)*P_C_r_delta_r;

%---------------------




