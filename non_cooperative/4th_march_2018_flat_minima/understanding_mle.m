%% 07.03.2018 
% Perform MLE on the orignal objective 
% Algorithm : Levenberg Marquardt 

%% Generate data 
function [] = understanding_mle() 
data_gen_option = 1;

% standard parameters
M = 1;
N = 6;
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

%% Call the data generating function 
[phi,theta_org,L_A,L_B,den] = loc_data_gen(def,data_gen_option,los_bs,[],rad,M,N,d_0,L_0,gamma_los,sigma_los,gamma_nlos,sigma_nlos,lam_1,p);

save('L_A','L_A');
save('phi','phi');

%% Plot the objective function
plot_obj_func();

%% Perform MLE on the generated data 
% lsqnonlin, Levenberg-Marquardt, original problem (OP) 
  history.residual = [];
  history.resnorm = [];
  history.x = [];
  searchdir = [];    
%% % lsqnonlin, Levenberg Marquardt, OP
theta_0 = [470,130];
% theta_0 = randi(rad*2,M,2);
% theta_0 = theta_0 - repmat([rad rad],M,1);
options_1 = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','iter-detailed','OutputFcn', @outfunc);
options_2 = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','iter-detailed','OutputFcn', @sap_optimplotfunccount); 
options_3 = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','iter-detailed','OutputFcn', @optimplotfval);

figure()  
set(axes,'FontSize',14,'LineStyleOrderIndex',2,'XGrid','on','YGrid','on');
axis([-770 750 -750 750])
xlabel('x coordinate ');
ylabel('y coordinate ');
[x_0,resnorm_0,residual_0,exitflag_0,output_0,lambda_0,jacobian_0] = lsqnonlin(@myfunc,theta_0, [], [], options_1);

figure()  
set(axes,'FontSize',14,'LineStyleOrderIndex',2,'XGrid','on','YGrid','on');
[x_0,resnorm_0,residual_0,exitflag_0,output_0,lambda_0,jacobian_0] = lsqnonlin(@myfunc,theta_0, [], [], options_2);

figure()  
set(axes,'FontSize',14,'LineStyleOrderIndex',2,'XGrid','on','YGrid','on');
[x_0,resnorm_0,residual_0,exitflag_0,output_0,lambda_0,jacobian_0] = lsqnonlin(@myfunc,theta_0, [], [], options_3);

%% Function for visualizing intermediate outputs of optimization 

function stop = outfunc(x,optimValues,state)
    stop = false;
 
     switch state
         case 'init'
             hold on
         case 'iter'
         % Concatenate current point and objective function
         % value with history. x must be a row vector.
           history.resnorm = [history.resnorm; optimValues.resnorm];
           history.residual = [history.residual; optimValues.residual];
           history.x = [history.x; x];
         % Concatenate current search direction with 
         % searchdir.
           searchdir = [searchdir;... 
                        optimValues.searchdirection'];           
           plot(x(1),x(2),'o');
         % Label points with iteration number and add title.
         % Add .15 to x(1) to separate label from plotted 'o'
           text(x(1)+.15,x(2),... 
                num2str(optimValues.iteration));
           title('Sequence of Points Computed by lsqnonlin');
         case 'done'
             hold off
         otherwise
     end
end
 
% %% Function to calculate residual vector 
% function F = myfunc(thet)
%     load phi;
%     load L_A;
%     my_gamma = 3;
%     d_0 = 1;
%     L_0 = 40;
%     
%     for ii = 1:6
%     F(ii) = 10*my_gamma*log10(norm((thet - phi(ii,:)))/d_0) - L_A(ii) + L_0;
%     end
% end
%% Plot the original point on the same figure 
hold on;
plot(theta_org(1),theta_org(2),'x');

%% MSE
mse_org_lm = sqrt((theta_org - x_0)*(theta_org - x_0)');

%% As a future task, try sample based approximation of the objective 
a = 1;
end