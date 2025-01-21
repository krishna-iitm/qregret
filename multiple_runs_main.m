% Main script for Monte Carlo simulations
clear;
% Delete all previous .mat files from previous runs
old_mat_files = dir('simulation_data_*.mat');  % List all .mat files with this pattern

for k = 1:length(old_mat_files)
    delete(old_mat_files(k).name);  % Delete each file
    disp(['Deleted previous simulation data: ', old_mat_files(k).name]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Main Parameters
N = 5;         % Number of arms (channels)
T = 10^4;       % Number of time steps
m = 2;             % Number of blocks for non-stationary rewards
% Calculate gamma
gamma = min(1, sqrt(N) * T^(-0.25));

G = N / gamma;   % Upper bound on the gain norm (can be adjusted)

% Calculate eta (step size) based on the formula provided
eta = sqrt(2)/ (G * sqrt(T));

% Initialize the probability distribution over arms 
p_init = ones(1, N) / N;

% Parameters for 
a = 0;         % Min range for lambda per block
b = 1;         % Max range for lambda per block
dist_type = 'uniform'; % Distribution type for rewards (as of now go with uniform)

% mu_per_block=[0.7 0.6 0.5; 0.3 0.3 0.3; 0.1 0.9 0.2; 0.2 0.95 0.8; 0.7 0.2 0.4];
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
    % [rewards,sample_mean_per_arm, per_block_sample_mean] = generate_non_stationary_rewards(N, T, m, dist_type,mu_per_block);
    [rewards, sample_mean_per_arm, per_block_sample_mean] = non_stat_channel_mult(N, T,m);
    breakpoints = [1, 1000, 10000];
    [rewards, sample_mean_per_arm, per_block_sample_mean] = non_stat_channel_mult_custombreakpoint(N,T,breakpoints);
    % Simulate the arrival process 
    max_serv_rate = max(mean(sample_mean_per_arm, 2));

    % simulate the arrival process (random for now)
    A = 0+(2*(max_serv_rate-0.25))*rand(1, T);  % Arrival
    % A=2*(0.50)*rand(1,T);
    % A = rand(1, T);  % Arrival
    disp('Mean Arrival:');
    display(mean(A));

    % Simulate the queue evolution for all arms and get cumulative service
    [all_arms_queue_evolutions, cumulative_service] = simulate_queues_and_cumulative_service(N, T, rewards, A);

    % Run the algorithm
    [queue_evolution_algo, p, arm_choices_algo, channel_gains_algo] = our_algorithm(N, T, rewards, A, eta, p_init, gamma);
    [queue_evolution_qths, queue_evolution_qths_opt, theta_qths, arm_choices_qths, channel_gains_qths, optimal_arm_qths] = q_ths_algorithm(N, T, rewards, A, p_init, sample_mean_per_arm);
    [queue_evolution_stahlbuhk, arm_choices_stahlbuhk, channel_gains_stalbuhk] = stahlbuhk_algo_01(N,T,rewards,A);

    
    % % Initialize variables for optimal arm selection
    % optimal_arm = 0;
    % max_regret = -inf;

    % %Loop over all arms and calculate the regret for the entire time period
    % for arm = 1:N
    %     regret = max(queue_evolution_algo - all_arms_queue_evolutions(arm, :));
    %     if regret > max_regret
    %         max_regret = regret;
    %         optimal_arm = arm; 
    %     end
    % end

    % q_regret is the max over all time, difference between the algorithm's queue and the optimal arm's queue
    % q_diff_regret = queue_evolution_algo - all_arms_queue_evolutions(optimal_arm, :);
    % q_regret = (q_diff_regret);

    [~, j_star] = max(sample_mean_per_arm);
    q_regret = queue_evolution_algo - all_arms_queue_evolutions(j_star,:);
   
    %q_regret Q-ThS
    q_diff_qths = queue_evolution_qths - all_arms_queue_evolutions(j_star,:);
    q_regret_qths = q_diff_qths;
    
    % Stahlbuhk
    q_regret_stahlbuhk = (queue_evolution_stahlbuhk) - (all_arms_queue_evolutions(j_star,:));
    q_regret_stahlbuhk = q_regret_stahlbuhk;

    % Define the filename based on the current simulation number
    filename = ['simulation_data_' num2str(sim_num) '.mat'];

    % Check if the file exists
    if exist(filename, 'file') == 2  % 'file' means checking for a file
        delete(filename);  % Delete the file if it already exists...
        disp(['Deleted previous simulation data: ', filename]);
    else
        %do nothing
    end

    % Save all variables for this simulation
    save([filename]);  % Save all variables
    
end

% Now RUN read_n_plot_avg_qregret.m to load and plot the avg q-regret