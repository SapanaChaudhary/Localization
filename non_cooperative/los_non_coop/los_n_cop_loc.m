% SDP estimator 3 : SDP_RSS for the data given in the paper
% different norms cab be used 
% ML estimator can be solved by the MATLAB function lsqnonlin
%clc
%function [theta_pred] = sdp_3_nlos(L,phi,M)
load('L_A')
load('phi')
M = 1;
rad = 500; % radius of the circle centered at (0,0)
N = 6; % No. of RNs
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma = 3; % path loss exponent
%sigma = 2; % noise variance
%theta_org = [0 2]; % BN location

%load('L');
%load('phi');
for i = 1:N
k(i) = norm(phi(i,:),2);
end

for j = 1:M
%% obtain the beta_i
beta1 = d_0 * 10.^((L_A(j,:)-L_0)/(10*gamma));

%% sdp optimization using cvx
m = 2;
n = 6;

cvx_begin sdp quiet
variable X(m,m) symmetric
variable theta(m)
variable t(n)
minimize(norm(t,1))
subject to
for i = 1:N,
trace(X) - 2*(phi(i,:))*theta + k(i) <= (beta1(i)^2)*t(i);
% trace(X) - 2*(phi(i,:))*theta + k(i) >= (beta1(i)^2).*(1./t(i))
%LMI
[trace(X) - 2*(phi(i,:))*theta + k(i),beta1(i); beta1(i),t(i)] >= 0;
end
t >= 0;
[X,theta ; theta',1] >= 0 ;
cvx_end

theta_pred(j,:) = theta;
end
% %% error
% for i = 1:M
% err(i) = (theta_pred(i,1)-theta_org(1))^2 + (theta_pred(i,2)-theta_org(2))^2;
% end
% %% RMSE
% rmse = sqrt(sum(err)/M);
%% dummy 
% cvx_begin
% variable X( n, n ) symmetric
% dual variables y{n}
% minimize( ( n - 1 : -1 : 0 )*diag( X ) );
% for k = 0 : n-1,
% sum( diag( X, k ) ) == b( k+1 ) : y{k+1};
% end
% X == semidefinite(n);
% cvx_end