 function [Q, arm_choices, channel_gains] = stahlbuhk_algo_02(N, T, rewards, A)
    % Initialize global estimates
    global_mu_hat = zeros(1, N); % Global service rate estimates (initially 0)
    
    Q = zeros(1, T);  % Queue
    current_queue = 0;

    busy_period_number = 0;
    busy_period_entrytime = 0;
    busy_period_slot_num = 0;
    is_busy_period_over = 1;

    busy_period_lengths = zeros(1,T);

    % Count number of used sample observations
    no_of_observations = zeros(1, N);
    % Initialize variables for tracking arm choices and channel gains
    arm_choices = zeros(1, T);
    channel_gains = zeros(1, T);
    
    % Total rewards accrued by each arm during exploration (used for calculating mu_hat)
    total_mu = zeros(1, N);
    
    t = 1; % Manually controlling the loop variable
    
    % Step 1: Initial N explorations where queue is kept at zero
    while t <= N
        % Randomly pick a server to explore and update mu_hat
        server = t;  % Choose arms independently in the first N slots
        arm_choices(t) = server;
        channel_gains(t) = rewards(server, t);

        % Update the observation count and mu_hat for the selected server
        no_of_observations(server) = no_of_observations(server) + 1;
        total_mu(server) = total_mu(server) + rewards(server, t);
        global_mu_hat(server) = total_mu(server) / no_of_observations(server);

        % Since we're in the exploration phase, the queue remains zero
        current_queue = 0;
        Q(t) = current_queue;  % Keep the queue at zero

        % Move to the next time slot
        t = t + 1;
    end
    
    % Step 2: Now handle the busy periods and queue management
    while t <= T
        % Check if the queue is empty
        if current_queue == 0  % Empty period
            
            % Perform exploration in all slots of the empty period
            server = randi(N);
            arm_choices(t) = server;
            channel_gains(t) = rewards(server, t);

            % Update mu_hat
            no_of_observations(server) = no_of_observations(server) + 1;
            total_mu(server) = total_mu(server) + rewards(server, t);
            global_mu_hat(server) = total_mu(server) / no_of_observations(server);

            % Update queue (using the random server selected)
            current_queue = max(0, current_queue - rewards(server, t) + A(t));
            Q(t) = current_queue;
            
            % Move to the next time slot
            t = t + 1;
            continue;

        else  % Busy period
            
            if is_busy_period_over
                % new busy period
                busy_period_number = busy_period_number + 1;
                busy_period_entrytime = t;
                busy_period_slot_num = 1;
            end
                
            if busy_period_slot_num <= busy_period_number % the threshold p
                
                % Select the server with the largest global service rate estimate
                [~, server] = max(global_mu_hat);
                
                % Update the mu_hat
                no_of_observations(server) = no_of_observations(server) + 1;
                total_mu(server) = total_mu(server) + rewards(server, t);
                global_mu_hat(server) = total_mu(server) / no_of_observations(server);

                % Schedule the selected server
                arm_choices(t) = server;
                channel_gains(t) = rewards(server, t);

                % Update Queue
                current_queue = max(0, current_queue - rewards(server, t) + A(t));
                Q(t) = current_queue;

                if (current_queue == 0)
                    is_busy_period_over = 1;
                    busy_period_lengths(busy_period_number) = t - busy_period_entrytime - 1;
                else
                    % busy not over
                    is_busy_period_over = 0;
                    busy_period_slot_num = busy_period_slot_num + 1;
                end
                
                t = t + 1;
                continue;

            else 
                % In the event of busy_period_slot_num > p, use UCB1 weight to sample the server
                while current_queue > 0
                    ucb1_w = zeros(1, N);
                    for i = 1:N
                        ucb1_w(i) = global_mu_hat(i) + sqrt((2 * log(t + 1)) / no_of_observations(i));
                    end
                    [~, server] = max(ucb1_w);
                    
                    % Update the mu_hat
                    no_of_observations(server) = no_of_observations(server) + 1;
                    total_mu(server) = total_mu(server) + rewards(server, t);
                    global_mu_hat(server) = total_mu(server) / no_of_observations(server);
                    
                    % Schedule the selected server
                    arm_choices(t) = server;
                    channel_gains(t) = rewards(server, t);
    
                    % Update Queue
                    current_queue = max(0, current_queue - rewards(server, t) + A(t));
                    Q(t) = current_queue;

                    if (current_queue == 0)
                        break;
                    end

                    t = t + 1;
                    if(t>T)
                        break;
                    end
                    
                end
                
                is_busy_period_over = 1;
                busy_period_lengths(busy_period_number) = t - busy_period_entrytime - 1;
                continue;
            end
        end
    end
end
