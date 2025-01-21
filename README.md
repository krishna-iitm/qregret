# qregret
qregret

This repository contains MATLAB code for running Monte Carlo simulations to analyze Qregret in non-stationary environments. 
It simulates three algorithms Q-Regret [Sinha and Krishnakumar, 2025], Q-ThS [S Krishnasamy eta al., 2016] and [Stahlbuhk,2021]. 
It plots Queue Length Regret over time.

Requirements:
MATLAB (R2020b+)
Necessary MATLAB toolboxes: Statistics and Machine Learning Toolbox.
How to Run:
Clone the repository:
## Files

- **multiple_runs_main.m**: Main script for repeated Monte Carlo simulations.
- **main_qregret.m**: Main script for single run.
- **non_stat_channel_mult.m**: Generates non-stationary rewards.
- **simulate_queues_and_cumulative_service.m**: Simulates queue evolution.
- **our_algorithm.m**: Evaluated algorithm.
- **q_ths_algorithm.m**: Q-ThS algorithm.
- **plot_regret.m**: Plots Q-Regret.
- **read_n_plot_avg_qregret.m**: Loads and plots average Q-Regret.

