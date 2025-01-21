# qregret
qregret

This repository contains MATLAB code for running Monte Carlo simulations to analyze Qregret in non-stationary environments. 
It simulates three algorithms Q-Regret [Sinha and Krishnakumar, 2025], Q-ThS [S Krishnasamy eta al., 2016] and [Stahlbuhk,2021]. 
It plots Queue Length Regret over time.

Requirements:
MATLAB (R2020b+) preinstalled. 
Necessary MATLAB toolbox: Statistics and Machine Learning Toolbox.

How to Run:
1. Clone the repository: git clone https://github.com/krishna-iitm/qregret.git
2. cd qregret
3. Open matlab and change directory to the qregret repository
4. The main file is 'multiple_runs_main'
5. run multiple_runs_main in the command line. If your working directory is correct it should run and plot or stop on some error.

The idea is to run the multiple_runs_main.m script followed by read_and_plot_avg_qregret.m.

This will:
Create a results/ directory with subfolders for each simulation run.
Run num_of_sim (default 500) Monte Carlo simulations.
Generate average regret plots and save them as PDFs.

Key Parameters:
N: Number of arms (channels), default 5.
T: Number of time steps, default 10,000.
m: Number of blocks for non-stationary rewards, default 7.
num_of_sim: Number of simulations, default 500.
Adjust these in the script as needed.

Results:
Each simulation run produces:

simulation_data_#.mat: Stores all variables for that run.
Plots saved as PDFs in the corresponding folder.

Custom Breakpoints:
To use custom breakpoints for non-stationary rewards: Incase you want to divide the T at custom points to change its statistics,
we can use the custom breakpoints with the following two lines uncommented and given appropriate T values at which you seek a 
change of statistics. 

% isCustomBreakPointsNeeded = true;
% breakpoints = [1 1000 10000]; % Example custom breakpoints



## Files

- **multiple_runs_main.m**: Main script for repeated Monte Carlo simulations.
- **non_stat_channel_mult.m**: Generates non-stationary rewards.
- **simulate_queues_and_cumulative_service.m**: Simulates queue evolution.
- **our_algorithm.m**: Proposed algorithm.
- **q_ths_algorithm.m**: Q-ThS algorithm - Regret of Queueing Bandits (S Krishnasamy et al.)
- **stahlbuhk_algo_01.m**: Stahlbuhk 2021 Learning Algorithms for Minimizing Queue-Length Regret.
- **plot_regret.m**: Plots Q-Regret.
- **read_n_plot_avg_qregret.m**: Loads and plots average Q-Regret.

