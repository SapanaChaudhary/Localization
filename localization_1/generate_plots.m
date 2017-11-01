%% function to generate plots

function [g,h] = generate_plots(a)

% create new folders for outputs , use proper variable names
% for plotting obstacles

save('obst_1.mat','obst_1');
%% plot the points
figure()
scatter(obst_1(:,2),obst_1(:,3),'r');
hold on;

%% plot the line segments 
for i = 1:length(obst_1)
    plot([obst_1(i,2) obst_1(i,4)],[obst_1(i,3) obst_1(i,5)]);
    hold on;
end
% savefig('out.jpg');

save('theta_org','theta_org');
hold on;
scatter(theta_org(:,1),theta_org(:,2));

end