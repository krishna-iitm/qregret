% Main script 
clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameters
N = 5;         % Number of arms (channels)
T = 10^4;       % Number of time steps
m = 5;             % Number of blocks for non-stationary rewards
a = 0;         % Min range for lambda per block
b = 1;         % Max range for lambda per block
dist_type = 'uniform'; % Distribution type for rewards (as of now go with uniform)

%calc gamma
gamma=min(1,sqrt(N)*T^(-0.25));

G = N/gamma;   % Upper bound on the gain norm (can be adjusted)

%calculate eta (step size) based on the formula provided
eta = sqrt(2) / (G * sqrt(T));

%initialize the probability distribution over arms 
p_init = ones(1, N) / N;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate non-stationary rewards
% [rewards,sample_mean_per_arm] = generate_non_stationary_rewards(N, T, m, dist_type, a, b);
[rewards,sample_mean_per_arm] = non_stat_channel_mult(N,T,m);

max_serv_rate = max(mean(sample_mean_per_arm, 2));
rho = 0.00 %load factor
% simulate the arrival process (random for now)
A = 0+(2*(max_serv_rate+0.1))*rand(1, T);  % Arrival
% A =rand(1, T);
disp('Mean Arrival:');
display(mean(A));

%simulate the queue evolution for all arms and get cumulative service
[all_arms_queue_evolutions, cumulative_service] = simulate_queues_and_cumulative_service(N, T, rewards, A);

% Run our algorithm
[queue_evolution_algo, p, arm_choices_algo,channel_gains_algo] = our_algorithm(N, T, rewards, A, eta, p_init,gamma);
[queue_evolution_qths, queue_evolution_qths_opt, theta_qths, arm_choices_qths, channel_gains_qths, optimal_arm_qths] = q_ths_algorithm(N, T, rewards, A, p_init, sample_mean_per_arm);

optimal_arm =0;
max_regret= -inf;

% loop over all arms and calculate the regret for the entire time period
for arm = 1:N
    regret = max(queue_evolution_algo - all_arms_queue_evolutions(arm, :));
    if regret > max_regret
        max_regret = regret;
        optimal_arm = arm; 
    end
end

% q_regret is the max over all time, difference between the algorithm's queue and the optimal arm's queue
q_diff_algo = queue_evolution_algo - all_arms_queue_evolutions(optimal_arm, :);
q_regret = cummax(q_diff_algo);

%q_regret Q-ThS
q_diff_qths = queue_evolution_qths - queue_evolution_qths_opt;
q_regret_qths = q_diff_qths;

% Cummulative channel gains
cum_ch_gain_algo = cumsum(channel_gains_algo);

% %plot the queue evolution for each arm (simulated)
% plot_simulated_queues(N, T, all_arms_queue_evolutions,m, sample_mean_per_arm, mean(A));
% 
% %plot the queue evolution for the arm selected by the learning algorithm
% plot_algorithm_queue_evolution(T, queue_evolution_algo, all_arms_queue_evolutions(optimal_arm,:),m, optimal_arm);
% % 
% %plot cumulative service offered by each arm
% plot_cumulative_service_offered(N, T, rewards, cum_ch_gain_algo(1,T));
% 
% % plot the arrival process (A(t)) over time
% plot_arrivals(T, A);
% 
% %plot the regret over time (comparison of algorithm's arm and optimal arm)
plot_regret(T, q_regret,m,q_regret_qths);
plot_diff_regret(T,N,queue_evolution_algo, all_arms_queue_evolutions, queue_evolution_qths, queue_evolution_qths_opt);
% 
% plot_cum_ch_gain_regret(T,N,cum_ch_gain_algo, rewards, m);
% plot_rewards(rewards,N);
% save2pdf;