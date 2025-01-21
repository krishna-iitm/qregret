% Script to load .mat files from the current directory, calculate mean q_regret, and plot it
% Run multiple_runs_mains.m before running this script
% Get all .mat files in the current directory

clear all;
% Used to average the num_of_sims experiment
matdata_files = dir('simulation_data_*.mat');  % Assumes files are named simulation_data_#.mat

% Initialize an empty array to store q_regret from each file
q_regret_all_sims = [];
q_regret_qths_all_sims = [];
q_regre_stahlbuhk_all_sims = [];

mean_service_per_arm_all_sims = [];
mean_arrival_all_sims =[];

all_arms_qreg_all_sims = [];
all_arms_qths_all_sims = [];
all_arms_stahlbuhk_all_sims = [];

% Loop through each .mat file and extract q_regret and qths_regret
for i = 1:length(matdata_files)
    % Load the .mat file
    load(matdata_files(i).name);  % Load the data for the current simulation
    
    % Check if q_regret exists in the current file
    if exist('q_regret', 'var')
        % Store q_regret for this simulation
        q_regret_all_sims(:, i) = q_regret;  % Assuming q_regret is a vector with size [T, 1]
    else
        warning(['q_regret not found in ' matdata_files(i).name]);
    end

    % Check if q_regret_qths exists in the current file
    if exist('q_regret_qths', 'var')
        % Store q_regret for this simulation
        q_regret_qths_all_sims(:, i) = q_regret_qths;  % Assuming q_regret is a vector with size [T, 1]
    else
        warning(['q_regret_qths not found in ' matdata_files(i).name]);
    end

    %Check if q_regret_stahlbuhk exists in the current file
    if exist('q_regret_stahlbuhk', 'var')
        % Store q_regret for this simulation
        q_regret_stahlbuhk_all_sims(:, i) = q_regret_stahlbuhk;  % Assuming q_regret is a vector with size [T, 1]
    else
        warning(['q_regret_stahlbuhk not found in ' matdata_files(i).name]);
    end

    % Check if samplemean exists in the current file
    if exist('sample_mean_per_arm', 'var')
        % Store q_regret for this simulation
        mean_service_per_arm_all_sims(i,:) = sample_mean_per_arm;
    else
        warning(['sample_mean_per_arm not found in ' matdata_files(i).name]);
    end

    % Check if arrival exists in the current file
    if exist('A', 'var')
        % Store q_regret for this simulation
        per_block_mean_arrival_all_sims(i,:) = chunked_mean(A,T,m);  
    else
        warning(['Arrival data not found in ' matdata_files(i).name]);
    end
    
end
% Sample mean per arm
sample_mean_per_arm_avg = mean(mean_service_per_arm_all_sims,1);

% mean arrival 
per_block_arrival_avg = mean(per_block_mean_arrival_all_sims,1);

% Calculate the average q_regret across all simulations
q_regret_avg = mean(q_regret_all_sims, 2);  % Take the mean across columns (simulations)
q_regret_qths_avg = mean(q_regret_qths_all_sims,2); 
q_regret_stahlbuhk_avg = mean(q_regret_stahlbuhk_all_sims,2);

% Plot the average q_regret using the existing plot_regret function
disp('Plotting the averaged Q-Regret...');

% Assuming T is the length of q_regret
plot_regret(length(q_regret_avg), q_regret_avg,m,q_regret_qths_avg,q_regret_stahlbuhk_avg,[],[14 14 14 14], true, true, true, breakpoints);

writematrix(q_regret_avg, 'results/avg_q_regret.csv');
writematrix(q_regret_qths_avg,'results/avg_qths_regret.csv');
writematrix(q_regret_stahlbuhk_avg, 'results/avg_stahlbuhk_regret.csv');