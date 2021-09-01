%DATA (example data generation of Problem 6)
n = 200;
K = 50;
J = 50;
m = J*K;
A = -4 + (8)*rand(m,n);
b = zeros(m,1);
D = [eye(n); -eye(n)]; %constraints are written as Dx <= d as usual
part = zeros(n,1);
invpart = zeros(n,1);
for i=1:n
    part(i)= n/i;
    invpart(i) = i/n;
end
d = [part; invpart];