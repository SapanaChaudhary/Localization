%% get RN locations
clc
clear all
close all
rad = 20; % radius of the circle centered at (0,0)
N = 3; % No. of RNs
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma = 3; % path loss exponent
%sigma = 1; % noise variance
theta = [12 -2]; %[-5 -15];

for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end

phi = [a;b]';
save('phi','phi');

for ii = 1:6
   L = gen_paper_data(ii); 
   rmse(ii) = sdp_3(L,phi);
%    save('rmse','rmse');
%    clear 
end