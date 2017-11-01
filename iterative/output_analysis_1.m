%% Analysis
cooperative_data_gen_los; sdp_3_cooperative;
theta_pred = theta_pred';
% theta_pred_1 = theta_pred(:,1)+4;
% theta_pred_1 = [theta_pred_1 theta_pred(:,2)];
scatter(theta_org(:,1),theta_org(:,2),'filled')
hold on
scatter(theta_pred(:,1),theta_pred(:,2),'filled')

%% Measure mse in the data 
err_mse = sqrt(sum((theta_org(:,1) - theta_pred(:,1)).^2 + (theta_org(:,1) - theta_pred(:,1)).^2));