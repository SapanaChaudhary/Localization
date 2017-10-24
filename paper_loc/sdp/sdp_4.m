% SDP estimator 4 : SDP for the data given in the paper
% different norms cab be used 
% ML estimator can be solved by the MATLAB function lsqnonlin
clc
clear all
close all

rad = 20; % radius of the circle centered at (0,0)
N = 5; % No. of RNs
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma = 3; % path loss exponent
sigma = 2; % noise variance
%theta = [-5 -15]; % BN location

load('L');
load('phi');
for i = 1:N
k(i) = norm(phi(i,:),2);
end

%% obtain the beta_i
beta1 = d_0 * 10.^((L(1,:)-L_0)/(10*gamma));

%% sdp optimization using cvx
m = 2;
n = 5;

cvx_begin sdp
variable X(m,m) symmetric
variable theta(m)
variable t(n)
minimize(norm(t,1))
%subject to
for i = 1:N,
trace(X) - 2*(phi(i,:))*theta + k(i) - beta1(i)^2 <= t(i)
trace(X) - 2*(phi(i,:))*theta + k(i) - beta1(1)^2 >= -t(i)
end
t >= 0;
[X,theta ; theta',1] >= 0 ;
cvx_end