% The paramters and coeffients employed in the Longitudinal dynamics state space model
%% Composite Coefficients used in  Longitudinal Dynamics
%----P_C_Z_q,P_C_Z_0,k---%%needed
L_C_alpha_alpha = P_C_L_0 + P_C_L_alpha*P_alpha0;
D_C_alpha_alpha = P_C_D_0 + P_C_D_alpha*P_alpha0;
X_C_alpha = -D_C_alpha_alpha*cos(P_alpha0) + L_C_alpha_alpha*sin(P_alpha0);
X_C_q_alpha = -P_C_D_q*cos(P_alpha0) + P_C_L_q*sin(P_alpha0);
X_C_delta_e  = -P_C_D_delta_e*cos(P_alpha0) + P_C_L_delta_e*sin(P_alpha0);
Z_C_alpha  = -D_C_alpha_alpha*sin(P_alpha0) - L_C_alpha_alpha*cos(P_alpha0);
Z_C_q_alpha  = -P_C_D_q*sin(P_alpha0) - P_C_L_q*cos(P_alpha0);
Z_C_delta_e  = -P_C_D_delta_e*sin(P_alpha0) - P_C_L_delta_e*cos(P_alpha0);
%% Define coeffiecients of the State Space Matrix for Longitudinal Dynamics
Xu  = (Tr_u*P_rho*P_S_wing/P_mass)*(P_C_X_0+X_C_alpha*Tr_alpha+X_C_delta_e*Tr_delta_e) ...
       - (P_rho*P_S_wing*Tr_w*X_C_alpha/2*P_mass) - (P_rho*P_S_c*Tr_u*Tr_q*X_C_q_alpha/4*P_mass*Tr_Va) - (P_rho*P_S_prop*Tr_u*P_C_prop/P_mass);
Xw = -Tr_q + (Tr_w*P_rho*P_S_wing/P_mass)*(P_C_X_0+X_C_alpha*Tr_alpha+X_C_delta_e*Tr_delta_e)... 
     + (P_rho*P_S_c*Tr_q*Tr_w*P_X_C_q/4*P_mass*Tr_Va) + (P_rho*P_S_wing*Tr_u*X_C_q_alpha/2*P_mass) - (P_rho*P_S_prop*Tr_w*P_C_prop/P_mass);
Xq = -Tr_w + (P_rho*Tr_Va*P_S_wing*P_X_C_q*P_c)/(4*P_mass);
Xdel_e = (P_rho*P_S_wing*X_C_delta_e*(Tr_Va^2))/(2*P_mass);
Xdel_t = (P_rho*P_S_prop*P_C_prop*Tr_delta_t/(P_mass))*(P_k_motor^2);

Zu = Tr_q + (Tr_u*P_rho*P_S_wing/P_mass)*(P_C_Z_0+Z_C_alpha*Tr_alpha+Z_C_delta_e*Tr_delta_e) ...
     - (P_rho*P_S_wing*Z_C_alpha*Tr_w/2*P_mass) + (Tr_u*P_rho*Tr_S_wing*P_C_Z_q*P_c*Tr_q/4*P_mass*Tr_Va);
Zw  = (P_rho*P_S_wing*Tr_w/P_mass)*(P_C_Z_0+Z_C_alpha*P_alpha0+Z_C_delta_e*Tr_delta_e) ...
     + (P_rho*P_S_wing*Z_C_alpha*Tr_u/2*P_mass) + (P_rho*Tr_w*P_S_wing*P_c*P_C_Z_q*Tr_q/4*P_mass*Tr_Va);
Zq  = Tr_u + (P_rho*P_S_wing*P_C_Z_q*Tr_Va*P_c/(4*P_mass));
Zdel_e  = (P_rho*P_S_wing*Tr_Va*Tr_Va/(2*P_mass))*Z_C_delta_e;
Zdel_t = 0;

Mu = (Tr_u*P_rho*P_S_wing/P_Jy)*(P_C_m_0 + P_C_m_alpha*Tr_alpha + P_C_m_delta_e*Tr_delta_e) ...
     - (P_rho*P_S_wing*P_c*P_C_m_alpha*Tr_w/2*P_Jy) + (P_rho*P_S_wing*(P_c^2)*P_C_m_q*Tr_q*Tr_u/4*P_Jy*Tr_Va);
Mw = (Tr_w*P_rho*P_S_wing*P_c/P_Jy)*(P_C_m_0+P_C_m_alpha*Tr_alpha+P_C_m_delta_e*Tr_delta_e) ...
     + (P_rho*P_S_wing*P_c*P_C_m_alpha*Tr_u/2*P_Jy) + (P_rho*P_S_wing*(P_c^2)*P_C_m_q*Tr_q*Tr_w/4*P_Jy*Tr_Va);
Mq =  P_rho*P_V_max*P_S_wing*(P_c^2)*m_C/4*P_Jy;
Mdel_e = P_rho*Tr_Va*Tr_Va*P_S_wing*P_c*P_C_m_delta_e/2*P_Jy;
%---------------

A_long = [Xu Xw Xq -P_gravity*cos(Tr_theta) 0;
         Zu Zw Zq -P_gravity*sin(Tr_theta) 0;
         Mu Mw Mq 0 0;
         0 0 1 0 0;
         sin(Tr_theta) -cos(Tr_theta) 0 Tr_u*cos(Tr_theta)+Tr_w*sin(Tr_theta) 0];
 
B_long  = [Xdel_e Xdel_t; 
          Zdel_e 0;
          Mdel_e 0;
          0 0;
          0 0];
