%%  cooperative localization data generation los+nlos
% generate data as given in the paper
% data generation and clustering with both LOS
% and NLOS 
clear all
close all

%% initializations
rad = 500; % radius of the circle centered at (0,0)
N = 6; % No. of RNs
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma = 3; % path loss exponent
sigma = 1; % noise variance
%theta = [0 2]; %[-5 -15];
M = 30;

%% Get BN locations
theta = randi(1000,M,2); % from gxg grid sample n points 
theta_org = theta - repmat([500 500],M,1);
save('theta_org','theta_org');
%save('theta_org','theta_org');
%% NLOS parameters
nlos_gamma = 4;
nlos_sigma = 4;

%% get RN locations
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end

phi = [a;b]';
save('phi','phi');

%% Get L_A : L for set A : It is a matrix
% obtain RSS at BN from NLOS BS
for j = 1:M % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,nlos_sigma,2);
    k = 1;
    for i = [1] %,4] % from all the NLOS BS
        L_A(j,i) = L_0 + 10*nlos_gamma*log10(norm(theta_org(j,:)-phi(i,:),2)/d_0) + m(k);
    k = k+1;
    end
end

% obtain RSS at BN from LOS BS
% path loss model 
for j = 1:M % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma,N-1);
    k = 1;
    for i = [2,3,4,5,6] % from all the LOS BSs
        L_A(j,i) = L_0 + 10*gamma*log10(norm(theta_org(j,:)-phi(i,:),2)/d_0) + m(k);
        k = k+1;
    end
end
save('L_A','L_A');

%% Get L_B : L for set B : It is a vector
% obtain RSS at BN from NLOS BS
% L_B = zeros(M-1,M-1)
k = 1;
for j = 1:M % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma,M);
    for i = (j+1):M
        L_B(k) = L_0 + 10*gamma*log10(norm(theta_org(j,:)-theta_org(i,:),2)/d_0) + m(i);
        k = k+1;
    end
end

save('L_B','L_B');