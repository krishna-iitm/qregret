function [queue_length_algo, p, arm_choices, channel_gains_algo] = our_algorithm(N, T, rewards, A, eta, p_init, gamma)
    % Initialize the probability distribution
    p = p_init;  % Initial uniform probability dist.
    
    % Initialize queue lengths for both the algorithm and optimal arm
    queue_length_algo = zeros(1, T); % Queue evolution for the our algorithm
    
    current_queue_algo = 0;  
    
     % store the choices of arms at each time step
    arm_choices = zeros(1, T); 
    channel_gains_algo = zeros(1,T);
    
    for t = 1:T
        % 1. exploration vs exploitatio
        J_t = select_arm_with_exploration(p, gamma, N); 
        
        % Store the chosen arm for tracking
        arm_choices(t) = J_t;
        
        % 2.calculate the reward (service rate) for the selected arm
        selected_arm_reward = rewards(J_t, t);
        
        % 3.update the queue for the selected arm 
        current_queue_algo = max(0, current_queue_algo + A(t) - selected_arm_reward);
        
        % 4.queue evolution for the learning algorithm's selected arm
        queue_length_algo(t) = current_queue_algo; 
        
        % 5.calculate the gain vector (using rewards as a placeholder)
        g_t = zeros(1, N); % Initialize the gain vector for all arms
        g_t(J_t) = selected_arm_reward;  % Assign the reward to the selected arm
        
        %6.estimate the gain vector: \hat{g}_{t,i} = g_{t,i} / P(J_t = i)

        p_t = (1 - gamma) * p(J_t) + gamma / N; % Probability for the selected arm
        hat_g_t = g_t / p_t;  % Estimate the gain for the selected arm
        
        % 07.update the probability distribution using the Euclidean projection
        p = update_probability_distribution(p, hat_g_t, eta);
        
        %8.update the total service offered by summing the reward of the selected arm
        channel_gains_algo(t) = selected_arm_reward;  % Accumulate the service
    end
end

function J_t = select_arm_with_exploration(p, gamma, N)
    % With probability gamma, choose uniformly at random (exploration)
    if rand <= gamma
        J_t = randi(N);  % Uniform
    else
        % With probability 1 - gamma, select based on the current probability distribution
        J_t = find(rand <= cumsum(p), 1);  %based on current probability p
    end
end
