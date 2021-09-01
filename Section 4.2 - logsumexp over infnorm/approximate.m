%% Load your data
problem_index = "P5"; %change the problem
load(strcat(problem_index, "/", problem_index)); %go to the folder and read the problem data
%% Define variables
w = sdpvar(m,1,'full'); %optimization variable (using YALMIP)
%% Solve problem (11) to retrieve the global optimum value
Objective = rho*norm(A'*w,1) + a'*A'*w +b'*w + entropy(w); %the objective function
Constraints = [w >= 0, sum(w)==1]; %simplex constraints (as domain of f^* is a simplex when f is log-sum-exp)
soltn = optimize(Constraints, -Objective, sdpsettings('verbose',0,'solver','mosek')); %optimize
global_optimum = value(Objective); w = value(w);%the optimal objective value and the 'w' vector that achieves this in Problem (11)
%% Solve problem (7) by using "w" that is optimized above to retrieve x_bar (original global solution)
x_bar = sdpvar(n,1);    %main optimization variable in problem (1)
Objective = (A'*value(w))'*x_bar; %the objective function of problem (7) to maximize
soltn2 = optimize([norm(x_bar - a, inf) <= rho], -Objective, sdpsettings('verbose', 0,'solver','cplex')); %easy LP
x_bar = value(x_bar);
save("Solution", "global_optimum", "w", "x_bar"); %save the global optimum value, and solutions of problem (11) and (7) (latter is a solution to (1)).
% soltn.solvertime + soltn2.solvertime %for runtime