%% Analysis
%theta_pred = theta_pred';
% theta_pred_1 = theta_pred(:,1)+4;
% theta_pred_1 = [theta_pred_1 theta_pred(:,2)];
scatter(theta_org(:,1),theta_org(:,2),'filled')
hold on
scatter(theta_pred(:,1),theta_pred(:,2),'filled')
xlim([-800 800])
ylim([-800 800])

%% ouput covariance matrix 
cov_theta = X - theta_pred*theta_pred';

%% Mean squared error
% For a single MS
mse = sqrt((theta_org - theta_pred)*(theta_org - theta_pred)'); 

%% True function value at \theta
% Which of the obectives should I use to calculate the function value ?
% Eqn. 3 : The original ML Estimator 
% Eqn. 11 : The modified estimator without the log term. 
% The function value should be as small as possible ! 
% Shouldn't there be one to one correspondence between the function value
% and the MSE. There is. But, how much of change in function value amounts
% to how much of change in MSE ? 

ff = myfunc(theta_org);
ff1 = ff.^2;
ff2 = sum(ff(:)); % This is the original objective !

gg = myfunc(theta_pred);
gg1 = gg.^2;
gg2 = sum(gg(:));

