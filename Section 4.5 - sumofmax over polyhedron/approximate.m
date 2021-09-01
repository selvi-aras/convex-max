%% Load your data
problem_index = "P9";
load(strcat(problem_index, "/", problem_index));
%% UB Problem (Table 2, third problem of sum-of-max-terms maximization over a polyhedron)
q = length(d); %constraints #
% variables
tau = sdpvar; 
u = sdpvar(q,1);
V = sdpvar(q,m,'full');
%define the problem
Objective = tau;
Constraints = [];

y_c1 = sdpvar(K,1); %the max terms of each group
Constraints = [Constraints, d'*u + sum(y_c1) <= tau];
for k=1:K
    index = (k-1)*J + 1: k*J;
    Constraints = [Constraints, y_c1(k) >= V(:,index)'*d + b(index)];
end

y_c2 = sdpvar(K,n); %the max terms of each group
for i=1:n
    Constraints = [Constraints, -D(:,i)'*u + sum(y_c2(:,i)) <= 0];
    for k=1:K
        Constraints = [Constraints, y_c2(k,i) >= A((k-1)*J + 1: k*J,i) - V(:,(k-1)*J + 1: k*J)'*D(:,i)];
    end
end

y_c3 = sdpvar(K,q); %the max terms of each group
for i=1:q
    Constraints = [Constraints, -u(i) + sum(y_c3(:,i)) <= 0];
    for k=1:K
        Constraints = [Constraints, y_c3(k,i) >= -V(i,(k-1)*J + 1: k*J)];
    end
end

P = optimize(Constraints,Objective,sdpsettings('verbose', 0 ,'solver','cplex'));
if P.problem~=0
    disp("error")
end
disp(P.solvertime)
upper_bound= value(Objective);
%time = P.solvertime;

%clear sum1 sum2 sum3 i j Constraints
V = value(V); u = value(u); tau = value(tau); y_c1 = value(y_c1); y_c2 = value(y_c2); y_c3 = value(y_c3);
prob = P.problem;
save("UB solution", "upper_bound", "V", "u", "tau", "y_c1", "y_c2", "y_c3"); %save the UB value and the solution to the UB problem
%% LB problem (Table 3, collect scenarios analytically and pick the best one)
%start scenario collection
scenarios_W = zeros(m,n+q+1);
% solvertimes = zeros(n+q+1,1);
%scenario 1 (analytically solvable as well, no need to solve an optimization problem)
w = sdpvar(m,1);
Constraints = [w>=0];
for k=1:K
    index = (k-1)*J + 1: k*J;
    Constraints = [Constraints, sum(w(index)) == 1];
end

Objective = d'*(u + V*w) + b'*w - tau;
P = optimize(Constraints, -Objective,sdpsettings('verbose', 0 , 'solver','cplex'));
if P.problem~=0
    disp("error")
end
scenarios_W(:,1) = value(w);
% solvertimes(1) = P.solvertime;
yalmip clear;

%scenario 2
for i=1:n
    w = sdpvar(m,1);
    Constraints = [w>=0];
    for k=1:K
        index = (k-1)*J + 1: k*J;
        Constraints = [Constraints, sum(w(index)) == 1];
    end
    Objective = (A(:,i)'*w - D(:,i)'*(u + V*w));
    P = optimize(Constraints,-Objective,sdpsettings('verbose', 0 ,'solver','cplex'));
    scenarios_W(:,i+1) = value(w);
    % solvertimes(i + 1) = P.solvertime;
    yalmip clear;
    
end
%scenarios 3
for i=1:q
    w = sdpvar(m,1);
    Constraints = [w>=0];
    for k=1:K
        index = (k-1)*J + 1: k*J;
        Constraints = [Constraints, sum(w(index)) == 1];
    end
    Objective = -u(i) - V(i,:)*w;
    P = optimize(Constraints,-Objective,sdpsettings('verbose', 0 ,'solver','cplex'));
    scenarios_W(:,i+n+1) = value(w);
    % solvertimes(i+n+1) = P.solvertime;
    yalmip clear;
end


%scenario collection done
%extract x
x = sdpvar(n,1);
Constraints = [D*x <= d, x>=0];
x_collection = zeros(n,n+q+1); obj_final = zeros(1,n+q+1); %lptimes = zeros(n+q+1,1);
for i=1:(n+q+1)
    Objective = -(A*x + b)'*scenarios_W(:,i);
    P = optimize(Constraints,Objective,sdpsettings('verbose', 0 ,'solver','cplex'));
    %lptimes(i) = P.solvertime;
    x_collection(:,i) = value(x);
    obj_final(i) = 0;
    for k=1:K
        index = (k-1)*J + 1:(k)*J;
        obj_final(i) = obj_final(i) + max((A(index,:))*value(x) + b(index));
    end
end
%time = sum(solvertimes + lptimes);
[lower_bound, scenario] = max(round(obj_final,4)); %pick the best scenario
x_bar = x_collection(:,scenario);   %take the solution of the best scenario
save("LB solution", "lower_bound", "x_bar", "scenarios_W", "x_collection"); %save the LB value and the solution to the LB problem, as well as the LB scenarios
