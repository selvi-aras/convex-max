n = 20;%x size
q = 10;%original constraints nr
m = n;%size of L^TL (as our approach starts with writing the objective as x^T L^T L x + ell^T x)
ell = -4*ones(n,1);
D = [-3 7 0 -5 1 1 0 2 -1 1; 7 0 -5 1 1 0 2 -1 -1 1; 0 -5 1 1 0 2 -1 -1 -9 1; ... 
     -5 1 1 0 2 -1 -1 -9 3 1; 1 1 0 2 -1 -1 -9 3 5 1;1 0 2 -1 -1 -9 3 5 0 1; ...
     0 2 -1 -1 -9 3 5 0 0 1; 2 -1 -1 -9 3 5 0 0 1 1; -1 -1 -9 3 5 0 0 1 7 1; ...
     -1 -9 3 5 0 0 1 7 -7 1; -9 3 5 0 0 1 7 -7 -4 1; 3 5 0 0 1 7 -7 -4 -6 1; ...
      5 0 0 1 7 -7 -4 -6 -3 1; 0 0 1 7 -7 -4 -6 -3 7 1; 0 1 7 -7 -4 -6 -3 7 0 1; ...
      1 7 -7 -4 -6 -3 7 0 -5 1; 7 -7 -4 -6 -3 7 0 -5 1 1; -7 -4 -6 -3 7 0 -5 1 1 1; ...
      -4 -6 -3 7 0 -5 1 1 0 1; -6 -3 7 0 -5 1 1 0 2 1]';
d = [-5; 2; -1; -3; 5; 4; -1; 0; 9; 40];
Q = eye(n);
%L = chol(Q);
[eig1,eig2] = eig(Q);
L = sqrt(eig2)*eig1.'; %L^T L = Q
save("P1")

%%%% NOTE: The construction here is as if we were maximizing only a part of
%%%% the objective function: x^T L^T L x + ell^T x. However, recall that
%%%% the main problem is 1/2(x^T L^T L x + ell^T x) + 40. So, remember to
%%%% divide the upper/lower bound by 2 and add 40 at the end.