% Main script for Monte Carlo simulations
clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
N = 5;         % Number of arms (channels)
T = 10^5;       % Number of time steps
m = 5;             % Number of blocks for non-stationary rewards
a = 0;         % Min range for lambda per block
b = 1;         % Max range for lambda per block
dist_type = 'uniform'; % Distribution type for rewards (as of now go with uniform)
num_of_sim = 10; % Number of MonteCarlo simulations to run and take average.
% Calculate gamma
gamma = min(1, sqrt(N) * T^(-0.25));

G = N / gamma;   % Upper bound on the gain norm (can be adjusted)

% Calculate eta (step size) based on the formula provided
eta = sqrt(2) / (G * sqrt(T));

% Initialize the probability distribution over arms 
p_init = ones(1, N) / N;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Loop for multiple Monte Carlo simulations
for sim_num = 1:num_of_sim  
    disp(['Running simulation ' num2str(sim_num)]);

    % Clear previous simulation variables. To avoid consuming more memory.
    if sim_num > 1
        clear all_arms_queue_evolutions cumulative_service queue_evolution_algo A rewards p arm_choices_algo channel_gains_algo optimal_arm max_regret q_diff_regret q_regret cum_ch_gain_algo queue_evolution_qths queue_evolution_qths_opt theta_qths arm_choices_qths channel_gains_qths optimal_arm_qths q_regret_qths q_diff_regret;
    end

    % Generate non-stationary rewards
    [rewards, sample_mean_per_arm] = non_stat_channel_mult(N, T,m);

    % Simulate the arrival process 
    max_serv_rate = max(mean(sample_mean_per_arm, 2));
   
    % simulate the arrival process (random for now)
    A = 0+(2*(max_serv_rate+0.1))*rand(1, T);  % Arrival
    % A = rand(1, T);  % Arrival
    disp('Mean Arrival:');
    display(mean(A));

    % Simulate the queue evolution for all arms and get cumulative service
    [all_arms_queue_evolutions, cumulative_service] = simulate_queues_and_cumulative_service(N, T, rewards, A);

    % Run the algorithm
    [queue_evolution_algo, p, arm_choices_algo, channel_gains_algo] = our_algorithm(N, T, rewards, A, eta, p_init, gamma);
    [queue_evolution_qths, queue_evolution_qths_opt, theta_qths, arm_choices_qths, channel_gains_qths, optimal_arm_qths] = q_ths_algorithm(N, T, rewards, A, p_init, sample_mean_per_arm);

    % Initialize variables for optimal arm selection
    optimal_arm = 0;
    max_regret = -inf;

    % Loop over all arms and calculate the regret for the entire time period
    for arm = 1:N
        regret = max(queue_evolution_algo - all_arms_queue_evolutions(arm, :));
        if regret > max_regret
            max_regret = regret;
            optimal_arm = arm; 
        end
    end

    % q_regret is the max over all time, difference between the algorithm's queue and the optimal arm's queue
    q_diff_regret = queue_evolution_algo - all_arms_queue_evolutions(optimal_arm, :);
    q_regret = cummax(q_diff_regret);
    
    %q_regret Q-ThS
    q_diff_qths = queue_evolution_qths - queue_evolution_qths_opt;
    q_regret_qths = q_diff_qths;

    % Cumulative channel gains
    cum_ch_gain_algo = cumsum(channel_gains_algo);
    
    % plot_regret(T, q_regret,m,q_regret_qths);
    % plot_diff_regret(T,N,queue_evolution_algo, all_arms_queue_evolutions, queue_evolution_qths, queue_evolution_qths_opt);
 
    % Define the filename based on the current simulation number
    filename = ['simulation_data_' num2str(sim_num) '.mat'];
    
    % Check if the file exists
    if exist(filename, 'file') == 2  % 'file' means checking for a file
        delete(filename);  % Delete the file if it already exists...
        disp(['Deleted previous simulation data: ', filename]);
    else
        disp(['No previous simulation data found for ', filename]);
    end

    % Save all variables for this simulation
    save([filename]);  % Save all variables
end

% Now RUN read_n_plot_avg_qregret.m to load and plot the avg q-regret