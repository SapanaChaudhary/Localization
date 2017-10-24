% SDP estimator 1
% different norms cab be used 
% ML estimator can be solved by the MATLAB function lsqnonlin
clc
clear all
close all

%% input to the function
N = 5; % number of regerence nodes(NDs)/Base Stations(BSs)
g = 120; % size of the grid over which localization has to be performed

%% co-ordinates of the BSs
load('x_b');load('y_b');
phi = [x_b;y_b]';
for i = 1:N
k(i) = norm(phi(i,:),2);
end

%% get powers from different BSs
p1 = load('P_db_11'); p1 = p1.P_db_11;
p2 = load('P_db_22'); p2 = p2.P_db_22;
p3 = load('P_db_33'); p3 = p3.P_db_33;
p4 = load('P_db_44'); p4 = p4.P_db_44;
p5 = load('P_db_55'); p5 = p5.P_db_55;

% the matrix containing power values over that grid : P (dim = gxgxN)
P = cat(3,p1,p2,p3,p4,p5);

%% create L
n = 10; % number of values over which error is averaged 
xy = randi(g,n,2); % from gxg grid sample n points 
% Obtain RSSI corresponding to each of the BSs for points in xy
for ii = 1:n
    L(ii,:) = P(xy(ii,1),xy(ii,1),:);
end

%% path loss model initializations
gamma = 3; % path loss exponent 
d_0 = 1; % reference distance in m = 1
L_0 = 40; % path loss at d_0 = 40 dB

% obtain the beta_i
for ii = 1:n
    beta(ii,:) = d_0 * 10.^((L(ii,:)-L_0)/(10*gamma));
end

%% perform optimization for one reading 
beta1 = beta(1,:);

%% sdp optimization using cvx
cvx_begin sdp
variable X(2,2) symmetric
variable theta(2)
variable t(5)
dual variable Q
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