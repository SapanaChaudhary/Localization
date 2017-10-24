% generate data as given in the paper
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
theta = theta - repmat([20 20],n,1);
%% get RN locations
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end

phi = [a;b]';
save('phi','phi');

%% obtain RSS at BN
% path loss model 
for j = 1:n
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma,N);
    for i = 1:N
        L(j,i) = L_0 + 10*gamma*log10(norm(theta(j,:)-phi(i,:),2)/d_0) + m(i);
    end
end
%save('L','L');

%% k means clustering
idx = kmeans(L,10);

%% sort
theta_1 = [idx theta];
theta_1 = sortrows(theta_1,1);






