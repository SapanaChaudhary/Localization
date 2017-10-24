%% cooperative SDP localization

% SDP estimator 3 : SDP_RSS for the data given in the paper
% different norms cab be used 
% ML estimator can be solved by the MATLAB function lsqnonlin
%clc
%function [theta_pred] = sdp_3_nlos(L,phi,M)
N = 6; % No. of RNs
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma = 3; % path loss exponent

% for i = 1:N
% k(i) = norm(phi(i,:),2);
% end
load L_A
load L_B
%% obtain the beta_i
%beta1 = d_0 * 10.^((L(j,:)-L_0)/(10*gamma));

%%
M = 50;
rad = 500;
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end

phi = [a;b]';

%% get g and h
for i = 1:M % (i,j) belong to the set A
    for j = 1:N
    g(i,j,:) = [full(sparse(1,i,1,1,M)) -phi(j,:)];
    end
end

for i = 1:M % (i,k) belong to the set A
    for k = (i+1):M
    h(i,k,:) = [full(sparse(1,i,1,1,M))-full(sparse(1,k,1,1,M)) 0 0];
    end
end

%% get beta and zeta 
for i = 1:M
    beta(i,:) = d_0 * 10.^((L_A(i,:)-L_0)/(10*gamma));
end

% vectorize beta
%beta_1 = beta';
%beta = beta_1(:);
%mod_C = M*M - M/2; % size of set C
%for j = 1:mod_C 
zeta = d_0 * 10.^((L_B-L_0)/(10*gamma));
%end
%% sdp optimization using cvx
% Z = [X theta'; theta eye(2,2)]
% t_tij = [11 12 13...1N 21 22 23...2N M1 M2 M3...MN];
% t_sij = [12 13..1M 23 24..2M 34 35..3M (M-1)M];
% total number of elements in t = M*N + M*(M-1)/2; 
m = 2;
n = M*N + M*(M-1)/2; 

cvx_begin sdp quiet
variable Z(M+2,M+2) 
variable ts(n)
minimize(norm(ts,1))
subject to
for i = 1:M,
    for j = 1:N
        gg = reshape(g(i,j,:),[M+2,1]);
        gg'*Z*gg <= (beta(i,j)^2)*ts(N*(i-1)+j);
        [gg'*Z*gg beta(i,j);beta(i,j) ts(N*(i-1)+j)] >= 0;
    end
end

idx = N*(i-1)+j;
k = 1;
p = 1;
for i = 1:M-1,
    for j = (i+1):M
        hh = reshape(h(i,j,:),[M+2,1]);
        hh'*Z*hh <= (zeta(p)^2)*ts(idx+k);
        [hh'*Z*hh zeta(p);zeta(p) ts(idx+k)] >= 0;
        p = p+1;
        k = k+1;
    end
end
Z >= 0;
Z(M+1:M+2,M+1:M+2) == eye(2);
cvx_end

theta_pred = Z(M+1:M+2,1:M);
x_pred = Z(1:M,1:M) ;

% %% error
% for i = 1:M
% err(i) = (theta_pred(i,1)-theta_org(1))^2 + (theta_pred(i,2)-theta_org(2))^2;
% end
% %% RMSE
% rmse = sqrt(sum(err)/M);

load('theta_org');

err = theta_org' - theta_pred ;










