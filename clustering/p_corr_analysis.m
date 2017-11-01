%% analysis of the correlation of P within a cluster 

d1 = L_A(1:12,:);

k = 1;
for i = 1: 11
    for j = i+1:12  
    z(k) = corr(L_A(i,:)',L_A(j,:)');%,'type','Kendall');
    k = k+1;
    end
end

%% locations 

loc = [theta_1(:,1) theta_org];
loc = sortrows(loc,1);

%% distance between points

k = 1;
for i = 1: 11
    for j = i+1:12  
    dis(k) = pdist([loc(i,:);loc(j,:)],'euclidean');
    k = k+1;
    end
end

%% concatenate z and dis

v = [dis' z'];
v1 = sortrows(v(1:12,:),1);

%% find rank correlation 

pp1 = L_A(1:12,:);

for i = 1:12
    [~, ~, ranking] = unique(pp1(i,:));
    rn(i,:) = ranking';    
end

k = 1;
for i = 1: 11
    for j = i+1:12  
    u(k) = corr(rn(i,:)',rn(j,:)'); %,'type','Kendall');
    k = k+1;
    end
end

v2 = [u' v];


%% some more analysis

qw = [v2(:,3) v2(:,2)];

qw1 = [v2(:,1) v2(:,2)];

qw2 = [v2(:,1) v2(:,3)];


%% 
% find unique ranks
qw22 = sortrows(qw2,1);
u1 = unique(u);

for i = u1
    
    
end

a = [1:1:12]';
d2 = [a d1];



