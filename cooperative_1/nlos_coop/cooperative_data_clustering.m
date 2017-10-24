%% cooperative data clustering
% k means clustering
no_of_clusters = 10;
idx = kmeans(L_A,no_of_clusters);

%% sort
theta_1 = [idx theta_org];
theta_1 = sortrows(theta_1,1);

%% make plots : original data
figure(1)
scatter(phi(:,1),phi(:,2),'filled');
hold on 
scatter(theta_org(:,1),theta_org(:,2),'g');
figure('Name','Original data')

%% clustered data
figure(2)
% get the index counts
for k = 1:no_of_clusters
    idx_count(k) = sum(theta_1(:,1)==k);
end

idx_count = [idx_count 0];

a = 1;
b = idx_count(1);
for i = 1:no_of_clusters
    theta_2 = [];
    theta_2 = theta_1(a:b,2:3);
    a = b+1;
    b = b + idx_count(i+1);
    scatter(theta_2(:,1),theta_2(:,2),'filled');
    hold on
end



