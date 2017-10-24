%% generate data according to poisson obstacle 
clear all
close all

%% initializations
rad = 500; % radius of the circle centered at (0,0)
N = 6; % No. of RNs
d_0 = 1; % reference distance in m
L_0 = 40; % received power at d_0
gamma_los = 3; % path loss exponent
sigma_los = 1; % noise variance
M = 50;

%% NLOS parameters
gamma_nlos = 4;
sigma_nlos = 3;

%% Use poisson rv to generate BNs
lam_1 = 5; %density of obstacles 
rad_2 = 2*rad;
obst = poissrnd(2, [rad_2 rad_2]);
spar_den_1 = nnz(obst)/(rad_2*rad_2);

%% make the obstacle density more sparse
p = 0.0001; % for rad = 20m 0.0001; % for rad = 500m 
for i = 1:rad_2
    for j = 1:rad_2
        s1 = binornd(1,p); % with p=0.3 it returns 1
        obst(i,j) = obst(i,j)*s1;
    end
end

spar_den_2 = nnz(obst)/(rad_2*rad_2);

% draw lines through the points 

%% get the end points of the line segment through the points
k = 1;
for i = 1:rad_2
    for j = 1:rad_2
        if (obst(i,j)~=0)
            l = 10*rand(1,1); %random length of the obstacles in m
            ang = 2*pi*rand(1,1)-pi; %random angle
            obst_1(k,1) = ang;
            obst_1(k,2:3) = [i j] - [rad rad]; % first end point
            obst_1(k,4:5) = [i j] - [rad rad] + l.*[cos(ang) sin(ang)]; % second end point
            k = k+1;
        end
    end
end

save('obst_1','obst_1');
%% plot the points
figure()
scatter(obst_1(:,2),obst_1(:,3),'r');
hold on;

%% plot the line segments 
for i = 1:length(obst_1)
    plot([obst_1(i,2) obst_1(i,4)],[obst_1(i,3) obst_1(i,5)]);
    hold on;
end
%savefig('out.jpg');
%% generate BNs
theta = randi(rad*2,M,2); % from gxg grid sample n points 
theta_org = theta - repmat([rad rad],M,1);
save('theta_org','theta_org');
hold on;
scatter(theta_org(:,1),theta_org(:,2));

%% generate RNs
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end
phi = [a;b]';
save('phi','phi');

%% determine if the line segments intersect or not and generate L accordingly
for i = 1:M
    for j = 1:N
        for k = 1:length(obst_1)
        insect = lineSegmentIntersect([theta_org(i,:) phi(j,:)],[obst_1(k,2:3) obst_1(k,4:5)]); 
        insect_1(k) = insect.intAdjacencyMatrix;
        end
        los_or_not(i,j) = sum(insect_1);
        if (los_or_not(i,j) == 1)
         % between theta_org(i,:) and phi(j,:), there is an obstacle
         % NLOS reading
         m = mvnrnd(0,sigma_nlos,1);
         L_A(i,j) = L_0 + 10*gamma_nlos*log10(norm(theta_org(i,:)-phi(j,:),2)/d_0) + m;
        else
         % No obstacle: LOS reading 
         m = mvnrnd(0,sigma_los,1);
         L_A(i,j) = L_0 + 10*gamma_los*log10(norm(theta_org(i,:)-phi(j,:),2)/d_0) + m;
        end    
    end
end

save('L_A','L_A');
nnz(los_or_not)
%% create L_B
k = 1;
for j = 1:M % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma_los,M);
    for i = (j+1):M
        L_B(k) = L_0 + 10*gamma_los*log10(norm(theta_org(j,:)-theta_org(i,:),2)/d_0) + m(i);
        k = k+1;
    end
end

save('L_B','L_B');








