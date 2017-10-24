% generate data as given in the paper
function [L] = gen_paper_data(sigma)
%% initializations
rad = 20; % radius of the circle centered at (0,0)
N = 3; % No. of RNs
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma = 3; % path loss exponent
%sigma = 1; % noise variance
theta = [0 2]; %[-5 -15];

%% get RN locations
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end

phi = [a;b]';
save('phi','phi');

%% obtain RSS at BN
% path loss model 
M = 1000;
for j = 1:M
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma,N);
    for i = 1:N
        L(j,i) = L_0 + 10*gamma*log10(norm(theta-phi(i,:),2)/d_0) + m(i);
    end
end
%save('L','L');
end















