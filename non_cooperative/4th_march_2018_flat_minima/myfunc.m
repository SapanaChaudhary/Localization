%% Function to calculate residual vector 

function F = myfunc(thet)
    load phi;
    load L_A;
    my_gamma = 3;
    d_0 = 1;
    L_0 = 40;
    
    for ii = 1:6
        F(ii) = 10*my_gamma*log10(norm((thet - phi(ii,:)))/d_0) - L_A(ii) + L_0;
    end
    
    k = 1:6;
    if nargout > 1
        J = zeros(6,2);
        J(k,1) = -k.*exp(k*x(1));
        J(k,2) = -k.*exp(k*x(2));
    end
end