%% 07.03.2018 
% Perform MLE on the orignal objective 
% Algorithm : Levenberg Marquardt 

%% Generate data 
function [time_to_run, itrs, mse_org_lm] = understanding_mle(theta_org,theta_0) 

%plot_obj_func();

%% Perform MLE on the generated data 
% lsqnonlin, Levenberg-Marquardt, original problem (OP) 
  history.residual = [];
  history.resnorm = [];
  history.x = [];
  history.funccount = [];
  searchdir = [];    
%% % lsqnonlin, Levenberg Marquardt, OP
options_1 = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','OutputFcn', @outfunc); %,'Display','iter-detailed','OutputFcn', @outfunc);
% options_2 = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt'); %,'Display','iter-detailed','OutputFcn', @optimplotfunccount); 
% options_3 = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt'); %,'Display','iter-detailed','OutputFcn', @optimplotfval);

% figure()  
% set(axes,'FontSize',14,'LineStyleOrderIndex',2,'XGrid','on','YGrid','on');
% axis([-770 750 -750 750])
% xlabel('x coordinate ');
% ylabel('y coordinate ');

tic
[x_0,resnorm_0,residual_0,exitflag_0,output_0,lambda_0,jacobian_0] = lsqnonlin(@myfunc,theta_0, [], [], options_1);
%toc
time_to_run = toc;

%figure()  
%set(axes,'FontSize',14,'LineStyleOrderIndex',2,'XGrid','on','YGrid','on');
%[x_0,resnorm_0,residual_0,exitflag_0,output_0,lambda_0,jacobian_0] = lsqnonlin(@myfunc,theta_0, [], [], options_2);

% figure()  
% set(axes,'FontSize',14,'LineStyleOrderIndex',2,'XGrid','on','YGrid','on');
% [x_0,resnorm_0,residual_0,exitflag_0,output_0,lambda_0,jacobian_0] = lsqnonlin(@myfunc,theta_0, [], [], options_3);

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
           history.funccount = [history.funccount; optimValues.funccount];
         % Concatenate current search direction with 
         % searchdir.
           searchdir = [searchdir;... 
                        optimValues.searchdirection'];           
           %plot(x(1),x(2),'o');
         % Label points with iteration number and add title.
         % Add .15 to x(1) to separate label from plotted 'o'
           %text(x(1)+.15,x(2),... 
                %num2str(optimValues.iteration));
           %title('Sequence of Points Computed by lsqnonlin');
         case 'done'
             hold off
         otherwise
     end
end

%% Total time step
itrs = length(history.funccount);

%% Plot the original point on the same figure 
hold on;
plot(theta_org(1),theta_org(2),'x');

%% MSE
mse_org_lm = sqrt((theta_org - x_0)*(theta_org - x_0)');

%% As a future task, try sample based approximation of the objective 
a = 1;
end