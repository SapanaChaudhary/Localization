%% dummy
clear all
close all

x = linspace(-2*pi,2*pi);
y = linspace(0,4*pi);
[X,Y] = meshgrid(x,y);
Z = sin(X)+cos(Y);

figure
contour(X,Y,Z)