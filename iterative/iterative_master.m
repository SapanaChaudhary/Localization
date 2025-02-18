%% iterative master script 
clear all

cooperative_data_gen_los;
sdp_3_cooperative;
load theta_org;

theta_pred_1 = theta_pred';
err_mse_1 = sqrt(sum((theta_org(:,1) - theta_pred_1(:,1)).^2 + (theta_org(:,1) - theta_pred_1(:,1)).^2)/M);

%% do this procedure iteratively till the time you get less error on P
%% with the predicted theta, generate L_B
% Get L_B : L for set B : It is a vector

theta_pred_now = theta_pred_1;

for iii = 2:20   
sigma = 1;
k = 1;
for j = 1:M % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma,M);
    for i = (j+1):M
        L_B(k) = L_0 + 10*gamma*log10(norm(theta_pred_now(j,:)-theta_pred_now(i,:),2)/d_0) + m(i);
        k = k+1;
    end
end

% run sdp again
%theta_pred_now = sprintf('theta_pred_%i',iii);
theta_pred_now = sdp_3_coop(L_A,L_B,phi,M);
theta_pred_now = theta_pred_now';

% evaluation 
%genvarname('err_mse_',  num2str(iii));
err_mse_now = sqrt(sum((theta_org(:,1) - theta_pred_now(:,1)).^2 + (theta_org(:,1) - theta_pred_now(:,1)).^2)/M);
eval(['err_mse_' num2str(iii) '= err_mse_now'])
end

%err_mse_5 = sqrt(sum((theta_org(:,1) - theta_pred_5(:,1)).^2 + (theta_org(:,1) - theta_pred_5(:,1)).^2)/M);