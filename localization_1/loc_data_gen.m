%% Function for data generation

function [phi,theta_org,L_A,L_B,den] = loc_data_gen(def,gen_option,los_bs,nlos_bs,rad,M,N,d_0,L_0,gamma_los,sigma_los,gamma_nlos,sigma_nlos,lam_1,p)
% INPUT ARGUMENTS
% gen_option specifies data generation options
% gen_option = 1: LOS data for multiple MSs without L_B
% gen_option = 2: LOS data for multiple MSs with L_B
% gen_option = 3: LOS+NLOS data for multiple MSs without L_B
% gen_option = 4: LOS+NLOS data for multiple MSs with L_B
% gen_option = 5: Obstacle data without L_B
% gen_option = 6: Obstacle data with L_B
%
% los_bs = BSs that give LOS readings; A a*1 vector with indices of LOS BSs
% nlos_bs = BSs that give NLOS readings; A b*1 vector with indices of NLOS BSs
% 
% rad = Radius of the circle centered at (0,0); default = 500
% d_0 = Reference distance in m ; default = 1
% L_0 = Received power at d_0 in dB; default = 40
% gamma_los = path loss exponent for los conditions; default = 3
% gamma_nlos = path loss exponent for nlos conditions; default = 4
% sigma_los = noise variance in los conditions; default = 1
% sigma_nlos = noise variance in nlos conditions; default = 4
%
% OUTPUTS
% phi = BS locations; N*2 matrix
% theta_org = MS locations; M*2 matrix
% L_A = RSSI at MSs from BSs; M*N matrix
% L_B = Power variation between MSs; M*(M-1)/2 vector
% den = NLOS error density

%% default initializations
if strcmp(def,'true') % if we want to use the default parameters
M = 100;
N = 6;
rad = 500;
d_0 = 1;
L_0 = 40;
gamma_los = 3;
gamma_nlos = 4;
sigma_los = 1;
sigma_nlos = 4;
end

den = 0;
L_B = 0;

%% LOS data for multiple MSs without L_B
if gen_option == 1
% get BS locations
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end
phi = [a;b]';

% Get MS locations
theta = randi(rad*2,M,2); % from gxg grid sample n points 
theta_org = theta - repmat([rad rad],M,1);

% Get L_A 
% obtain RSS at BN from LOS BS
for j = 1:M % for all the points
    m = mvnrnd(0,sigma_los,N); % i.i.d gaussian noise 
    k = 1;
    for i = 1:N % from all the LOS BSs
        L_A(j,i) = L_0 + 10*gamma_los*log10(norm(theta_org(j,:)-phi(i,:),2)/d_0) + m(k);
        k = k+1;
    end
end
end

%% LOS data for multiple MSs with L_B
if gen_option == 2
% get BS locations
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end
phi = [a;b]';

% Get MS locations
theta = randi(rad*2,M,2); % from gxg grid sample n points 
theta_org = theta - repmat([rad rad],M,1);

% Get L_A 
% obtain RSS at BN from LOS BS
for j = 1:M % for all the points
    m = mvnrnd(0,sigma_los,N); % i.i.d gaussian noise 
    k = 1;
    for i = 1:N % from all the LOS BSs
        L_A(j,i) = L_0 + 10*gamma_los*log10(norm(theta_org(j,:)-phi(i,:),2)/d_0) + m(k);
        k = k+1;
    end
end

% Get L_B 
% obtain RSS at BN from NLOS BS
k = 1;
for j = 1:M % for all the points
    m = mvnrnd(0,sigma_los,M); % i.i.d gaussian noise 
    for i = (j+1):M
        L_B(k) = L_0 + 10*gamma_los*log10(norm(theta_org(j,:)-theta_org(i,:),2)/d_0) + m(i);
        k = k+1;
    end
end
end

%% LOS+NLOS data for multiple MSs without L_B
if gen_option == 3
% get BS locations
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end
phi = [a;b]';

% Get MS locations
theta = randi(rad*2,M,2); % from gxg grid sample n points 
theta_org = theta - repmat([rad rad],M,1);

% Get L_A 
% obtain RSS at BN from LOS BS
for j = 1:M % for all the points
    m = mvnrnd(0,sigma_los,N); % i.i.d gaussian noise 
    k = 1;
    for i = los_bs % from all the LOS BSs
        L_A(j,i) = L_0 + 10*gamma_los*log10(norm(theta_org(j,:)-phi(i,:),2)/d_0) + m(k);
        k = k+1;
    end
end  

