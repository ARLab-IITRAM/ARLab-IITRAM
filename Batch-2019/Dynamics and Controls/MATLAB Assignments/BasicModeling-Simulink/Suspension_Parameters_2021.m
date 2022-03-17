%% Active Suspension Parameters
% Refrence MATLAB help: Active suspension design

mb = 300;    % kg
mw = 60;     % kg
bs = 1000;   % N/m/s
ks = 16000 ; % N/m
kt = 190000; % N/m
ksn = 0.1*ks; 
bsn = 0.1*bs;

%% Model representation
A = [ 0 1 0 0; [-ks -bs ks bs]/mb ; ...
      0 0 0 1; [ks bs -ks-kt -bs]/mw];
B = [0 0; 0 1/mb ; 0 0; [kt -1]/mw];
C = eye(4); % All states are measured
D = [0 0; 0 0; 0 0 ; 0 0];

qcar = ss(A,B,C,D);
qcar.StateName = {'body travel xb (m)';'body vel (m/s)';...
                  'wheel travel xw (m)';'wheel vel (m/s)'};
qcar.InputName = {'r';'fs'};
qcar.OutputName = {'xb';'xbdot';'xw';'xwdot'};

%% Initial Conditions
% Can choose any initial condition 
Initial.x1  = 0.01;
Initial.x2 = -0.02;
Initial.x3 = 0.04;
Initial.x4 = 0.25;
