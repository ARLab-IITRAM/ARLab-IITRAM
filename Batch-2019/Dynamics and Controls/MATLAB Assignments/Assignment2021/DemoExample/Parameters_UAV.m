% Parameters of the UAV
P_gravity = 9.81; % m/s^2
%physical parameters of airframe
P_mass = 13.5; % kg
P_Jx   = 0.8244; % kg m^2
P_Jy   = 1.135; % kg m^2
P_Jz   = 1.759; % kg m^2
P_Jxz  = 0.1204; % kg m^2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% aerodynamic coefficients
P_S_wing        = 0.55;
P_b             = 2.8956;
P_c             = 0.18994;
P_S_prop        = 0.2027;
P_rho           = 1.2682;
P_k_motor       = 80;
P_k_T_P         = 0;
P_k_Omega       = 0;
P_e             = 0.9;
P_C_L_0         = 0.28;
P_C_L_alpha     = 3.45;
P_C_L_q         = 0.0;
P_C_L_delta_e   = -0.36;
P_C_D_0         = 0.03;
P_C_D_alpha     = 0.30;
P_C_D_p         = 0.0437;
P_C_D_q         = 0.0;
P_C_D_delta_e   = 0.0;
P_C_m_0         = -0.02338;
P_C_m_alpha     = -0.38;
P_C_m_q         = -3.6;
P_C_m_delta_e   = -0.5;
P_C_Y_0         = 0.0;
P_C_Y_beta      = -0.98;
P_C_Y_p         = 0.0;
P_C_Y_r         = 0.0;
P_C_Y_delta_a   = 0.0;
P_C_Y_delta_r   = -0.17;
P_C_ell_0       = 0.0;
P_C_ell_beta    = -0.12;
P_C_ell_p       = -0.26;
P_C_ell_r       = 0.14;
P_C_ell_delta_a = 0.08;
P_C_ell_delta_r = 0.105;
P_C_n_0         = 0.0;
P_C_n_beta      = 0.25;
P_C_n_p         = 0.022;
P_C_n_r         = -0.35;
P_C_n_delta_a   = 0.06;
P_C_n_delta_r   = -0.032;
P_C_prop        = 1.0;
P_M             = 50;
P_epsilon       = 0.1592;
P_alpha0        = 0.4712;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Prop parameters
P_D_prop = 20*(0.0254);     % prop diameter in m
% Motor parameters
P_K_V = 145.;                   % from datasheet RPM/V
P_KQ = (1. / P_K_V) * 60. / (2. * pi);  % KQ in N-m/A, V-s/rad
P_R_motor = 0.042;              % ohms
P_i0 = 1.5;                     % no-load (zero-torque) current (A)
% Inputs
P_ncells = 12.;
P_V_max = 3.7 * P_ncells;  % max voltage for specified number of battery cells
% Coeffiecients from prop_data fit
P_C_Q2 = -0.01664;
P_C_Q1 = 0.004970;
P_C_Q0 = 0.005230;
P_C_T2 = -0.1079;
P_C_T1 = -0.06044;
P_C_T0 = 0.09357;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% sample time
%P_Ts = 10;
% autopilot sample rate
P_Ts = 0.01;
% compute trim conditions using 

P_Va    = 35;         % desired airspeed (m/s)
gamma = 0*pi/180;  % desired flight path angle (radians)
R     = 100000000; %150;         % desired radius (m) - use (+) for right handed orbit, 
                    %                          (-) for left handed orbit
h0    = 0;  % initial altitude              
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initial conditions
P_pn0    = 0;  % initial North position
P_pe0    = 0;  % initial East position
P_pd0    = 0;  % initial Down position (negative altitude)
P_u0     = P_Va;  % initial velocity along body x-axis
P_v0     = 0;  % initial velocity along body y-axis
P_w0     = 0;  % initial velocity along body z-axis
P_phi0   = 0;  % initial roll angle
P_theta0 = 0;  % initial pitch angle
P_psi0   = 0;  % initial yaw angle
P_p0     = 0;  % initial body frame roll rate
P_q0     = 0;  % initial body frame pitch rate
P_r0    = 0;  % initial body frame yaw rate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
P_gamma = P_Jx*P_Jz-P_Jxz^2;
P_gamma_1 = (P_Jxz*(P_Jx-P_Jy+P_Jz))/P_gamma;
P_gamma_2 = (P_Jz*(P_Jz-P_Jy)+P_Jxz^2)/P_gamma;
P_gamma_3 = P_Jz/P_gamma;
P_gamma_4 = P_Jxz/P_gamma;
P_gamma_5 = (P_Jz-P_Jx)/P_Jy;
P_gamma_6 = P_Jxz/P_Jy;
P_gamma_7 = ((P_Jx-P_Jy)*P_Jx+P_Jxz^2)/P_gamma;
P_gamma_8 = P_Jx/P_gamma;
%% Composite Coefficients 
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% wind
P_wind_n = 0;
P_wind_e = 0;
P_wind_d = 0;
P_L_u = 200;
P_L_v = 200;
P_L_w = 50;
P_sigma_u = 1.06;
P_sigma_v = 1.06;
P_sigma_w = 0.7;


%P_Va0 = 13;
% % set initial conditions to trim conditions
% % initial conditions
% P_pn0    = 0;   % Initial North position
% P_pe0    = 0;   % Initial East position
% P_Pd0    = -h0; % Initial Down postion
% P_u0     = x_trim(4);  % initial velocity along body x-axis
% P_v0     = x_trim(5);  % initial velocity along body y-axis
% P_w0     = x_trim(6);  % initial velocity along body z-axis
% P_phi0   = x_trim(7);  % initial roll angle
% P_theta0 = x_trim(8);  % initial pitch angle
% P_p0     = x_trim(10);  % initial body frame roll rate
% P_q0     = x_trim(11);  % initial body frame pitch rate
% P_r0     = x_trim(12);  % initial body frame yaw rate
% % compute different transfer functions
% [T_phi_delta_a,T_chi_phi,T_theta_delta_e,T_h_theta,T_h_Va,T_Va_delta_t,T_Va_theta,T_v_delta_r]...
%    = compute_tf_model(x_trim,u_trim,P);
% % linearize the equations of motion around trim conditions
% [A_lon, B_lon, A_lat, B_lat] = compute_ss_model('mavsim_trim',x_trim,u_trim);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