% obtain RSS at BN from LOS BS
for j = 1:M % for all the points
    m = mvnrnd(0,sigma_nlos,N); % i.i.d gaussian noise 
    k = 1;
    for i = nlos_bs % from all the LOS BSs
        L_A(j,i) = L_0 + 10*gamma_nlos*log10(norm(theta_org(j,:)-phi(i,:),2)/d_0) + m(k);
        k = k+1;
    end
end  
end

%% LOS+NLOS data for multiple MSs with L_B
if gen_option == 4
% get BS locations
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end
phi = [a;b]';

% Get MS locations
theta = randi(rad*2,M,2); % from gxg grid sample n points 
theta_org = theta - repmat([rad rad],M,1);

% Get L_A 
% obtain RSS at BN from LOS BS
for j = 1:M % for all the points
    m = mvnrnd(0,sigma_los,N); % i.i.d gaussian noise 
    k = 1;
    for i = los_bs % from all the LOS BSs
        L_A(j,i) = L_0 + 10*gamma_los*log10(norm(theta_org(j,:)-phi(i,:),2)/d_0) + m(k);
        k = k+1;
    end
end  

% obtain RSS at MS from LOS BS
for j = 1:M % for all the points
    m = mvnrnd(0,sigma_nlos,N); % i.i.d gaussian noise 
    k = 1;
    for i = nlos_bs % from all the LOS BSs
        L_A(j,i) = L_0 + 10*gamma_nlos*log10(norm(theta_org(j,:)-phi(i,:),2)/d_0) + m(k);
        k = k+1;
    end
end  

% Get L_B 
% obtain RSS at MS from NLOS BS
k = 1;
for j = 1:M % for all the points
    m = mvnrnd(0,sigma_los,M); % i.i.d gaussian noise 
    for i = (j+1):M
        L_B(k) = L_0 + 10*gamma_los*log10(norm(theta_org(j,:)-theta_org(i,:),2)/d_0) + m(i);
        k = k+1;
    end
end
end

%% Obstacle data for multiple MSs 
if gen_option == 5
% generate data according to poisson obstacle 
% Use poisson rv to generate BNs
lam_1 = 3; %density of obstacles 
rad_2 = 2*rad;
obst = poissrnd(2, [rad_2 rad_2]);
spar_den_1 = nnz(obst)/(rad_2*rad_2);

% make the obstacle density more sparse
p = 0.00008; % for rad = 20m 0.0001; % for rad = 500m 
for i = 1:rad_2
    for j = 1:rad_2
        s1 = binornd(1,p); % with p=0.3 it returns 1
        obst(i,j) = obst(i,j)*s1;
    end
end

spar_den_2 = nnz(obst)/(rad_2*rad_2);

% draw lines through the points 
% get the end points of the line segment through the points
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
%% generate MSs
theta = randi(rad*2,M,2); % from gxg grid sample n points 
theta_org = theta - repmat([rad rad],M,1);

%% generate RNs
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end
phi = [a;b]';

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
den = nnz(los_or_not)/(M*N); % NLOS density  
end

%% Obstacle data for multiple MSs 
if gen_option == 5
% generate data according to poisson obstacle 
% Use poisson rv to generate BNs
lam_1 = 3; %density of obstacles 
rad_2 = 2*rad;
obst = poissrnd(2, [rad_2 rad_2]);
spar_den_1 = nnz(obst)/(rad_2*rad_2);

% make the obstacle density more sparse
p = 0.00008; % for rad = 20m 0.0001; % for rad = 500m 
for i = 1:rad_2
    for j = 1:rad_2
        s1 = binornd(1,p); % with p=0.3 it returns 1
        obst(i,j) = obst(i,j)*s1;
    end
end

spar_den_2 = nnz(obst)/(rad_2*rad_2);

% draw lines through the points 
% get the end points of the line segment through the points
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
%% generate MSs
theta = randi(rad*2,M,2); % from gxg grid sample n points 
theta_org = theta - repmat([rad rad],M,1);

%% generate RNs
for i = 1:N
   a(i) = rad*cos(2*pi*(i-1)/N);
   b(i) = rad*sin(2*pi*(i-1)/N);
end
phi = [a;b]';

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
den = nnz(los_or_not)/(M*N); % NLOS density

% create L_B
k = 1;
for j = 1:M % for all the points
    % i.i.d gaussian noise 
    m = mvnrnd(0,sigma_los,M);
    for i = (j+1):M
        L_B(k) = L_0 + 10*gamma_los*log10(norm(theta_org(j,:)-theta_org(i,:),2)/d_0) + m(i);
        k = k+1;
    end
end   
end

end