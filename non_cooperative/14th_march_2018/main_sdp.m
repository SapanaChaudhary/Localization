%% main function for start point as (0,0) testing 
% Different type of input data 
% Different algos 
% Different number of BSs
% Different topology of BSs

%% get the input data : generate large number of MSs

% Create and save the input 
data_gen_option = 1;

% standard parameters
M = [20,200,500,750];
N = 3;
rad = 500;
d_0 = 1;
L_0 = 40;
gamma_los = 3;
gamma_nlos = 4;
sigma_los = 1;
sigma_nlos = 4;
los_bs = [1,2,3,4,5,6];
def = 'false';

% parameters for obstacle data 
lam_1 = 3; %density of obstacles 
p = 0.0008; % to make obstacle density more sparse 

gg = 1;
for qq = M
for ss = 1:3

% Call the data generating function 
[phi,theta_org,L_A,L_B,den] = loc_data_gen(def,data_gen_option,los_bs,[],rad,qq,N,d_0,L_0,gamma_los,sigma_los,gamma_nlos,sigma_nlos,lam_1,p);

save('L_A','L_A');
save('phi','phi');

%% run localization algo, time using tic-toc, for [0,0] start state 
theta_0 = [0,0];

kk = 1;
save('kk','kk');
for ii = 1:qq
    %theta_0 = randi(rad*2,1,2);
    %theta_0 = theta_0 - repmat([rad rad],1,1);
    [algo_time(ii), itrs(ii), mse_err(ii)] = los_n_cop_loc(theta_org(ii,:),theta_0);
    kk = kk+1;
    save('kk','kk');
end

mean_time(gg,ss) = mean(algo_time);
mean_itrs(gg,ss) = mean(itrs);
mean_mse_err(gg,ss) = mean(mse_err);

%% run localization algo, time using tic-toc, for random start state 
kk = 1;
save('kk','kk');
for ii = 1:qq
    theta_0 = randi(rad*2,1,2);
    theta_0 = theta_0 - repmat([rad rad],1,1);
    [algo_time_rnd(ii), itrs_rnd(ii), mse_err_rnd(ii)] = sdp_3_cooperative(theta_org(ii,:),theta_0);
    kk = kk+1;
    save('kk','kk');
end

mean_time_rnd(gg,ss) = mean(algo_time_rnd);
mean_itrs_rnd(gg,ss) = mean(itrs_rnd);
mean_mse_err_rnd(gg,ss) = mean(mse_err_rnd);

end

gg = gg + 1;
end


%% error plot 

xx = M;
% Figure for mean time 
yy_1 = mean(mean_time,2);
ee_1 = std(mean_time,1,2);
yy_rnd_1 = mean(mean_time_rnd,2);
ee_rnd_1 = std(mean_time_rnd,1,2);
figure()
errorbar(xx,yy_1,ee_1,'rx');

lo_1 = yy_1 - ee_1;
hi_1 = yy_1 + ee_1;

hp_1 = patch([xx'; xx(end:-1:1)'; xx(1)], [lo_1; hi_1(end:-1:1); lo_1(1)], 'r');
hold on;
hl_1 = line(xx,yy_1);

set(hp_1, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
set(hl_1, 'color', 'r', 'marker', 'x');

hold on
errorbar(xx,yy_rnd_1,ee_rnd_1,'bx');

lo_rnd_1 = yy_rnd_1 - ee_rnd_1;
hi_rnd_1 = yy_rnd_1 + ee_rnd_1;

hp_rnd_1 = patch([xx'; xx(end:-1:1)'; xx(1)], [lo_rnd_1; hi_rnd_1(end:-1:1); lo_rnd_1(1)], 'r');
hold on;
hl_rnd_1 = line(xx,yy_rnd_1);

set(hp_rnd_1, 'facecolor', [0.8 0.8 1], 'edgecolor', 'none');
set(hl_rnd_1, 'color', 'b', 'marker', 'x');

%% Figure for mean No. of iterations
yy_2 = mean(mean_itrs,2);
ee_2 = std(mean_itrs,1,2);
yy_rnd_2 = mean(mean_itrs_rnd,2);
ee_rnd_2 = std(mean_itrs_rnd,1,2);
figure()
errorbar(xx,yy_2,ee_2,'rx');

lo_2 = yy_2 - ee_2;
hi_2 = yy_2 + ee_2;

hp_2 = patch([xx'; xx(end:-1:1)'; xx(1)], [lo_2; hi_2(end:-1:1); lo_2(1)], 'r');
hold on;
hl_2 = line(xx,yy_2);

set(hp_2, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
set(hl_2, 'color', 'r', 'marker', 'x');

hold on
errorbar(xx,yy_rnd_2,ee_rnd_2,'bx');

lo_rnd_2 = yy_rnd_2 - ee_rnd_2;
hi_rnd_2 = yy_rnd_2 + ee_rnd_2;

hp_rnd_2 = patch([xx'; xx(end:-1:1)'; xx(1)], [lo_rnd_2; hi_rnd_2(end:-1:1); lo_rnd_2(1)], 'r');
hold on;
hl_rnd_2 = line(xx,yy_rnd_2);

set(hp_rnd_2, 'facecolor', [0.8 0.8 1], 'edgecolor', 'none');
set(hl_rnd_2, 'color', 'b', 'marker', 'x');

%% Figure for MSE
yy_3 = mean(mean_mse_err,2);
ee_3 = std(mean_mse_err,1,2);
yy_rnd_3 = mean(mean_mse_err_rnd,2);
ee_rnd_3 = std(mean_mse_err_rnd,1,2);
figure()
errorbar(xx,yy_3,ee_3,'rx');

lo_3 = yy_3 - ee_3;
hi_3 = yy_3 + ee_3;

hp_3 = patch([xx'; xx(end:-1:1)'; xx(1)], [lo_3; hi_3(end:-1:1); lo_3(1)], 'r');
hold on;
hl_3 = line(xx,yy_3);

set(hp_3, 'facecolor', [1 0.8 0.8], 'edgecolor', 'none');
set(hl_3, 'color', 'r', 'marker', 'x');

hold on
errorbar(xx,yy_rnd_2,ee_rnd_2,'bx');

lo_rnd_3 = yy_rnd_3 - ee_rnd_3;
hi_rnd_3 = yy_rnd_3 + ee_rnd_3;

hp_rnd_3 = patch([xx'; xx(end:-1:1)'; xx(1)], [lo_rnd_3; hi_rnd_3(end:-1:1); lo_rnd_3(1)], 'r');
hold on;
hl_rnd_3 = line(xx,yy_rnd_3);

set(hp_rnd_3, 'facecolor', [0.8 0.8 1], 'edgecolor', 'none');
set(hl_rnd_3, 'color', 'b', 'marker', 'x');



