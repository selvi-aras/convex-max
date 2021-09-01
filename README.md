# convex-max-via-ARO
Data and codes of the paper _Convex Maximization via Adjustable Robust Optimization_ by _Aras Selvi, Aharon Ben-Tal, Ruud Brekelmans, and Dick den Hertog (2021)_.

The preprint (version of 1 September 2021) is available on [Optimization Online](http://www.optimization-online.org/DB_FILE/2020/07/7881.pdf).

## Introduction
This repository provides the following:
- Example scripts that generate the random data explained in Appendix G of the paper
- The **exact** problem data that is used in the numerical experiments (Section 4) of the paper
- The scripts that implement upper and lower bound approximation algorithms of convex maximization problems
- The **exact** upper and lower bound values found, and the solutions of the upper and lower bound problems

## Dependencies
**MATLAB** - We use MATLAB 2018b to run the scripts. The scripts are compatible with the [latest release](https://uk.mathworks.com/downloads/) 2021a of MATLAB.

**YALMIP** - We use [YALMIP](https://yalmip.github.io/download/) to call optimization solvers. The code is compatible with the [latest release](https://github.com/yalmip/YALMIP/releases/tag/R20210331) (as of 1 September 2021) R20210331 of YALMIP. As a minimum requirement, YALMIP R20181012 is required (for the support of exponential cone modeling). 

**MOSEK** -  Version >= 9.0 is required for exponential cone optimization purposes. The code is compatible with the [latest release](https://www.mosek.com/documentation/) (as of 1 September 2021) 

**CPLEX** - Version >= 12.6 is required to solve nonconvex quadratic problems (for benchmark purposes). The code is compatible with [version 12.10](https://www.ibm.com/support/pages/downloading-ibm-ilog-cplex-optimization-studio-v12100). Note that the most recent version (as of 1 September 2021) 20.1 does not come with a MATLAB connector with anymore. 

**GUROBI** - Version >= 9.0 is used, and the code is compatible with the [latest release 9.1](https://www.gurobi.com/) (as of 1 September 2021). We use GUROBI to solve mixed integer linear optimization problems.

Moreover, although our upper/lower bound approximation algorithms only use the solvers mentioned above, we also compared our solutions with the solutions obtained by directly solving the original convex maximization problem with various solvers such as [BARON](https://minlp.com/download), [Artelys KNITRO](https://www.artelys.com/solvers/knitro/), [COIN-OR IPOPT](https://coin-or.github.io/Ipopt/), and [BMIBNB](https://yalmip.github.io/solver/bmibnb/). Please reach out to me (a.selvi19@imperial.ac.uk) for any question about using these solvers for global optimization.
