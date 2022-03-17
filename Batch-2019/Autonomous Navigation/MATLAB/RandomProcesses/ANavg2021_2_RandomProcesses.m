%% Introduction to Random Processes

%% STEP 1: Generating a random number
%--Syntax:  U = rand(m,n) 
%Ex: Simulate tossing a coin with probability of heads p 
% Deife the uniform random variable U in range (0,1)
p = 0:5;
U = rand;
X = (U < p);

%% STEP 2: PDF of an uniform Random variable
%  rand function generates continuous uniform random numbers in the interval (0, 1).
%To generate a random number in the interval (a, b) : a + (b-a)*rand(n,m); %Here nxm is the size of the output matrix
%--- Define the interval
a=2;b=10; %open interval (2,10)
%-- Define the random variable
X_un=a+(b-a)*rand(1,1000000);%simulate uniform RV
%----- Plot the PDF
figure;
[p,edges]=histcounts(X_un,'Normalization','pdf');%estimated PDF

%--- The theoritical uniform PDF
outcomes = 0.5*(edges(1:end-1) + edges(2:end));%possible outcomes
g_un=1/(b-a)*ones(1,length(outcomes)); %Theoretical PDF

%--- Comparing with the theoritical PDF
bar(outcomes,p);hold on;plot(outcomes,g_un,'r-');
title('Probability Density Function');legend('simulated','theory');
xlabel('Possible outcomes');ylabel('Probability of outcomes');

%% Step 3: Creating a Gaussian Random Variables
%--- Using Inbuilt routine random of matlab
mu=0;sigma=1;%mean=0,deviation=1
L=100000; %length of the random vector
R_1 = random('Normal',mu,sigma,L,1);
%-------- Using randn 
mu=0;sigma=1;%mean=0,deviation=1
L=100000; %length of the random vector
R_2 = randn(L,1)*sigma + mu; %method 2
%--- Plot the PDF
figure;
histogram(R_1,'Normalization','pdf'); %plot estimated pdf from the generated data
%----Comparision with the theoritical formulae
X = -4:0.1:4; %range of x to compute the theoretical pdf
fx_theory = 1/sqrt(2*pi*sigma^2)*exp(-0.5*(X-mu).^2./sigma^2); % The PDF for the Gaussian Distribution.
%--- Plot the comparision
hold on;
plot(X,fx_theory,'k'); %plot computed theoretical PDF
fx_theory = pdf('Normal',X,mu,sigma); %theoretical normal probability density
%--- Comparision with the Simulated PDF
hold on; plot(X,fx_theory,'r'); %plot computed theoretical PDF
title('Probability Density Function'); xlabel('values - x'); ylabel('pdf - f(x)'); axis tight;
legend('simulated','simulated','theory');
%------



