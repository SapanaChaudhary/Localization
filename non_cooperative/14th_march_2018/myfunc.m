%% Function to calculate residual vector 

function F = myfunc(thet)
    load phi;
    load L_A;
    my_gamma = 3;
    load kk;
    d_0 = 1;
    L_0 = 40;
    
    for ii = 1:3
    F(ii) = 10*my_gamma*log10(norm((thet - phi(ii,:)))/d_0) - L_A(kk,ii) + L_0;
    end
end