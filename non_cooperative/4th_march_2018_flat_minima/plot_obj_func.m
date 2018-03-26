%% Plotting the objective surface 

function [] = plot_obj_func()
% Sample a lot of thetas 
rad = 500;
M = 100;
theta1 = randi(rad*2,M,2);
theta1 = theta1 - repmat([rad rad],M,1);
[X,Y] = meshgrid(-500:10:500,-500:10:500);

for ii = 1:M
    a = myfunc(theta1(ii,:));
    a = a.^2;
    of(ii) = sum(a(:));
end

x = theta1(:,1); y = theta1(:,2);
vq = griddata(x,y,of,X,Y,'cubic');

figure1 = figure(1)
axes1 = axes('Parent',figure1);
%hold(axes1,'on');
mesh(X,Y,vq);
hold on
plot3(x,y,of,'o');
xlabel('x coordinate')
ylabel('y coordinate')
zlabel('f(residual)')
% box(axes1,'on');
% grid(axes1,'on');
set(axes1,'FontSize',14);

figure(2)
contour3(X,Y,vq,30);
% h = gca;
% h.XLim = [-550 550];
% h.YLim = [-550 550];

saveas(figure1,'Objective_function','epsc') 
end