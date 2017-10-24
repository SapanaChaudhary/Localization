% generate data as given in the paper
% data generation and clustering with both LOS
% and NLOS 
clear all
close all

%% initializations
rad = 20; % radius of the circle centered at (0,0)
N = 6; % No. of RNs
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma = 3; % path loss exponent
sigma = 1; % noise variance
%theta = [0 2]; %[-5 -15];
n = 50;
theta = randi(40,n,2); % from gxg grid sample n points 
theta_org = theta - repmat([20 20],n,1);
save('theta_org','theta_org');
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

%% obtain RSS at BN from NLOS BS
for j = 1:n % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,nlos_sigma,1);
    for i = 1 % from all the NLOS BS
        L(j,i) = L_0 + 10*nlos_gamma*log10(norm(theta(j,:)-phi(i,:),2)/d_0) + m(i);
    end
end

%% obtain RSS at BN from LOS BS
% path loss model 
for j = 1:n % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma,N-1);
    for i = 2:N % from all the LOS BSs
        L(j,i) = L_0 + 10*gamma*log10(norm(theta(j,:)-phi(i,:),2)/d_0) + m(i-1);
    end
end
save('L','L');

%% k means clustering
no_of_clusters = 10;
idx = kmeans(L,no_of_clusters);

%% sort
theta_1 = [idx theta_org];
theta_1 = sortrows(theta_1,1);
save('theta_1','theta_1');

%% make plots : original data
figure(1)
scatter(phi(:,1),phi(:,2),'filled');
hold on 
scatter(theta_org(:,1),theta_org(:,2),'g');
figure('Name','Original data')

%% clustered data
figure(2)
% get the index counts
for k = 1:no_of_clusters
    idx_count(k) = sum(theta_1(:,1)==k);
end

idx_count = [idx_count 0];

a = 1;
b = idx_count(1);
for i = 1:no_of_clusters
    theta_2 = [];
    theta_2 = theta_1(a:b,2:3);
    a = b+1;
    b = b + idx_count(i+1);
    scatter(theta_2(:,1),theta_2(:,2),'filled');
    hold on
end





