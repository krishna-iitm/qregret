% Main script for Monte Carlo simulations
clear;

% Define the 'results' directory path
resultsDir = fullfile(pwd, 'results');

% Check if the 'results' directory exists, if not, create it
if ~exist(resultsDir, 'dir')
    mkdir(resultsDir);
end

% Get the list of all existing subdirectories in the 'results' directory
subdirs = dir(resultsDir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));  % Keep only directories

% Determine the next available folder number (e.g., '01', '02', '03', ...)
if isempty(subdirs)
    nextFolderNumber = 1;  % Start with '01' if no folders exist
else
    existingFolderNumbers = [];
    for i = 1:length(subdirs)
        folderName = subdirs(i).name;
        if ~isempty(folderName) && all(isstrprop(folderName, 'digit'))
            existingFolderNumbers = [existingFolderNumbers, str2double(folderName)];
        end
    end
    if isempty(existingFolderNumbers)
        nextFolderNumber = 1;
    else
        nextFolderNumber = max(existingFolderNumbers) + 1;  % Increment the maximum folder number
    end
end

% Create the new folder with the next available number (e.g., '01', '02', '03', ...)
newFolderName = sprintf('%02d', nextFolderNumber);
newFolderPath = fullfile(resultsDir, newFolderName);
mkdir(newFolderPath);  % Create the new folder

% Create a subfolder for MATLAB data inside the simulation folder (e.g., '01-matlab-data')
matlabDataFolder = fullfile(newFolderPath, [newFolderName, '-matlab-data']);
mkdir(matlabDataFolder);  % Create the subfolder for MATLAB data

% Delete all previous .mat files from previous runs in the MATLAB data folder
old_mat_files = dir(fullfile(matlabDataFolder, 'simulation_data_*.mat'));  % List all .mat files in the subfolder

for k = 1:length(old_mat_files)
    delete(fullfile(matlabDataFolder, old_mat_files(k).name));  % Delete each file
    disp(['Deleted previous simulation data: ', old_mat_files(k).name]);
end
clear i;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Parameters
N = 5;         % Number of arms (channels)
T = 10^4;       % Number of time steps

% Stationarity control
m = 2;             % Number of blocks for non-stationary rewards

isCustomBreakPointsNeeded = true;
breakpoints = [1 1000 10000];


% Calculate gamma
gamma = min(1, sqrt(N) * T^(-0.25));

G = N / gamma;   % Upper bound on the gain norm (can be adjusted)

% Calculate eta (step size) based on the formula provided
eta = sqrt(2)/ (G * sqrt(T));

% Initialize the probability distribution over arms 
p_init = ones(1, N) / N;

% Parameters for non-stationary rewards
a = 0;         % Min range for lambda per block
b = 1;         % Max range for lambda per block
dist_type = 'uniform'; % Distribution type for rewards (as of now go with uniform)

num_of_sim = 500; % Number of MonteCarlo simulations to run and take average.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop for multiple Monte Carlo simulations
for sim_num = 1:num_of_sim
    % progressbar(sim_num/num_of_sim);
    disp(['Running simulation ' num2str(sim_num)]);

    % Clear previous simulation variables. To avoid consuming more memory.
    if sim_num > 1
        clear all_arms_queue_evolutions cumulative_service queue_evolution_algo A rewards p arm_choices_algo channel_gains_algo optimal_arm max_regret q_diff_regret q_regret cum_ch_gain_algo queue_evolution_qths queue_evolution_qths_opt theta_qths arm_choices_qths channel_gains_qths optimal_arm_qths q_regret_qths q_diff_regret ;
        clear q_regret_stahlbuhk q_evolution_stahlbuhk per_block_sample_mean sample_mean_per_arm max_serv_rate arm_choices_stahlbuhk, channel_gains_stalbuhk; 
        clear j_star;
    end

    % Generate non-stationary rewards
    if isCustomBreakPointsNeeded
        m = length(breakpoints) - 1;
        [rewards, sample_mean_per_arm, per_block_sample_mean] = non_stat_channel_mult_custombreakpoint(N, T,breakpoints);
    else
        [rewards, sample_mean_per_arm, per_block_sample_mean] = non_stat_channel_mult(N, T,m);
    end
    
    max_serv_rate = max(mean(sample_mean_per_arm, 2));

    % Simulate the arrival process 
    A = 0+(2*(max_serv_rate-0.15))*rand(1, T);  % Arrival
    disp('Mean Arrival:');
    display(mean(A));

    % Simulate the queue evolution for all arms and get cumulative service
    [all_arms_queue_evolutions, cumulative_service] = simulate_queues_and_cumulative_service(N, T, rewards, A);

    % Run the algorithm
    [queue_evolution_algo, p, arm_choices_algo, channel_gains_algo] = our_algorithm(N, T, rewards, A, eta, p_init, gamma);
    [queue_evolution_qths, queue_evolution_qths_opt, theta_qths, arm_choices_qths, channel_gains_qths, optimal_arm_qths] = q_ths_algorithm(N, T, rewards, A, p_init, sample_mean_per_arm);
    [queue_evolution_stahlbuhk, arm_choices_stahlbuhk, channel_gains_stalbuhk] = stahlbuhk_algo_01(N,T,rewards,A);

    [~, j_star] = max(sample_mean_per_arm);
    q_regret = queue_evolution_algo - all_arms_queue_evolutions(j_star,:);
    q_diff_qths = queue_evolution_qths - all_arms_queue_evolutions(j_star,:);
    q_regret_qths = q_diff_qths;
    q_regret_stahlbuhk = queue_evolution_stahlbuhk - all_arms_queue_evolutions(j_star,:);

    % Define the filename based on the current simulation number
    filename = ['simulation_data_' num2str(sim_num) '.mat'];
    
    % Save the variables to the MATLAB data folder inside the new folder
    save(fullfile(matlabDataFolder, filename));  % Save all variables in the subfolder
end

% Call the plotting and saving function after simulations
close all;
read_n_plot_avg_qregret;
save2pdf(newFolderPath);
