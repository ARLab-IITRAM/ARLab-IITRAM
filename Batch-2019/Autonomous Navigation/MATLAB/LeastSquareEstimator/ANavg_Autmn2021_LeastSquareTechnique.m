% % Tutorial on Least Square Technique
% Use of LSE for state estimation from sensor information
%% Sensor data for estimation 
% Create a model of the sensor as function of states. 
trueParams = [50, -0.7]; 
% create some noisy data using a square root function with 2 parameters and nasty noise
x = linspace(0, 20, 100); 
modelFun = @(param, x) param(1)*sqrt(max(0, x + param(2)));
noise = 10*sin(x).^2 .* randn(size(x));


y = modelFun(trueParams, x) + noise; % Measurement model from Sensor
y = y';
% -- Visualize
figure;
plot(x,y,'.'); hold on;
xlabel('samples')
ylabel('Measurement Data')


%% Least Square fitting for a given data set - Estimation of a constant (Batch Estimation)
%--- Problem Statement
% Given measurements 'y', find the best estimate of a constant 'x' using LSE approach.
% Assume 'p' samples of measurement data is avilaible at once. The following relationship holds 
%  y = G(x) x + eta; %eta =  noise, G(x) can be a linear/nonlinear mapping function of x for 'p' samples of data
%--------------- CASE A: Linear G(x)
% y = a_1 x ;
G_1 = [x'];
x_1hat = inv(G_1'*G_1)*(G_1'*y); % estimated constant state
Y_1est = G_1*x_1hat; % estimated output
plot(x,Y_1est,'r-'); legend('Measurement','LSE-Linear')
%-- Statistical analysis
mu_LSE_A = mean(Y_1est-y); % Mean of error
var_LSE_A = var(Y_1est-y); % variance of error
%--------- CASE B: Nonlinear G(x)
%y = a_0 + a_1 x + a_2x^2  ; x = [x1 x2 x3] = [ 0 x x^2]; 
G_2 = [ones(length(x),1),x',(x.^2)'];
x_2hat = inv(G_2'*G_2)*(G_2'*y); % estimated constant state
Y_2est = G_2*x_2hat; % estimated output
plot(x,Y_2est,'g-');legend('Measurement','LSE-Linear','LSE-NonLinear')
%-- Statistical analysis
mu_LSE_B = mean(Y_2est-y); % Mean of error
var_LSE_B = var(Y_2est-y); % variance of error
%% Least Square fitting for a given data set - Estimation of a constant (Sequential Estimation)
%-- Initilization
x_hat_SLE(:,1) = [0; 0; 0]; % initial estimate for [x1 x2 x3]
P_SLE{1} = 0.1*eye(3); % initial error covariance
p = length(y); % total number of samples aviliable
R(1) = var(noise);
G_SLE(1,:) = [1,x(1)',(x(1).^2)]; % Initial mapping functions 
y_hat_SLE(1) = 0;
for i = 2: p
    %-- Step 1: 
    R(i) = var(noise); % the noise variance/covariance
    % Fitting for the following nonlinear mapping
    % y = a_0 + a_1 x + a_2x^2  ; x = [x1 x2 x3] = [ 0 x x^2]; 
    G_SLE(i,:) = [1,x(i)',(x(i).^2)]; % the mapping at ith iteration
    K_SLE(:,i) = P_SLE{i-1}*G_SLE(i,:)'*inv(G_SLE(i,:)*P_SLE{i-1}*G_SLE(i,:)' + R(i)); % Gain computed
    P_SLE{i} = (1-K_SLE(:,i)*G_SLE(i,:))*P_SLE{i-1}; % Covariance update
    x_hat_SLE(:,i) = x_hat_SLE(:,i-1) + K_SLE(:,i)*(y(i)-G_SLE(i,:)*x_hat_SLE(:,i-1));  % estimated states
    y_hat_SLE(i,:) = G_SLE(i,:)*x_hat_SLE(:,i-1); % estimated output
end
plot(x,y_hat_SLE,'m--');legend('Measurement','LSE-Linear','LSE-NonLinear','SLSE-Nonlinear')
%-- Statistical analysis
mu_SLSE = mean(y_hat_SLE-y); % Mean of error
var_SLSE = var(y_hat_SLE-y); % variance of error

