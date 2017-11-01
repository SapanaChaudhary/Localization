%% perform clustering on obstacle data 
%% k means clustering
load('L_A')
load('theta_org')
load('phi')
no_of_clusters = 100;
idx = kmeans(L_A,no_of_clusters);

%% sort
theta_1 = [idx theta_org];
theta_1_sort = sortrows(theta_1,1);
save('theta_1','theta_1');
save('theta_1_sort','theta_1_sort');

%% make plots : original data
figure()
scatter(phi(:,1),phi(:,2),'filled');
hold on 
scatter(theta_org(:,1),theta_org(:,2),'g');
figure('Name','Original data')

%% clustered data
figure()
% get the index counts
for k = 1:no_of_clusters
    idx_count(k) = sum(theta_1_sort(:,1)== k);
end

save('idx_count','idx_count');
idx_count = [idx_count 0];

a = 1;
b = idx_count(1);
for i = 1:no_of_clusters
    theta_2 = [];
    theta_2 = theta_1_sort(a:b,2:3);
    a = b+1;
    b = b + idx_count(i+1);
    figure()
    scatter(theta_2(:,1),theta_2(:,2),'filled');
    hold on
    xlim([-500,500])
    ylim([-500,500])
end

figure()
a = 1;
b = idx_count(1);
for i = 1:no_of_clusters
    theta_2 = [];
    theta_2 = theta_1_sort(a:b,2:3);
    a = b+1;
    b = b + idx_count(i+1);
    scatter(theta_2(:,1),theta_2(:,2),'filled');
    hold on
end