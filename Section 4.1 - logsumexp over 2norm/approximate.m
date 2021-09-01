%% Load your data
problem_index = "P9";
load(strcat(problem_index, "/", problem_index)); %go to the folder and read the problem data
%% Define variables
w = sdpvar(m,1,'full');                          %optimization variable (using YALMIP)
diagonal = sum(A.^2,2); %In problem (10) the optimal V takes form ww^T (Selvi et al. 2020) so this will be used in the objective
%% Define and Solve Problem (10) - UB for Problem (8)
Objective = rho*sqrt(diagonal'*w) + a'*A'*w + b'*w + entropy(w); %the first part follows as: tr(A^T V A) = tr(A^T w w^T A) = diagonal^T w
Constraints = [w >= 0, sum(w) == 1]; %Now that after using V = ww^T the other constraints are redundant
soltn = optimize(Constraints, -Objective, sdpsettings('verbose', 0, 'solver','mosek')); %maximize 'Objective'
% soltn.solvertime % if you want to compare solver times
%% Save solutions - UB
upper_bound = value(Objective); w = value(w); %save the UB objective value and the 'w' vector that achieves this in Problem (10)
save("UB solution", "upper_bound", "w");      %save the UB solution
%% Analytically solve the LB and save
x_bar = (A'*w)*(rho/norm(A'*w,2)) + a; %as proposed in Corollary 1
lower_bound = logsumexp(A*x_bar + b);  %LB objective value
if lower_bound == inf %it means the exponentials inside return INF so we re-scale
    M = 500;
    lower_bound =  M + logsumexp(A*x_bar + b - M); %scale the objective -- this is enough for precision, if not try again
end
save("LB solution", "lower_bound", "x_bar");