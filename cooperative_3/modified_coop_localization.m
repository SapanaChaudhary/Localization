%% Modified semi-cooperative localization 
% 1. Generate data
% 2. Cluster data
% 3. Perform localization 

%clustered_data_gen;

%% sort L_A according to the clusters
L_A = [theta_1(:,1) L_A];
L_A = sortrows(L_A,1);
L_A = L_A(:,2:7);

%% plot the original data

%% perform localization 
m = 2;
n = 0;
for i = idx_count
    n = n + i*(i-1)/2;
end

cvx_begin sdp quiet
variable Z(M+2,M+2) 
variable ts(n)
minimize(norm(ts,1))
subject to
for i = 1:M,
    for j = 1:N
        gg = reshape(g(i,j,:),[M+2,1]);
        gg'*Z*gg <= (my_beta(i,j)^2)*ts(N*(i-1)+j);
        [gg'*Z*gg my_beta(i,j);my_beta(i,j) ts(N*(i-1)+j)] >= 0;
    end
end

for i = idx_count
    c = i*(i-1)/2;
    idx = M*N;
    
    
k = 1;
p = 1;
    for i = 1:M-1,
        for j = (i+1):M
            hh = reshape(h(i,j,:),[M+2,1]);
            hh'*Z*hh <= (my_zeta(p)^2)*ts(idx+k);
            [hh'*Z*hh my_zeta(p);my_zeta(p) ts(idx+k)] >= 0;
            p = p+1;
            k = k+1;
        end
    end
end

Z >= 0;
Z(M+1:M+2,M+1:M+2) == eye(2);
cvx_end






