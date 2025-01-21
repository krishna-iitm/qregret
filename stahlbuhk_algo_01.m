% Original algorithm given in their paper which achieves Theorem 4 (Fig7 and Fig8)
function [Q, arm_choices, channel_gains] = stahlbuhk_algo_01(N, T, rewards, A)
    % Initialize global estimates
    global_mu_hat = zeros(1, N); % Global service rate estimates (initially 0)
    
    Q = zeros(1, T);  % Queue
    current_queue = 0;

    is_first_empty_slot = true; % Flag for the first time slot of an empty period
    busy_period_number = 0;
    busy_period_entrytime=0;
    busy_period_slot_num=0;
    is_busy_period_over = 1;

    busy_period_lengths = zeros(1,T);

    % Count number of used sample observations
    no_of_explorations = zeros(1,N);
    % Initialize variables for tracking arm choices and channel gains
    arm_choices = zeros(1, T);
    channel_gains = zeros(1, T);
    
    % Total rewards accrued by each arm during exploration (used for
    % calculating mu_hat)
    total_mu = zeros(1,N);
    t = 1; % Manually controlling the loop variable
    
    while t <= T
        % Check if the queue is empty
        if current_queue == 0  % Empty period
            if is_first_empty_slot
                % Perform exploration in the first slot of the empty period
                
                % Randomly pick a server and update the global estimate
                server = randi(N);
                arm_choices(t) = server;
                channel_gains(t) = rewards(server, t);

                % Update total_mu
                no_of_explorations(server) = no_of_explorations(server) + 1;
                total_mu(server) = total_mu(server) + rewards(server,t);
                global_mu_hat(server) = total_mu(server)/no_of_explorations(server);

                % Update queue (using the random server selected)
                current_queue = max(0, current_queue - rewards(server, t)) + A(t);
                Q(t) = current_queue;
                
                % Move to the next time slot
                t = t + 1;
                is_first_empty_slot = false;  % After the first slot, set flag to false
                continue;

            else
                % Do nothing during the remaining time slots of empty period
                current_queue = current_queue +A(t);  % Update the queue
                Q(t) = current_queue;
                % Move to the next time slot
                t = t + 1;
                continue;
            end
        else  % Busy period
            
            if is_busy_period_over

                % new busy period
                busy_period_number = busy_period_number + 1;
                
                busy_period_entrytime = t;
                busy_period_slot_num = 1;
            end
                
            if busy_period_slot_num <= busy_period_number %the threshold p
                
                % Select the server with the largest global service rate estimate
                [~, server] = max(global_mu_hat);
    
                % Schedule the selected server
                arm_choices(t) = server;
                channel_gains(t) = rewards(server, t);

                
                
                % Update Queue
                current_queue = max(0, current_queue - rewards(server, t)) + A(t);
                Q(t)=current_queue;

                if (current_queue ==0)
                    is_busy_period_over = 1;
                    busy_period_lengths(busy_period_number)= t - (busy_period_entrytime -1);
                    is_first_empty_slot = true;
                else
                    % busy not over
                    is_busy_period_over = 0;
                    busy_period_slot_num = busy_period_slot_num + 1;
                end
                
                t=t+1;
                continue;

            else 
                % In the event of busy_period_slot_num > p, call
                % learning algorithm
           
                [queue_temp,arms_temp, curr_time_slot] = learning_subroutine(t, N, T, rewards, A, current_queue);
                current_queue = 0;
                % Update the queue
                Q(t: (t + length(queue_temp) - 1)) = queue_temp;
                
                % Update arm choices
                arm_choices(t:curr_time_slot) = arms_temp;
                
                % Update channel gains for the selected arms
                for k = t:curr_time_slot
                    channel_gains(k) = rewards(arms_temp(k-t+1),k);
                end
                
                % Update time slot and other variables
                t = curr_time_slot + 1;
                is_busy_period_over = 1;
                busy_period_lengths(busy_period_number) = t - (busy_period_entrytime - 1);
                is_first_empty_slot = true;

                continue;
            end
        end

    end

end


function [Q, armchoices, t] = learning_subroutine(t, N, T, rewards, A, current_queue)

    % Initialize local estimates for this busy period
    total_mu_p = zeros(1,N);
    mu_hat_p = zeros(1, N); % Local service rate estimates for the current busy period
    V = 0; % Keep track of the number of exploration time slots
    n = 1;
    Q=[];
    armchoices = [];
    no_of_explorations = zeros(1,N);
    % We keep running until the queue becomes empty
    while current_queue > 0

        % Exploration vs exploitation decision based on the time slot
        if is_exploration_time(n-1)
            % Exploration phase: Choose a random arm
            selected_arm = randi(N);  % Random arm chosen uniformly
            
            % Update the local estimate for the selected server
            no_of_explorations(selected_arm) = no_of_explorations(selected_arm) + 1;
            total_mu_p(selected_arm) = total_mu_p(selected_arm) + rewards(selected_arm, t);
            mu_hat_p(selected_arm) = total_mu_p(selected_arm)/no_of_explorations(selected_arm);
            

            % Increment the count for exploration time slots
            V = V + 1;
            
        else
            % Exploitation phase: Use the arm with the highest local estimate
            [~, selected_arm] = max(mu_hat_p);  % Select the arm with the largest local service estimate
              
        end
        
        % Arm choice update
        armchoices(n) = selected_arm;

        % Update Queue
        current_queue = max(0, current_queue - rewards(selected_arm, t)) + A(t);
        Q(n) = current_queue;

        if (current_queue == 0)
            return
        end

        % Update internal and main timeslots
        if (t==T)
            return
        end

        t=t+1;
        n=n+1;
    end

end

% Helper function to determine if it is an exploration time
function is_explore = is_exploration_time(n)
    % Check if the number is a perfect square
    if n < 0
        isPerfectSquare = false;  % Negative numbers cannot be perfect squares
    else
        sqrt_n = sqrt(n);
        tolerance = 1e-10;  % Small tolerance for floating-point comparison
        isPerfectSquare = abs(sqrt_n - round(sqrt_n)) < tolerance;  % Check if sqrt_n is close to an integer
    end
    is_explore = isPerfectSquare;
end
