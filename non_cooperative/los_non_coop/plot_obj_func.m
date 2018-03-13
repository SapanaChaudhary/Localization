%% Plotting the objective surface 

clear all
close all

% Sample a lot of thetas 
rad = 500;
M = 3500;
theta = randi(rad*2,M,2);
theta = theta - repmat([rad rad],M,1);
[X,Y] = meshgrid(-500:10:500,-500:10:500);

% % For each of the Ms, find objective function value 
% for ii = 1:400
%     for jj = 1:400
%         a = myfunc([ii,jj]);
%         a = a.^2;
%         of(ii,jj) = sum(a(:));
%     end
% end

for ii = 1:M
    a = myfunc(theta(ii,:));
    a = a.^2;
    of(ii) = sum(a(:));
end

x = theta(:,1); y = theta(:,2);
vq = griddata(x,y,of,X,Y,'cubic');

figure(1)
mesh(X,Y,vq);
hold on
plot3(x,y,of,'o');
xlabel('x coordinate')
ylabel('y coordinate')
zlabel('f(residual)')

h = gca;
h.XLim = [-550 550];
h.YLim = [-550 550];

% F = scatteredInterpolant(of(:,1),of(:,2),of(:,3));
% 
% Z = F(X,Y);
%   
% figure(2); hold on
% contourf(X,Y,Z,30,'LineStyle','none');
% 
% figure(3)
% surf(Z)