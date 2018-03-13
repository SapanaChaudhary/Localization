%% script to run various optimization algorithms

% % Create a vector from L_A matrix
% LL = L_A';
% L = LL(:);
% 
% % create F 
% for ii = 1:6*M
%     if (rem(ii,66) ~=0)
%         jj = rem(ii,66);
%     else
%         jj = 6;
%     end
%     
%    F(ii) = @(thet) 10*gamma*log(norm((thet - phi(jj,:)),2)/d_0) - L(ii) + L_0;
% end

% do it for a single user first 


% define vector valued function
% The function values that are being input to the algorithms remain the
% same. Only the parameters change

% lsqnonlin, Levenberg-Marquardt, original problem (OP) 
theta_0 = [0,0];
options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','iter');
[x_0,resnorm_0,residual_0,exitflag_0,output_0] = lsqnonlin(@myfunc,theta_0, [], [], options);

% lsqnonlin, Levenberg-Marquardt, SDP's solution
theta_0 = theta_pred;
options = optimoptions('lsqnonlin','Algorithm','levenberg-marquardt','Display','iter');
[x_1,resnorm_1,residual_1,exitflag_1,output_1] = lsqnonlin(@myfunc,theta_0, [], [], options);

% lsqnonlin, Trust Region Reflective, OP
theta_0 = [0,0];
options = optimoptions('lsqnonlin','Display','iter');
[x_2,resnorm_2,residual_2,exitflag_2,output_2] = lsqnonlin(@myfunc,theta_0, [], [], options);

% lsqnonlin, Trust Region Reflective, SDP's solution
theta_0 = theta_pred;
options = optimoptions('lsqnonlin','Display','iter');
[x_3,resnorm_3,residual_3,exitflag_3,output_3] = lsqnonlin(@myfunc,theta_0, [], [], options);

%% Error analysis
% Mean squared errors 

% lsqnonlin, Levenberg-Marquardt, original problem (OP)
mse_org_lm = sqrt((theta_org - x_0)*(theta_org - x_0)'); 

% lsqnonlin, Levenberg-Marquardt, SDP's solution
mse_sdp_lm = sqrt((theta_org - x_1)*(theta_org - x_1)'); 

% lsqnonlin, Trust Region Reflective, OP
mse_org_tr = sqrt((theta_org - x_2)*(theta_org - x_2)'); 

% lsqnonlin, Trust Region Reflective, SDP's solution
mse_sdp_tr = sqrt((theta_org - x_3)*(theta_org - x_3)'); 


