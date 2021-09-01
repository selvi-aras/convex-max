%Example data generation of P4
n = 100;
q = n;
m=n;
%start D
D = rand(q,n);
d = 25 + 50*rand(q,1);
%d end
A = -3 + (6)*rand(m,n);
b = -1 + (2)*rand(m,1); 