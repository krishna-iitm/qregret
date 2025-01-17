% Script to load .mat files from the current directory, calculate mean q_regret, and plot it
% Run multiple_runs_mains.m before running this script
% Get all .mat files in the current directory

% Used to average the num_of_sims experiment
mat_files = dir('simulation_data_*.mat');  % Assumes files are named simulation_data_#.mat

% Initialize an empty array to store q_regret from each file
q_regret_all_sims = [];
q_regret_qths_all_sims = [];

% Loop through each .mat file and extract q_regret and qths_regret
for i = 1:length(mat_files)
    % Load the .mat file
    load(mat_files(i).name);  % Load the data for the current simulation
    
    % Check if q_regret exists in the current file
    if exist('q_regret', 'var')
        % Store q_regret for this simulation
        q_regret_all_sims(:, i) = q_regret;  % Assuming q_regret is a vector with size [T, 1]
    else
        warning(['q_regret not found in ' mat_files(i).name]);
    end

    % Check if q_regret exists in the current file
    if exist('q_regret_qths', 'var')
        % Store q_regret for this simulation
        q_regret_qths_all_sims(:, i) = q_regret_qths;  % Assuming q_regret is a vector with size [T, 1]
    else
        warning(['q_regret_qths not found in ' mat_files(i).name]);
    end


end

% Calculate the average q_regret across all simulations
q_regret_avg = mean(q_regret_all_sims, 2);  % Take the mean across columns (simulations)
q_regret_qths_avg = mean(q_regret_qths_all_sims,2); 

% Plot the average q_regret using the existing plot_regret function
disp('Plotting the averaged Q-Regret...');
% Assuming T is the length of q_regret
titleString = ' (\lambda =\mu + 0.1) '
plot_regret(length(q_regret_avg), q_regret,m,q_regret_qths,titleString);
% writematrix(q_regret_avg, 'avg_q_regret.csv');
%writematrix(q_regret_qths_avg,'avg_qths_regret.csv');