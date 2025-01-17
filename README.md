# qregret
qregret

This repository contains MATLAB code for running Monte Carlo simulations to analyze Qregret in non-stationary environments. It simulates two algorithms Q-Regret and Q-ThS Regret over time.

## How to Run

1. **Set Parameters**: Modify the parameters at the start of `main_simulation.m`:
    - `N`: Number of arms (channels)
    - `T`: Number of time steps
    - `m`: Number of blocks for non-stationary rewards
    - `a`, `b`: Range for reward distribution (min/max)
    - `dist_type`: Reward distribution type (e.g., 'uniform', 'poisson')

2. **Run the Main Script**: Execute `multiple_runs_main.m` to run the Monte Carlo simulations. The script:
    - Generates non-stationary rewards.
    - Simulates queue evolution and calculates regret metrics.
    - Saves results in `.mat` files (e.g., `simulation_data_1.mat`).

3. **Plot the Results**: After the simulations, run `read_n_plot_avg_qregret.m` to load the saved data and plot the average Q-Regret over all simulations.

## Example:

```matlab
run('multiple_runs_main.m');
```

Then:

```matlab
run('read_n_plot_avg_qregret.m');
```

## Files

- **multiple_runs_main.m**: Main script for repeated Monte Carlo simulations.
- **main_qregret.m**: Main script for single run.
- **non_stat_channel_mult.m**: Generates non-stationary rewards.
- **simulate_queues_and_cumulative_service.m**: Simulates queue evolution.
- **our_algorithm.m**: Evaluated algorithm.
- **q_ths_algorithm.m**: Q-ThS algorithm.
- **plot_regret.m**: Plots Q-Regret.
- **read_n_plot_avg_qregret.m**: Loads and plots average Q-Regret.

