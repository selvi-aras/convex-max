%% Load your data
problem_index = "P1";   %problem input
load(strcat(problem_index, "/", problem_index));
%% UB Problem (Table 2, first problem of quadratic maximization)
n = size(D,2);q = size(d,1);m = size(L,1); %dimensions
tau = sdpvar; %objective value that upper bounds the ARO constraint
u = sdpvar(q,1); %u in the problem
barv = sdpvar(q,1); %vbar in the problem
hatv = sdpvar(q,1); %hat V in the problem
V = sdpvar(q,m,'full'); %V is q times m
Objective = tau; %minimize tau
Constraints = [d.'*u+ barv'*d - 0.5 - (tau/2) + norm([V'*d; hatv'*d + 0.5 -  (tau/2)]) <= 0 ]; %first const
for i=1:n %second group of constraints that are for i=1,...,n
Constraints = [Constraints, -D(:,i)'*u + ell(i)/2 - barv'*D(:,i) + norm([L(:,i) - V'*D(:,i); ell(i)/2 - hatv'*D(:,i)]) <= 0];
end
for i=1:q %third group of constraints that are for i=1,...,q
Constraints = [Constraints, -u(i) - barv(i) + norm([-V(i,:)' ; -hatv(i)]) <= 0 ]; 
end
soltn= optimize(Constraints,Objective,sdpsettings('solver','mosek','verbose',0)); %upper bound is a SOCO problem
upper_bound = value(Objective);     %the UB value
%time = P.solvertime;
V = value(V); u = value(u); tau = value(tau); barv = value(barv); hatv = value(hatv); %the UB problem variables
save("UB solution", "upper_bound", "V", "u", "tau", "barv", "hatv"); %save the UB value and the solution of the UB problem
%% LB problem (Table 3, collect scenarios analytically and pick the best one)
Q = L'*L;
A = [L; ell'/2; ell'/2];
b= [zeros(m,1);(1-tau)/2; (-1-tau)/2];
%start scenario collection
scenarios_W = zeros(m+1,n+q+1);
temp = [V'*d; d'*hatv + (1-tau)/2];
scenarios_W(:,1) = temp/norm(temp);
for i=1:n
    temp = [L(:,i) - V'*D(:,i); ell(i)/2 - D(:,i)'*hatv];
    scenarios_W(:,i+1) = temp/norm(temp);
end
for i=1:q
    temp = [-V(i,:)' ; -hatv(i)];
    scenarios_W(:,i+1+q) = temp/norm(temp);
end
%scenario collection finished
%extract x
x = sdpvar(n,1);    %optimization variable to optimize LB solutions by using the scenarios above
Constraints = [D*x <= d, x>=0]; %original constraints
x_collection = []; obj_final = []; %solvertimes = []; %for keeping solver times
for i=1:size(scenarios_W,2) %go over each scenario (i.e., a scenario is a column vector so iterate over columns)
    Objective = -((A*x + b)'*[scenarios_W(:,i); 1]); %solving inner problem of (16) for different "w"s given by scenarios_W
    P = optimize(Constraints,Objective,sdpsettings('verbose', 0 ,'solver','cplex'));
    % solvertimes = [solvertimes, P.solvertime];
    x_collection = [x_collection, value(x)]; %lower bound solutions (we will pick the best out of those)
    obj_final = [obj_final, value(x)'*Q*value(x) + ell'*value(x)]; %lower bound attained by the solution
end
% time = sum(solvertimes);
[lower_bound, scenario] = max(obj_final); %pick the best objective value attained by one of these solutions
x_bar = x_collection(:,scenario); %choose x_bar as the solution that achieves the best objective value above
save("LB solution", "lower_bound", "x_bar", "scenarios_W", "x_collection"); %save the lower bound value and solution, as well as the scenarios.

