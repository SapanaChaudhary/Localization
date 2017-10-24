% Localize points within clusters and find their points 
%% get RN locations
clc
clear all
close all

% generate training data
los_nlos_data_gen_plus_clustering;
clear all
load('L'); 

N = 6; % number of BSs
M = 50; % number of BNs
rad = 20; % radius of the circle centered at (0,0)
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma = 3; % path loss exponent
%sigma = 1; % noise variance
%theta = [12 -2]; %[-5 -15];

for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end

phi = [a;b]';
save('phi','phi');

% get predicted locations
theta_pred = sdp_3_nlos(L,phi,M);

%% plot predicted values
figure(3)
scatter(theta_pred(:,1),theta_pred(:,2));

%% calculate error in predicted values
load('theta_org');
for i = 1:M
err(i) = sqrt((theta_pred(i,1)-theta_org(i,1))^2 + (theta_pred(i,2)-theta_org(i,2))^2);
end