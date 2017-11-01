%% Function for localization

function [theta_pred,x_pred] = sdp_localization(def,L_A,L_B,M,N,phi,loc_option,sdp_norm,rad,d_0,L_0,gamma_los)
% ARGUMENTS
% L_A = Received power at each of the M MSs(Mobile stations) from each of
%       the N BSs(Base Stations). It is a matrix of the form M*N
% L_B = Power gradient between MSs. It is M*(M-1)/2 length vector. The
%       power gradient to and fro between MSs is assumed same.
% phi contains the BS locations. It is a matrix of the form N*2.
% loc_option specifies which of the following optimization is to be performed
% loc_option = 1: Single point non-cooperative localization
% loc_option = 2: Multiple point non-cooperative localization     
% loc_option = 3: Cooperative localization without L_B
% loc_option = 4: Cooperative localization with L_B
% loc_option = 5: Cooperative localization with L_B clustered
%
% sdp_norm specifies the kind of norm to be used in the sdp
% sdp_norm = 1: L1 norm
% sdp_norm = 2: L2 norm
% sdp_norm = 3: infinity norm
% 
% rad = Radius of the circle centered at (0,0); default = 500
% d_0 = Reference distance in m ; default = 1
% L_0 = Received power at d_0 in dB; default = 40
% gamma_los = path loss exponent for los conditions; default = 3
% gamma_nlos = path loss exponent for nlos conditions; default = 4
% sigma_los = moise variance in los conditions; default = 1
% sigma_nlos = moise variance in los conditions; default = 4
% Before running the code, activate cvx_setup in the main cvx folder 

%% Default parameters
if strcmp(def,'true') % if we want to use the default parameters
M = 100;
N = 6;
rad = 500;
d_0 = 1;
L_0 = 40;
gamma_los = 3;
gamma_nlos = 4;
sigma_los = 1;
sigma_nlos = 4;
end

theta_pred = 0;
x_pred = 0;
j = 0;
%% Single point non-cooperative localization
if loc_option == 1 
% calculate k; k_i = norm(phi_i)^2   
for i = 1:N
k(i) = norm(phi(i,:),2)^2;
end

% obtain the beta_i
beta1 = d_0 * 10.^((L_A(j,:)-L_0)/(10*gamma));

% sdp optimization using cvx
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
[trace(X) - 2*(phi(i,:))*theta + k(i),beta1(i); beta1(i),t(i)] >= 0; % LMI
end
t >= 0;
[X,theta ; theta',1] >= 0 ;
cvx_end
theta_pred(j,:) = theta;
end

%% Multiple point non-cooperative localization 
if loc_option == 2
% calculate k; k_i = norm(phi_i)^2   
for i = 1:N
k(i) = norm(phi(i,:),2)^2;
end

for a = 1:M
% obtain the beta_i
beta1 = d_0 * 10.^((L_A(a,:)-L_0)/(10*gamma_los));

% sdp optimization using cvx
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
[trace(X) - 2*(phi(i,:))*theta + k(i),beta1(i); beta1(i),t(i)] >= 0; %LMI
end
t >= 0;
[X,theta ; theta',1] >= 0 ;
cvx_end
theta_pred_1(a,:) = theta;
end 
theta_pred = theta_pred_1;
end

%% Cooperative localization without L_B
if loc_option == 3
% get g and h
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

% get beta and zeta 
for i = 1:M
    beta(i,:) = d_0 * 10.^((L_A(i,:)-L_0)/(10*gamma_los));
end
zeta = d_0 * 10.^((L_B-L_0)/(10*gamma_los));

% sdp optimization using cvx
% Z = [X theta'; theta eye(2,2)]
% t_tij = [11 12 13...1N 21 22 23...2N M1 M2 M3...MN];
% t_sij = [12 13..1M 23 24..2M 34 35..3M (M-1)M];
% total number of elements in ts = M*N + M*(M-1)/2; 
m = 2;
n = M*N ; 

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

% idx = N*(i-1)+j;
% k = 1;
% p = 1;
% for i = 1:M-1,
%     for j = (i+1):M
%         hh = reshape(h(i,j,:),[M+2,1]);
%         hh'*Z*hh <= (zeta(p)^2)*ts(idx+k);
%         [hh'*Z*hh zeta(p);zeta(p) ts(idx+k)] >= 0;
%         p = p+1;
%         k = k+1;
%     end
% end
Z >= 0;
Z(M+1:M+2,M+1:M+2) == eye(2);
cvx_end

theta_pred = Z(M+1:M+2,1:M)';
x_pred = Z(1:M,1:M) ;  
end

%% Cooperative localization with L_B
if loc_option == 4
% get g and h
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

% get beta and zeta 
for i = 1:M
    beta(i,:) = d_0 * 10.^((L_A(i,:)-L_0)/(10*gamma));
end
zeta = d_0 * 10.^((L_B-L_0)/(10*gamma));

% sdp optimization using cvx
% Z = [X theta'; theta eye(2,2)]
% t_tij = [11 12 13...1N 21 22 23...2N M1 M2 M3...MN];
% t_sij = [12 13..1M 23 24..2M 34 35..3M (M-1)M];
% total number of elements in ts = M*N + M*(M-1)/2; 
m = 2;
n = M*N + length(L_B); %M*(M-1)/2; 

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
end

end