% Script to load .mat files from the current directory or a specific folder,
% calculate mean q_regret, and plot it

clear all;

% Define the 'results' directory path
resultsDir = fullfile(pwd, 'results');

% Get the list of all subdirectories in the 'results' directory
subdirs = dir(resultsDir);
subdirs = subdirs([subdirs.isdir] & ~ismember({subdirs.name}, {'.', '..'}));  % Keep only directories

% Determine the folder where data is saved
if isempty(subdirs)
    folderToLoadFrom = pwd;  % Fallback to current directory if no subfolders exist
else
    % Extract folder name (assuming it's the most recent folder, e.g., '01', '02', etc.)
    existingFolderNumbers = [];
    for i_1 = 1:length(subdirs)
        folderName = subdirs(i_1).name;
        if ~isempty(folderName) && all(isstrprop(folderName, 'digit'))
            existingFolderNumbers = [existingFolderNumbers, str2double(folderName)];
        end
    end
    nextFolderNumber = max(existingFolderNumbers);  % Most recent folder
    folderToLoadFrom = fullfile(resultsDir, sprintf('%02d', nextFolderNumber), [sprintf('%02d', nextFolderNumber) '-matlab-data']);
end

% Get the list of .mat files from the selected folder (either specific folder or pwd)
matdata_files = dir(fullfile(folderToLoadFrom, 'simulation_data_*.mat'));  % Assumes files are named simulation_data_#.mat

% If no .mat files are found in the folder, fallback to current directory
if isempty(matdata_files)
    disp(['No .mat files found in ', folderToLoadFrom, '. Using current directory.']);
    matdata_files = dir('simulation_data_*.mat');  % Fallback to current directory
end

% Initialize an empty array to store q_regret from each file
q_regret_all_sims = [];
q_regret_qths_all_sims = [];
q_regret_stahlbuhk_all_sims = [];

mean_service_per_arm_all_sims = [];
mean_arrival_all_sims = [];
all_arms_qreg_all_sims = [];
all_arms_qths_all_sims = [];
all_arms_stahlbuhk_all_sims = [];

% Loop through each .mat file and extract q_regret and qths_regret
for i_1 = 1:length(matdata_files)
    % Load the .mat file
    load(fullfile(matdata_files(i_1).folder, matdata_files(i_1).name));  % Load the data for the current simulation
    
    % Check if q_regret exists in the current file
    if exist('q_regret', 'var')
        % Store q_regret for this simulation
        q_regret_all_sims(:, i_1) = q_regret;  % Assuming q_regret is a vector with size [T, 1]
    else
        warning(['q_regret not found in ' matdata_files(i_1).name]);
    end

    % Check if q_regret_qths exists in the current file
    if exist('q_regret_qths', 'var')
        % Store q_regret_qths for this simulation
        q_regret_qths_all_sims(:, i_1) = q_regret_qths;  % Assuming q_regret_qths is a vector with size [T, 1]
    else
        warning(['q_regret_qths not found in ' matdata_files(i_1).name]);
    end

    % Check if q_regret_stahlbuhk exists in the current file
    if exist('q_regret_stahlbuhk', 'var')
        % Store q_regret_stahlbuhk for this simulation
        q_regret_stahlbuhk_all_sims(:, i_1) = q_regret_stahlbuhk;  % Assuming q_regret_stahlbuhk is a vector with size [T, 1]
    else
        warning(['q_regret_stahlbuhk not found in ' matdata_files(i_1).name]);
    end

    % Check if sample_mean_per_arm exists in the current file
    if exist('sample_mean_per_arm', 'var')
        % Store sample_mean_per_arm for this simulation
        mean_service_per_arm_all_sims(i_1,:) = sample_mean_per_arm;
    else
        warning(['sample_mean_per_arm not found in ' matdata_files(i_1).name]);
    end

    % Check if arrival exists in the current file
    if exist('A', 'var')
        % Store mean arrival for this simulation
        per_block_mean_arrival_all_sims(i_1,:) = chunked_mean(A, T, m);  
    else
        warning(['Arrival data not found in ' matdata_files(i_1).name]);
    end
end

% Sample mean per arm
sample_mean_per_arm_avg = mean(mean_service_per_arm_all_sims, 1);

% Mean arrival
per_block_arrival_avg = mean(per_block_mean_arrival_all_sims, 1);

% Calculate the average q_regret across all simulations
q_regret_avg = mean(q_regret_all_sims, 2);  % Take the mean across columns (simulations)
q_regret_qths_avg = mean(q_regret_qths_all_sims, 2); 
q_regret_stahlbuhk_avg = mean(q_regret_stahlbuhk_all_sims, 2);

% Plot the average q_regret using the existing plot_regret function
disp('Plotting the averaged Q-Regret...');

% Assuming T is the length of q_regret
plot_regret(length(q_regret_avg), q_regret_avg, m, q_regret_qths_avg, q_regret_stahlbuhk_avg, [], [14 14 14 14], true, true, false, []);

if isempty(subdirs)
    writematrix(q_regret_avg, 'q_regret_avg.csv');
    writematrix(q_regret_qths_avg, 'q_regret_qths_avg.csv');
    writematrix(q_regret_stahlbuhk_avg, 'q_regret_stahlbuhk.csv');
else
    writematrix(q_regret_avg, fullfile(newFolderPath, 'q_regret_avg.csv'));
    writematrix(q_regret_qths_avg, fullfile(newFolderPath, 'q_regret_qths_avg.csv'));
    writematrix(q_regret_stahlbuhk_avg, fullfile(newFolderPath, 'q_regret_stahlbuhk.csv'));
end

