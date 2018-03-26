
% Each coloumn contains multiple copies of the data 
count = load('count.dat');

x = (1:size(count,1))';
y = mean(count,2);
e = std(count,1,2);

errorbar(x,y,e,'rx');