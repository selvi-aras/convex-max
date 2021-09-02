# convex-max-via-ARO
Data and codes of the paper _Convex Maximization via Adjustable Robust Optimization_ by _Aras Selvi, Aharon Ben-Tal, Ruud Brekelmans, and Dick den Hertog (2021)_.

The preprint (version of 1 September 2021) is available on [Optimization Online](http://www.optimization-online.org/DB_FILE/2020/07/7881.pdf). The paper is presented at [Robust Optimization Webinars](https://youtu.be/GEGUlTXfVX0) and at [Imperial-LBS-UCL Brown Bag Seminars](https://sites.google.com/view/phdmsorseminars/).
Aras received the [2021 ICS Best Student Paper Award](https://connect.informs.org/computing/awards/ics-student-paper-award) with this paper.

## Introduction
This repository provides the following:
- Example scripts that generate the random data explained in Appendix G of the paper
- The **exact** problem data that is used in the numerical experiments (Section 4) of the paper
- The scripts that implement upper and lower bound approximation algorithms of convex maximization problems
- The **exact** upper and lower bound values found, and the solutions of the upper and lower bound problems

## Dependencies
**MATLAB** - We use MATLAB 2018b to run the scripts. The scripts are compatible with the [latest release](https://uk.mathworks.com/downloads/) 2021a of MATLAB.

**YALMIP** - We use [YALMIP](https://yalmip.github.io/download/) to call optimization solvers. The scripts are compatible with the [latest release](https://github.com/yalmip/YALMIP/releases/tag/R20210331) (as of 1 September 2021) R20210331 of YALMIP. As a minimum requirement, YALMIP R20181012 is needed (for the support of exponential cone modeling). 

**MOSEK** -  Version >= 9.0 is required for exponential cone optimization purposes. The scripts are compatible with the [latest release](https://www.mosek.com/documentation/) (as of 1 September 2021) 

**CPLEX** - Version >= 12.6 is required to solve nonconvex quadratic problems (for benchmark purposes). The scripts are compatible with [version 12.10](https://www.ibm.com/support/pages/downloading-ibm-ilog-cplex-optimization-studio-v12100). Note that the most recent version (as of 1 September 2021) 20.1 does not come with a MATLAB connector with anymore. 

**GUROBI** - Version >= 9.0 is used, and the scripts are compatible with the [latest release 9.1](https://www.gurobi.com/) (as of 1 September 2021). We use GUROBI to solve mixed integer linear optimization problems.

Moreover, although our upper/lower bound approximation algorithms only use the solvers mentioned above, we also compared our solutions with the solutions obtained by directly solving the original convex maximization problem with various solvers such as [BARON](https://minlp.com/download), [Artelys KNITRO](https://www.artelys.com/solvers/knitro/), [COIN-OR IPOPT](https://coin-or.github.io/Ipopt/), and [BMIBNB](https://yalmip.github.io/solver/bmibnb/). Please reach out to Aras (a.selvi19@imperial.ac.uk) for any question about using these solvers for global optimization.

## Description
The following is a guide to use this repository. Note that all data files are in ".mat" format (data file used by MATLAB, documentation available [here](https://www.mathworks.com/help/pdf_doc/matlab/matfile_format.pdf)). All the scripts are in ".m" format (MATLAB script files). In some folders there are ".txt" files just to comment on some implementations (not important).

The folders are summarized below:

**Section 4.1 - logsumexp over 2norm**
This folder is about the problem of maximizing a log-sum-exp (geometric) function over a single 2-norm constraint. In other words, this folder is dedicated to problem (1) of the paper where the objective function is a log-sum-exp function, and the constraint function g(.) is a 2-norm.

The file ```Generate_Data.m``` generates an example problem, where one can see how we name the variables that define the convex maximization problem (```n```, ```m```, ```A```, ```b```, ```rho```, ```a```). This is how we construct instances of the convex maximization problem.

The numerical experiments of the paper (Section 4.1) summarize the results of 12 problems whose generation are explained in Appendix G.1. The exact problem data are available in the corresponding sub-folders of this folder. For example, data of Problem #1 of the paper can be found under the folder ```P1``` with the name ```P1.mat```. The upper and lower bound results given by our approximation scheme are also available with the names ```UB solution.mat``` and ```LB solution.mat```, respectively.

For a given convex maximization instance, the file ```approximate.m``` solves the upper and lower bound approximation problems as proposed in Corollary 1 of the paper. The file takes an input ```problem_index```. Setting this to, e.g., "P9", will load ```P9/P9.mat``` and return upper and lower bound approximation results. One can also generate a new instance by modifying ```Generate_Data.m``` and approximate that problem by loading it in the beginning of ```approximate.m```. 

Details of ```approximate.m```: To obtain an upper bound it solves problem (10) of the paper, and the lower bound solution is proposed in the statement of Corollary 1. The upper bound value and solution are saved as ```UB solution.mat```, and the lower bound value and solution are saved as ```LB solution.mat```. 

**Section 4.2 - logsumexp over infnorm**
This folder is about the problem of maximizing a log-sum-exp (geometric) function over a single infinity-norm constraint. In other words, this folder is dedicated to problem (1) of the paper where the objective function is a log-sum-exp function, and the constraint function g(.) is an infinity-norm. 

The file ```Generate_Data.m``` generates an example problem, where one can see how we name the variables that define the convex maximization problem (```n```, ```m```, ```A```, ```b```, ```rho```, ```a```). This is how we construct instances of the convex maximization problem.

The numerical experiments of the paper (Section 4.2) summarize the results of 5 problems whose generation are explained in Appendix G.2. The exact problem data are available in the corresponding sub-folders of this folder. For example, data of Problem #1 of the paper can be found under the folder ```P1``` with the name ```P1.mat```. The data of exact solution our method finds is also available with the name ```Solution.mat```.

For a given convex maximization instance, the file ```approximate.m``` solves the equivalent optimization problem and retrieves the solution that attains it as proposed in Corollary 2 of the paper. The file takes an input ```problem_index```. Setting this to, e.g., "P5", will load ```P5/P5.mat``` and return upper and lower bound approximation results. One can also generate a new instance by modifying ```Generate_Data.m``` and approximate that problem by loading it in the beginning of ```approximate.m```. 

Details of ```approximate.m```: To obtain the global optimum value of the convex maximization problem it solves problem (11) of the paper. The corresponding solution that attains this value in the main problem is obtained by solving the LP proposed in the statement of Corollary 2. The global optimum value, the solution ```w``` of problem (11), and the solution ```x_bar``` that attains this value in the original problem are saves as "Solution.mat".

**Section 4.3 - quadratic over polyhedron**
This folder is about the problem of maximizing a convex quadratic function over a polyhedron ```{x | Dx <= d, x >= 0}```. In other words, this folder is dedicated to problem (20) of the paper where the objective function is a convex quadratic function. The problem (including parameter definitions) is summarized in the first row of Table 1 of the paper.

The file ```Generate_Data.m``` generates an example problem, where one can see how we name the variables that define the convex maximization problem (```n```, ```m```, ```q```, ```Q```, ```L```, ```ell```, ```D```, ```d```). This is how we construct instances of the convex maximization problem.

The numerical experiments of the paper (Section 4.3) summarize the results of 7 problems whose generation are explained in Appendix G.3. The exact problem data are available in the corresponding sub-folders of this folder. For example, data of Problem #7 of the paper can be found under the folder ```P7``` with the name ```P7.mat```. The upper and lower bound results given by our approximation scheme are also available with the names ```UB solution.mat``` and ```LB solution.mat```, respectively. The file ```readme.txt``` in folders ```P1``` and ```P2``` notes an extra step needed for Problems #1 and #2.

For a given convex maximization instance, the file ```approximate.m``` solves the upper and lower bound approximation problems as proposed in Theorem 3 and equations (26)-(28), and derived explicitly in Appendix D.1. of the paper. The file takes an input ```problem_index```. Setting this to, e.g., "P7", will load ```P7/P7.mat``` and return upper and lower bound approximation results (including the lower bound scenarios). One can also generate a new instance by modifying ```Generate_Data.m``` and approximate that problem by loading it in the beginning of ```approximate.m```. 

Details of ```approximate.m```: To obtain an upper bound it solves the SOCO problem described in the first row of Table 2 of the paper. Lower bound scenarios are analytically obtained by using the upper bound solution as summarized in the first row of Table 3, and these scenarios are used to generate candidate lower bound solutions ```x_bar```. The upper bound value and solution are saved as ```UB solution.mat```, and the lower bound value, scenarios, and solutions are saved as ```LB solution.mat```. 

**Section 4.4 - logsumexp over polyhedron**
This folder is about the problem of maximizing a convex quadratic function over a polyhedron ```{x | Dx <= d, x >= 0}```. In other words, this folder is dedicated to problem (20) of the paper where the objective function is a log-sum-exp (geometric) function. The problem (including parameter definitions) is summarized in the second row of Table 1 of the paper.

The file ```Generate_Data.m``` generates an example problem, where one can see how we name the variables that define the convex maximization problem (```n```, ```m```, ```q```, ```A```, ```b```, ```D```, ```d```). This is how we construct instances of the convex maximization problem.

The numerical experiments of the paper (Section 4.4) summarize the results of 6 problems whose generation are explained in Appendix G.4. The exact problem data are available in the corresponding sub-folders of this folder. For example, data of Problem #4 of the paper can be found under the folder ```P4``` with the name ```P4.mat```. The upper and lower bound results given by our approximation scheme are also available with the names ```UB solution.mat``` and ```LB solution.mat```, respectively. Note that, Problem #1 has four different variants (size10, size40, size60, size100), hence when addressing this problem we input, e.g., ```P1-size40```.

For a given convex maximization instance, the file ```approximate.m``` solves the upper and lower bound approximation problems as proposed in Theorem 3 and equations (26)-(28), and derived explicitly in Appendix D.2. of the paper. The file takes an input ```problem_index```. Setting this to, e.g., "P4", will load ```P4/P4.mat``` and return upper and lower bound approximation results (including the lower bound scenarios). One can also generate a new instance by modifying ```Generate_Data.m``` and approximate that problem by loading it in the beginning of ```approximate.m```. 

Details of ```approximate.m```: To obtain an upper bound it solves the exponential cone problem described in the second row of Table 2 of the paper. Lower bound scenarios are obtained by using the upper bound solution as summarized in the second row of Table 3, and these scenarios are used to generate candidate lower bound solutions ```x_bar```. The upper bound value and solution are saved as ```UB solution.mat```, and the lower bound value, scenarios, and solutions are saved as ```LB solution.mat```. 

**Section 4.5 - sumofmax over polyhedron**
This folder is about the problem of maximizing a convex quadratic function over a polyhedron ```{x | Dx <= d, x >= 0}```. In other words, this folder is dedicated to problem (20) of the paper where the objective function is a sum-of-max-linear-terms function. The problem (including parameter definitions) is summarized in the third row of Table 1 of the paper.

The file ```Generate_Data.m``` generates an example problem, where one can see how we name the variables that define the convex maximization problem (```n```, ```m```, ```K```, ```J```, ```A```, ```b```, ```D```, ```d```). This is how we construct instances of the convex maximization problem.

The numerical experiments of the paper (Section 4.5) summarize the results of 13 problems whose generation are explained in Appendix G.5. The exact problem data are available in the corresponding sub-folders of this folder. For example, data of Problem #9 of the paper can be found under the folder ```P9``` with the name ```P9.mat```. The upper and lower bound results given by our approximation scheme are also available with the names ```UB solution.mat``` and ```LB solution.mat```, respectively. 

For a given convex maximization instance, the file ```approximate.m``` solves the upper and lower bound approximation problems as proposed in Theorem 3 and equations (26)-(28), and derived explicitly in Appendix D.3. of the paper. The file takes an input ```problem_index```. Setting this to, e.g., "P9", will load ```P9/P9.mat``` and return upper and lower bound approximation results (including the lower bound scenarios). One can also generate a new instance by modifying ```Generate_Data.m``` and approximate that problem by loading it in the beginning of ```approximate.m```. 

Details of ```approximate.m```: To obtain an upper bound it solves the linear optimization problem described in the third row of Table 2 of the paper. Lower bound scenarios are obtained by using the upper bound solution as summarized in the third row of Table 3, and these scenarios are used to generate candidate lower bound solutions ```x_bar```. The upper bound value and solution are saved as ```UB solution.mat```, and the lower bound value, scenarios, and solutions are saved as ```LB solution.mat```. 

## Final Notes
The following scripts are also available upon request:
- Implementation of an algorithm to solve the upper bound problem, i.e., [The Adversarial Approach](https://www.sciencedirect.com/science/article/pii/S1572528607000382), which is useful when the perspective function is hard to optimize in the UB problem
- Implementation of the [FME algorithm to eliminate the adjustable variables](https://pubsonline.informs.org/doi/abs/10.1287/opre.2017.1714) in the equivalent ARO problem of the convex maximization problem
- The global optimization benchmark scripts (i.e., using global optimization solvers to attempt solving the convex maximization problem directly)
- A branch and bound algorithm where convex maximization over a polyhedron is consecutively being split into smaller regions and our upper/lower bound approximations are applied on each split
- Vertex enumeration in small polyhedra to find the global optimal values

## Thank You
Thank you for your interest in our work. If you found this work useful in your research and/or applications, please star this repository and cite:
```
@article{selvi2020convex,
  title={Convex maximization via adjustable robust optimization},
  author={Selvi, Aras and Ben-Tal, Aharon and Brekelmans, Ruud and den Hertog, Dick},
  journal={Available on Optimization Online},
  year={2020}
}
```
Please contact Aras (a.selvi19@imperial.ac.uk) if you encounter any issues using the scripts. For any other comment or question, please do not hesitate to contact us:

[Aras Selvi](https://www.imperial.ac.uk/people/a.selvi19) _(a.selvi19@imperial.ac.uk)_

[Aharon Ben-Tal](https://web.iem.technion.ac.il/site/academicstaff/aharon-ben-tal/) _(abental@technion.ac.il)_

[Ruud Brekelmans](https://www.tilburguniversity.edu/staff/r-c-m-brekelmans) _(r.c.m.brekelmans@tilburguniversity.edu)_

[Dick den Hertog](https://www.uva.nl/en/profile/h/e/d.denhertog/d.den-hertog.html) _(d.denhertog@uva.nl)_
