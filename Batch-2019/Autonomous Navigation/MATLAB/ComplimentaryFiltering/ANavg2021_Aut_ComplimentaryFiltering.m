%% Tutorial on Complimentary Filtering for Sensors
% Ref Lecture: Sensors for UAVs (Lec 2-3)


% The basic idea behind complimentary filtering is to use a combination of
% high pass and low pass filtering approaches to get a better signal.
%---
acc_data = xlsread('Accelero.csv');
accx = acc_data(:,2);
accy = acc_data(:,3);
accz = acc_data(:,4);
gyr_data = xlsread('Gyros.csv');
gyrx = gyr_data(:,2);
gyry = gyr_data(:,3);
gyrz = gyr_data(:,4);
Ts = 1/50; % rate at which data is obtained.
%%  Using HPF for drift correction
%----- Lets calculate angle from y-axis
angy(1) = 0;
for i = 1:length(gyry)
    if i< length(gyry)
        angy(i+1)  = angy(i) + gyry(i+1)*Ts; % integrate the gyro 
    end
end
%-- Plotting angle value from Gyroscope
figure;
plot(angy,'-'); hold on; 
anggyr = angy;
%-- Compute the HPF coefficient
% Based on cutoff frequency
fc_hp = 3; % Cut off frequency in Hz
tau_hp = 1/(2*pi*fc_hp); % time constant
alpha_hp = tau_hp/(tau_hp+Ts); % Scaling factor/ filter coefficient
%-- Pass signal through HPF
anggyr_hp(1) = 0;
for i = 2: length(gyrx)
    anggyr_hp(i) = (alpha_hp*anggyr_hp(i-1) + alpha_hp*(anggyr(i)- anggyr(i-1))); % Computing the HPF
end    
%-- Plot filtered signal
hold on; plot (anggyr_hp,'m-');
legend('Angle using raw signal','Angle using HPF')
title('Drift correction')

%% Using LPF for noise/jitter reduction
%-- Calculate angle from the accelerometer
for i = 1:length(accy)
    angacc(i) = atan2(accy(i),sqrt((accx(i)*accx(i)) + (accz(i)*accz(i))))*(180/pi);   
end
%-- Plotting angle value from Gyroscope
figure;
plot(angacc,'-'); hold on; 
% Design of LPF for the acclerometer signal
% Based on cutoff frequency
fc_lp = 3; % Cut off frequency in Hz
tau_lp = 1/(2*pi*fc_lp); % time constant
alpha_lp = Ts/(tau_lp+Ts); % Scaling factor/ filter coefficient
% Pass signal through the LPF
angac_lp(1) = angacc(1);
for i = 2:length(accy) 
   angac_lp(i) = alpha_lp*angacc(i) + (1-alpha_lp)*angac_lp(i-1); 
end
hold on; plot(angac_lp,'--m');legend('raw data', 'filtered data');

%% Complimentary filtering without LPF/HPF for signals
%-- Complimentary filter without LPF /HPF for individual signals
alpha_cp = 0.2;
for i = 2:length(gyry)
 % Combine both to form the complimentary filter 
ang_co(i) = alpha_cp *anggyr(i) + (1-alpha_cp)*angacc(i); 
end
figure; 
plot(anggyr); 
hold on; 
plot(angacc,'m');
plot(ang_co,'g'); 
legend('Gyro-angle','Acc-angle','Compl Filter-angle');
title('Complimentary Filter without LPF/HPF for individual signals');

%% Complimentary filter with LPF /HPF for individual signals
alpha_cp = 0.02;
for i = 2:length(gyry)
% Combine both to form the complimentary filter 
ang_co(i) = alpha_cp *anggyr_hp(i) + (1-alpha_cp)*angac_lp(i); 
end
figure; 
plot(anggyr); 
hold on; 
plot(angacc,'m');
plot(ang_co,'g'); 
legend('Gyro-angle','Acc-angle','Compl Filter-angle');
title('Complimentary Filter with LPF/HPF for individual signals');

% Note that in this case for the 


