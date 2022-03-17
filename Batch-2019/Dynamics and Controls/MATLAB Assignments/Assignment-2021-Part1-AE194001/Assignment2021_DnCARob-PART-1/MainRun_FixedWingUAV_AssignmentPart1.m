%% Dynamic Modeling for a Fixed Wing Aerosonde AV

% Assignment Part 1: AE 194001
% Marks will be awarded only for successful completion of all parts. 
% Each section one example is provided. Students have to accordingly
% complete the other portions to complete the section. 
%% Files common for all Parts
addpath('ScriptFiles_FW2021','ModelFiles_FW2021','DataSets_FW2021'); % Adds to path
load('Trim_UAVAerosonde.mat'); % Loads the trim values for x and u computed for the 12-state nonlinear model
Parameters_Aerosonde_UAV;  % Loads all parameters of the Aerosonde AV required for simulation
%% PART 1a: LINEARIZED LATERAL STATE SPACE MODEL
% %--- Objective : Develop the lateral state space model of a FW UAV and simulate response
% % to arbitrary initial conditions and step input response
% %------- Running the Model-------------------------------
% Trun = 25; % Total Duration of the Run
% Initial_Lat = [x_trim(5);x_trim(10);x_trim(12);x_trim(7);Tr_psi];  % Specified Initial Conditions for [v,p,r,phi,psi]
% Linearized_LatModel_Parameters; % Loads the linearized parameters of the state matrices corresponding to trim values
% open('FW_LinLateralModel'); % Opens the model
% sim('FW_LinLateralModel'); % Runs the lateral model 
%% PART 1b: LINEARIZED LONGITUDINAL STATE SPACE MODEL
%--- Objective : Develop the longitudinal state space model of a FW UAV and simulate response
% to arbitrary initial conditions and step input response
% TO BE DONE AS PART OF ASSIGNMENT
Trun = 25;
Initital_Long = [x_trim(5);x_trim(10);x_trim(12);Tr_theta;x_trim(7)]; % Specified Initial Conditions for [u,w,q,theta,h]
Linearized_LongModel_Parameters; % Loads the linearized parameters of the state matrices corresponding to trim values
open('FW_LinLongitudinalModel'); % Opens the model
sim('FW_LinLongitudinalModel'); % Runs the lateral model 

%% PART 2a: REDUCED ORDER MODES- LATERAL DYNAMICS
%--- Objective : Develop the reduced order modes for the lateral dynamics
%(a) Roll b) Spiral Divergence c) Dutch Roll. Analyze the effect on lateral
%dynamics by exciting each mode independently. 
Trun = 5; % Total Duration of the Run
Linearized_LatModel_Parameters; % Loads the linearized parameters of the state matrices corresponding to trim values
%-- STEP 1: Analysis of LATERAL DYNAMICS MODES
[EigVec_lat, Eig_lat] = eig(A_lat); % Computes the eigen values of the lateral FW-UAV 
sys_lat = ss(A_lat,B_lat,[],[]); % Linear SS model of the lateral dynamics
[wn,zeta,p] = damp(sys_lat); % Computes the natural frequncies, zeta and poles 
%-- Recall from lecture: For the lateral dynamics, real poles correspond to
%the roll and spiral divergence mode. Complex pole corresponds to the dutch
%roll mode. 
% From the natural frequencies we can see 
% wn  = 0.0286, i.e. T >> .. or slow mode ---- Spiral Mode
% wn =  13.3599, i.e. due to complex poles  ---- Dutch Roll Mode
% wn = 16.3961, i.e. T<< or fast mode ---- Roll Mode
%--- STEP 2: Exciting individual modes
%--- Roll mode
% Eigen value corresponding to roll mode =  -16.3961 + 0.0000i, eigen
% vector column is 2.
% To excite specific mode, we take initial conditions as linear combination
% of eigen vectors of that eigen value. Thus, 
Initial_Lat_Roll = real([EigVec_lat(:,2)]);  % Specified Initial Conditions for [v,p,r,phi,psi] corresponding to roll mode
% %NOTE: Before running for reduced order modes, set the inputs i.e. delta_a and
% % delta_r to zero in the SIMULINK FILE and the initial conditions accordingly. 
open('FW_LinLateralModel'); % Opens the model
sim('FW_LinLateralModel'); % Runs the lateral model 


%--------------------

% ANALYSIS OF DUTCH ROLL AND SPIRAL MODE :  TO BE DONE AS PART OF ASSIGNMENT





%% PART 2b: REDUCED ORDER MODES - LONGITUDINAL DYNAMICS
%--- Objective : Develop the reduced order modes for the longitudinal dynamics
%(a) Short Period b) Phugoid  Analyze the effect on longitudinal
%dynamics by exciting each mode independently. 



% TO BE DONE AS PART OF ASSIGNMENT


%% PART 3a: TRANSFER FUNCTION MODEL - LATERAL DYNAMICS
%--- Objective : Develop the transfer function models for the lateral
%dynamics of a fixed wing UAV realting roll and yaw with the aileron and rudder inputs.  
 Trun = 15; % Total Duration of the Run
 TransFunction_LateralParameters; % Loads the linearized parameters of the transfer functions corresponding to trim values
%A -- TF_phi_delta 
a_phi1 =-0.25*P_rho*Va_trim*P_S_wing*(P_b^2)*P_C_p_p;
a_phi2 = 0.5*P_rho*(Va_trim^2)*P_S_wing*P_b*P_C_p_delta_a;
%-- Define the TF
T_phi_delta_a   = tf([a_phi2],[1,a_phi1,0]); % The transfer function between roll angle and aileron angle




%---- B - TF_ TF_chi_phi 

% TO BE DONE AS PART OF ASSIGNMENT

%----- C -T_v_delta_r 

% TO BE DONE AS PART OF ASSIGNMENT

% Run Simulation
open('FW_TFLateralModel'); % Opens the model
sim('FW_TFLateralModel'); % Runs the lateral TF model 
%% PART 3b: TRANSFER FUNCTION MODEL - LONGITUDINAL DYNAMICS
%--- Objective : Develop the transfer function models for the longitudinal
%dynamics of a fixed wing UAV realting pitch and altitude with the elevator and thrust inputs.  


% TO BE DONE AS PART OF ASSIGNMENT



