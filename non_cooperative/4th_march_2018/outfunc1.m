%% output function 
% To understand MLE output at each iteration
function stop = outfun1(x,optimValues,state)

    history.residual = [];
    history.resnorm = [];
    history.x = [];
    searchdir = [];
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
           title('Sequence of Points Computed by fmincon');
         case 'done'
             hold off
         otherwise
     end
 end
 

