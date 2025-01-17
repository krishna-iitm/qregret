function [queue_length_ths, queue_length_ths_opt, theta_hat, arm_choices_ths, channel_gains_ths, optimal_arm_ths, mu_hat] = q_ths_algorithm(N, T, rewards, A, p_init, sample_mean_per_arm)
    % Initialize the probability distribution
    p_ths = p_init;  % Initial uniform probability distribution

    % Initialize queue lengths for Q-ThS algorithm
    queue_length_ths = zeros(1, T); % Queue evolution for the Q-ThS algorithm
    queue_length_ths_opt = zeros(1,T); % Queue evolution for the Q_opt algorithm(max service rate)
    
    current_queue_ths = 0;  % Initialize the queue for the Q-ThS algorithm
    current_queue_ths_opt = 0;

    % Find optimal arm from the service rate
    [~, j_star_qths] = max(sample_mean_per_arm);
    optimal_arm_ths = j_star_qths;

    % Store the choices of arms at each time step
    arm_choices_ths = zeros(1, T); 
    channel_gains_ths = zeros(1, T);  % Cumulative service offered by the selected arm
    
    % Initialize variables for theta estimate, arm counts, and total rewards
    arm_counts = zeros(1, N);  % Counts for how many times each arm is chosen
    total_rewards = zeros(1, N); % Total reward accumulated by each arm
    mu_hat = zeros(1, N);  % Estimated mean reward for each arm

    % Loop through time steps
    for t = 1:T
        % Exploration vs exploitation decision based on Bernoulli sample E(t)
        E_t = rand <= min(1, 3 * N * (log(t)^2) / t); % Bernoulli random variable
        
        if E_t == 1
            % Exploration phase: Choose a random arm
            J_t = randi(N);  % Random arm chosen uniformly
            
        else
            % Exploitation phase: Pick the arm with the highest estimated reward
            theta_hat = zeros(1, N);
            for k = 1:N
                % Update the estimated mean reward using the Beta distribution parameters
                
                theta_hat(k) = betarnd(mu_hat(k)*arm_counts(k)+1, (1-mu_hat(k))*arm_counts(k) + 1);
            end
            [~, J_t] = max(theta_hat);  % Choose the arm with the highest estimated reward
        end
        
        % Store the chosen arm for tracking
        arm_choices_ths(t) = J_t;
        
        % Get the reward (service rate) for the selected arm
        selected_arm_reward = rewards(J_t, t);
        
        % Update the queue for the selected arm
        current_queue_ths = max(0, current_queue_ths + A(t) - selected_arm_reward);
        current_queue_ths_opt = max(0, current_queue_ths_opt + A(t) - rewards(j_star_qths, t));

        % Queue evolution for the learning algorithm's selected arm
        queue_length_ths(t) = current_queue_ths; 
        queue_length_ths_opt(t) = current_queue_ths_opt;

        % Update arm counts and total rewards (for Beta distribution)
        arm_counts(J_t) = arm_counts(J_t) + 1;
        total_rewards(J_t) = total_rewards(J_t) + selected_arm_reward;

        % Update the mean estimate for each arm (mu_hat)
        mu_hat = total_rewards / t;

        % Calculate the cumulative channel gains (service)
        channel_gains_ths(t) = selected_arm_reward;
    end
end
