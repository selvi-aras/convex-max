%DATA (example data generation of Problem 7)
n = 240; % dimension of the variable x
q = 280; % number of constraints
m = n;   % so that L is a square matrix
ell = zeros(n,1); %objective is x^T L^T L x + ell^T x
L = rand(m,n); %generate L
Q = L'*L; %Q is L^T L 
D = eye(n); %first half of constraints are x  <= x_u
D = [D; rand(q-n,n)*2]; %second half of the constraints are Dx <= d
d = ones(n,1); %x_u = 1 
d = [d; randi([150,300],q-n,1)]; %RHS of Dx <= d
% save('P7')