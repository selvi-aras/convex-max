function [Objective, x, time,prob] = global_opt_solver(D,d,A,b,K,J) %optional - for global optimization benchmark
n = size(D,2);
x = sdpvar(n,1);

Constraints = [D*x <= d, x>= 0];
Objective = 0;
for k=1:K
    index = (k-1)*J + 1:(k)*J;
    Objective = Objective + max((A(index,:))*x + b(index));
end
%assign(x,x_lower);
%P = optimize(Constraints,-Objective,sdpsettings('solver','baron'));
%P = optimize(Constraints,-Objective, sdpsettings('solver', 'cplex','verbose',0, 'cplex.timelimit', 10000, 'usex0',1));
P = optimize(Constraints,-Objective, sdpsettings('solver', 'gurobi', 'verbose',0));
%P = optimize(Constraints,-Objective,sdpsettings('solver','knitro','knitro.optionsfile','fileopt.txt'));
%P = optimize(Constraints,-Objective,sdpsettings('solver','ipopt','ipopt.max_iter',999999, 'ipopt.max_cpu_time',999999));
x = value(x); Objective = value(Objective); time = P.solvertime; prob = P.problem;
end