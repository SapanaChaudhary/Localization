%% clustering master script
%clear all
%close all

load('phi','phi'); % load RN locations
% obtain cluster counts
load('idx_count')
no_clus = 10; % No. of clusters
% get corresponding locations for the cluster points 
load('theta_1')
load('theta_1_sort')
%% load and sort L_A according to the clusters
load('L_A')
L_A = [theta_1(:,1) L_A];
L_A = sortrows(L_A,1);
L_A = L_A(:,2:7);

%% get L_A and L_B for each of the clusters
L_0 = 40;
gamma = 3;
sigma = 1;
d_0 = 1;
k = 1;
rmse = [];

%% plot original data
scatter(phi(:,1),phi(:,2),'filled');
hold on 
scatter(theta_1_sort(:,2),theta_1_sort(:,3),'g');

idx_count_1 = [idx_count 0];

a = 1;
b = idx_count_1(1);
%for i = 1:no_clus
    theta_2 = [];
    theta_2 = theta_1_sort(a:b,2:3);
    %a = b+1;
    %b = b + idx_count_1(i+1);
    scatter(theta_2(:,1),theta_2(:,2),'filled');
    hold on
%end

%% perform localization independently for each of the clusters
for i = idx_count
    % RN to BN RSS measurements
    L_A_1 = L_A(k:i,:);
    q = 1;
    % BN to BN RSS measurements
    for j = k:(k+i-1) % for all the points in the cluster
       m = mvnrnd(0,sigma,i);
       for p = (j+1):i
         L_B_1(q) = L_0 + 10*gamma*log10(norm(theta_1_sort(j,:)-theta_1_sort(p,:),2)/d_0) + m(i);  
         q = q+1;     
       end
    end
    theta_pred = sdp_coop_nlos(L_A_1,L_B_1,phi,i);
    theta_pred = theta_pred';
    for r = k:(k+i-1)
    err(r) = (theta_pred(r,1)-theta_1_sort(r,2))^2 + (theta_pred(r,2)-theta_1_sort(r,3))^2;
    end
    k = i+1;
    %% RMSE
    rmse = [rmse sqrt(sum(err)/i)];
    
    %% plot the localized points 
    scatter(theta_pred(:,1),theta_pred(:,2),'x');
    hold on
    
end






