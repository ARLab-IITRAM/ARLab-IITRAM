% % Tutorial on Least Square Technique
% Use of LSE for heihght estimation from GPS and pressure sensors
%% Sensor data for estimation 
% Height estimation from GPS and pressure sensor
load('Height_Sensing')
y1 = z_GPS'; % Measurement 1
y2 = z_press'; % Measurement 2
Y = [y1;y2]; % All sensor measurements
%% Least Square fitting for a given data set - Estimation of a constant (Sequential Estimation)
% Y  = G x  ; x =  height
% G = [1 ; rho*g]; % rho = 1.225, g =9.81 
%-- Initilization
x_hat_SLE(:,1) = [0]; % initial estimate for [x]
P_SLE{1} = eye(1); % initial error covariance
p = length(y1); % total number of samples aviliable
R = [100,0; 0 500 ]; % Covariance of the noises in sensors
G_SLE = [1;1.225*9.81]; % Initial mapping functions 
y_hat_SLE(:,1) = [0;0]; % Initial output estimate
for i = 2: p
    %-- Step 1: 
    K_SLE = P_SLE{i-1}*G_SLE'*inv(G_SLE*P_SLE{i-1}*G_SLE' + R); % Gain computed
    P_SLE{i} = (1-K_SLE*G_SLE)*P_SLE{i-1}; % Covariance update
    x_hat_SLE(:,i) = x_hat_SLE(:,i-1) + K_SLE*(Y(:,i)-G_SLE*x_hat_SLE(:,i-1));  % estimated states
    y_hat_SLE(:,i) = G_SLE*x_hat_SLE(:,i-1); % estimated output
end
%-- 
figure; 
plot(Y(1,:)); hold on; plot(y_hat_SLE(1,:),'-r'); legend('output','estimated'); title('GPS measurement estimates');
figure; 
plot(Y(2,:)); hold on; plot(y_hat_SLE(2,:),'-r'); legend('output','estimated'); title('Pressure measurement estimates');
figure; 
plot(Y(1,:) -y_hat_SLE(1,:)); hold on; plot(Y(2,:) -y_hat_SLE(2,:),'-r'); legend('Error-GPS','Error-barometer'); title('Measurement Errors');
figure; 
plot(x_hat_SLE); title('Estimated height');
%-----






