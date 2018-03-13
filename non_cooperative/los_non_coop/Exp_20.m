%% Experiment on analysis of results obtained from different 
% optimization agorithms for different locations
% Locations are : [-105,184], [0,650], [0,800], [0,0], [250,0]

%% Loc #1
clear all; close all;
theta_org = [-105,184];
L_A = los_n_cop_data_gen([-105,184]);
save('L_A','L_A');
los_n_cop_loc;
output_analysis_1;
different_optimization;

%% Loc #2
clear all; close all;
theta_org = [0,650];
L_A = los_n_cop_data_gen([0,650]);
save('L_A','L_A');
los_n_cop_loc;
output_analysis_1;
different_optimization;

%% Loc #3
clear all; close all;
theta_org = [0,800];
L_A = los_n_cop_data_gen([0,800]);
save('L_A','L_A');
los_n_cop_loc;
output_analysis_1;
different_optimization;

%% Loc #4
clear all; close all;
theta_org = [0,0];
L_A = los_n_cop_data_gen([0,0]);
save('L_A','L_A');
los_n_cop_loc;
output_analysis_1;
different_optimization;

%% Loc #5
clear all; close all;
theta_org = [250,0];
L_A = los_n_cop_data_gen([250,0]);
save('L_A','L_A');
los_n_cop_loc;
output_analysis_1;
different_optimization;










