%% master script
clear all
close all

mkdir output; % directory to store all the outputs
% write the necessary outputs in a file : excel or text 

NN = [3,4,5,6]; % # of BSs
MM = [30,50,70,100]; % # of MSs
rad = 500; % Diameter between 2 BSs 
d_0 = 1; % reference distance
L_0 = 40; % Received power at regeference BS
gamma_los_main = [1,2,3,4]; % path loss exponent for los conditions
gamma_nlos_main = [4,5]; % path loss exponent for nlos conditions
sigma_los_main = [1,2,3,4]; % noise variance in los conditions
sigma_nlos_main = [4,5]; % noise variance in nlos conditions

lam_1_main = [3,4,5,6,7]; % density of obstacles 
p_main = [0.00008, 0.0001]; % make density sparse

gen_option_main = [1,2]; % different data generation options
los_bs_1 = [1,5];
loc_option_main = [2,3];
sdp_norm = 1;
%% Non Obstacle LOS data
% loc_data_gen(def,gen_option,los_bs,nlos_bs,rad,M,N,d_0,L_0,gamma_los,sigma_los,gamma_nlos,sigma_nlos,lam_1,p)
fname = sprintf('f%i.txt', 1);
for ii = NN
    for jj = MM
        for kk = gamma_los_main
            for ll = sigma_los_main
                for bb = gen_option_main
                    for cc = loc_option_main
                    [phi_main,theta_org,L_A_main,L_B_main] = loc_data_gen('false',bb,0,0,rad,jj,ii,d_0,L_0,kk,ll,0,0,0,0);
                    [theta_pred,x_pred] = sdp_localization('false',L_A_main,L_B_main,jj,ii,phi_main,cc,sdp_norm,rad,d_0,L_0,kk);
                    % Measure mse in the data 
                    err_mse = sqrt(sum((theta_org(:,1) - theta_pred(:,1)).^2 + (theta_org(:,1) - theta_pred(:,1)).^2)/jj);
         
                    fid = fopen(fname,'a+');
                    fprintf(fid,'**** LOG FILE **** \n');
                    fprintf(fid, 'N: %i \n', ii);
                    fprintf(fid, 'M: %i \n', jj);
                    fprintf(fid, 'LOS gamma: %i \n', kk);
                    fprintf(fid, 'LOS sigma: %i \n', ll);
                    fprintf(fid, 'Data generation Option: %i \n', bb);
                    fprintf(fid, 'Localization Option: %i \n', cc);
                    fprintf(fid, 'MSE: %i \n', err_mse);
                    fclose(fid);
                    end
                end
            end
        end
    end
end
