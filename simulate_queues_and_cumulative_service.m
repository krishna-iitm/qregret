%simulating all queues to find the optimal channel i 
%optimal i is the one that maximizes q-regret?
%\
function [all_arms_queue_evolutions, cumulative_service] = simulate_queues_and_cumulative_service(N, T, rewards, A)
    %initialize matrices to store the queue evolution, cumulative service, and queue lengths
    all_arms_queue_evolutions = zeros(N, T);  % Queue evolution for each arm over time
    cumulative_service = zeros(N, T);         % Cumulative service for each arm over time
    % queue_lengths = zeros(N, T);              % Final queue length for
    % each arm -- %%Already there

    %simulate the queue evolution for each arm
    for arm = 1:N
        current_queue = 0;
        for t = 1:T
            S_t = rewards(arm, t);  % Service rate for the current arm
            A_t = A(t);              % Arrival at time t
            all_arms_queue_evolutions(arm, t) = max(0, current_queue + A_t - S_t);  % Queue evolution equation
            current_queue = all_arms_queue_evolutions(arm, t);  % Update the current queue
            
            %(sum of rewards up to time t)
            cumulative_service(arm, t) = sum(rewards(arm, 1:t));  
        end
        % queue_lengths(arm, :) = all_arms_queue_evolutions(arm, :);
    end
end