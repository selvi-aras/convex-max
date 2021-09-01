%DATA (example data generation of Problem 4)
n = 180;
m = 20;
A = rand(m,n)*1.5 - 1;
b = zeros(m,1);
a = rand(n,1);
rho = 1;
% save('P4')