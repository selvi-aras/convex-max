%% Load your data
problem_index = "P4"; %problem input
load(strcat(problem_index, "/", problem_index)); %load the problem
%% UB Problem (Table 2, second problem of geometric maximization over a polyhedron)
% variables
tau = sdpvar;
u = sdpvar(q,1);
V = sdpvar(q,m,'full');
r = sdpvar(q,1);
% setup model
Objective = tau;
Constraints = [];

%group 1 constraints
z1 = sdpvar(m,1);
for j=1:m; Constraints = [Constraints, expcone([V(:,j)'*d + b(j) - tau + d'*u,1+d'*r, z1(j)])];end %cone constraints
Constraints = [Constraints, 1+d'*r >= sum(z1)];
Constraints = [Constraints, 1+d'*r >= 10^(-7)]; %this is redundant but needed due to some rounding issues of the "expcone"
%group 2 constraints
z2 = sdpvar(n,m,'full');
for i=1:n
for j=1:m; Constraints = [Constraints, expcone([A(j,i)- V(:,j)'*D(:,i) - D(:,i)'*u, -D(:,i)'*r ,z2(i,j)])];end %cone constraints
Constraints = [Constraints, -D(:,i)'*r >= sum(z2(i,:)), -D(:,i)'*r >= 10^(-7)];
end
%group 3 constraints
z3 = sdpvar(q,m,'full');
for i=1:q
for j=1:m; Constraints = [Constraints, expcone([-V(i,j)-u(i) , -r(i),z3(i,j)])];end %cone constraints
Constraints = [Constraints, -r(i) >= sum(z3(i,:)), -r(i) >= 10^(-7)];
end

P = optimize(Constraints,Objective,sdpsettings('verbose', 0,'solver','mosek')); %optimize
% time = P.solvertime; % time of the solver if needed
upper_bound = value(Objective);
V = value(V); u = value(u); tau = value(tau); r = value(r); z1 = value(z1); z2 = value(z2); z3 = value(z3);
prob = P.problem;
if prob ~= 0
    disp("error!")
end
save("UB solution", "upper_bound", "V", "u", "tau", "r", "z1","z2","z3"); %save the upper bound value and the solution of the UB problem
%% LB problem (Table 3, collect scenarios by solving exponential cone problems and pick the best one)
scenarios_W = zeros(m,n+q+1); %scenario collection matrix (columns are scenarios)
% solvertimes = zeros(n+q+1,1);
%scenario group 1
w = sdpvar(m,1);
Constraints = [w>=0, sum(w)==1]; %simplex
Objective = -(d'*u + d'*V*w + b'*w + (1+d'*r)*entropy(w) - tau); %no need to model with exponential cone constraints. YALMIP does automatically!
P = optimize(Constraints,Objective,sdpsettings('verbose', 0, 'solver','mosek'));
scenarios_W(:,1) = value(w);
% solvertimes(1) = P.solvertime;
yalmip clear;
%scenario group 2
for i=1:n
    w = sdpvar(m,1);
    %w0 = sdpvar(1,1);
    Constraints = [w>=0, sum(w)==1];
    Objective = - (A(:,i).'*w - D(:,i).'*(u + V*w + r*(entropy(w))));
    P = optimize(Constraints,Objective,sdpsettings('verbose', 0 ,'solver','mosek'));
    scenarios_W(:,i+1) = value(w);
%    solvertimes(i + 1) = P.solvertime;
    yalmip clear;
end
%scenario group 3
for i=1:q
    w = sdpvar(m,1);
    %w0 = sdpvar(1,1);
    Constraints = [w>=0, sum(w)==1];
    Objective = u(i) + V(i,:)*w + r(i)*(entropy(w));
    P = optimize(Constraints,Objective,sdpsettings('verbose', 0 ,'solver','mosek'));
    scenarios_W(:,i+n+1) = value(w);
    %solvertimes(i+n+1) = P.solvertime;
    yalmip clear;
end
%scenario collection done
%extract x by using the scenarios
x = sdpvar(n,1); %we will re-use this variable to extract solutions
Constraints = [D*x <= d, x>=0]; %original polyhedron constraints
x_collection = zeros(n,n+q+1); obj_final = zeros(1,n+q+1); %save solutions %lptimes = zeros(n+q+1,1);
for i=1:(n+q+1)
    Objective = -(A*x + b)'*scenarios_W(:,i);
    P = optimize(Constraints,Objective,sdpsettings('verbose', 0 ,'solver','cplex'));
    % lptimes(i) = P.solvertime;
    x_collection(:,i) = value(x);
    obj_final(i) = logsumexp(value(A*x+b));
    if obj_final(i) == inf %if obj_final is inf it means log(exp(big number)) = log(inf) = inf so we need to rescale
        obj_final(i) = 500 + logsumexp(value(A*x+b) - 500); %re-scale by using M = 500
    end
end
% time = sum(solvertimes + lptimes);
[lower_bound, scenario] = max(round(obj_final,4)); %pick the best scenario
x_bar = x_collection(:,scenario); %take the solution corresponding to the best scenario
save("LB solution", "lower_bound", "x_bar", "scenarios_W", "x_collection"); %save the LB value and solution, as well as the scenarios.
