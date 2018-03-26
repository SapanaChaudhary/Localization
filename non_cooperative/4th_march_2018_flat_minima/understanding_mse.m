fun = @(x,y) sqrt( (-0.5-x).^2 + (0.5-y).^2 );

in = integral2(fun,-1,1,-1,1);