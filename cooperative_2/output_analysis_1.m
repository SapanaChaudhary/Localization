%% Analysis
%theta_pred = theta_pred';
% theta_pred_1 = theta_pred(:,1)+4;
% theta_pred_1 = [theta_pred_1 theta_pred(:,2)];
scatter(theta_org(:,1),theta_org(:,2),'filled')
hold on
scatter(theta_pred(:,1),theta_pred(:,2),'filled')

%% Measure mse in the data 
err_mse = sqrt(sum((theta_org(:,1) - theta_pred(:,1)).^2 + (theta_org(:,1) - theta_pred(:,1)).^2)/M);

%% ensemble variance of each theta_i 
en_var = Z(1,1) - theta_pred*theta_pred';

%% True function value at \theta
% Which of the obectives should I use to calculate the function value ?
% Eqn. 3 : The original ML Estimator 
% Eqn. 11 : The modified estimator without the log term. 



