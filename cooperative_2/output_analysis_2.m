%% Analysis
theta_pred_2 = theta_pred';
% theta_pred_1 = theta_pred(:,1)+4;
% theta_pred_1 = [theta_pred_1 theta_pred(:,2)];
%scatter(theta_org(:,1),theta_org(:,2),'filled')
hold on
scatter(theta_pred_2(:,1),theta_pred_2(:,2),'filled')
xlim([-800 800])
ylim([-800 800])

%% Measure mse in the data 
err_mse = sqrt(sum((theta_org(:,1) - theta_pred(:,1)).^2 + (theta_org(:,1) - theta_pred(:,1)).^2)/M);