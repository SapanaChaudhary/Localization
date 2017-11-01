%% iterative master script 

cooperative_data_gen_los;
sdp_3_cooperative;

%% do this procedure iteratively till the time you get less error on P

%% with the predicted theta, generate L_B

% create L_B from the estimated theta 
% Get L_B : L for set B : It is a vector
% obtain RSS at BN from NLOS BS
theta_pred = theta_pred';
sigma = 1;
k = 1;
for j = 1:M % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma,M);
    for i = (j+1):M
        L_B(k) = L_0 + 10*gamma*log10(norm(theta_pred(j,:)-theta_pred(i,:),2)/d_0) + m(i);
        k = k+1;
    end
end

save('L_B','L_B');

%% run sdp again

theta_pred_1 = sdp_3_coop(L_A,L_B,phi,M);
theta_pred_1 = theta_pred_1';

%% evaluation 
load theta_org;

err_mse_1 = sqrt(sum((theta_org(:,1) - theta_pred(:,1)).^2 + (theta_org(:,1) - theta_pred(:,1)).^2)/M);
err_mse_2 = sqrt(sum((theta_org(:,1) - theta_pred_1(:,1)).^2 + (theta_org(:,1) - theta_pred_1(:,1)).^2)/M);

%% with the predicted theta, generate L_B

% create L_B from the estimated theta 
% Get L_B : L for set B : It is a vector
% obtain RSS at BN from NLOS BS
sigma = 1;
k = 1;
for j = 1:M % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma,M);
    for i = (j+1):M
        L_B(k) = L_0 + 10*gamma*log10(norm(theta_pred_1(j,:)-theta_pred_1(i,:),2)/d_0) + m(i);
        k = k+1;
    end
end

save('L_B','L_B');

%% run sdp again

theta_pred_2 = sdp_3_coop(L_A,L_B,phi,M);
theta_pred_2 = theta_pred_2';

%% evaluation 
load theta_org;

err_mse_1 = sqrt(sum((theta_org(:,1) - theta_pred_2(:,1)).^2 + (theta_org(:,1) - theta_pred_2(:,1)).^2)/M);
