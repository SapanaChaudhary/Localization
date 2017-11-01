%% Analysis
%theta_pred = theta_pred';
% theta_pred_1 = theta_pred(:,1)+4;
% theta_pred_1 = [theta_pred_1 theta_pred(:,2)];
scatter(theta_org(:,1),theta_org(:,2),'filled')
hold on
scatter(theta_pred(:,1),theta_pred(:,2),'filled')
xlim([-800 800])
ylim([-800 800])
