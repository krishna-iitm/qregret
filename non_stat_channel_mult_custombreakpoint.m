function [rewards, sample_mean_per_arm, per_block_sample_mean] = non_stat_channel_mult_custombreakpoint(N, T, break_points)
    % N: Number of arms (channels)
    % T: Number of time steps
    % break_points: A vector specifying when the breaks should occur

    % Ensure break_points is a valid vector of increasing integers
    if length(break_points) ~= length(unique(break_points)) || any(diff(break_points) <= 0)
        error('break_points must be a vector of unique, strictly increasing integers.');
    end
    
    % Check if break_points covers the entire time range [1, T]
    if break_points(1) ~= 1 || break_points(end) ~= T
        error('break_points must start at 1 and end at T.');
    end

    % Initialize the reward matrix
    c = zeros(N, T);

    % Set initial rewards (at time t=1) to random values between 0 and 1
    c(:, 1) = rand(N, 1);

    % Initialize channel gain coefficient (alpha)
    alpha = rand(N, 1);  % Initial channel gain values for all arms

    % Sample means storage
    m = length(break_points) - 1;  % Number of blocks based on break points
    sample_means = zeros(N, m);  % To store the sample mean for each arm per block

    % Divide time T into blocks based on break points
    for block = 1:m
        % Starting and ending indices of the current block
        start_idx = break_points(block);
        end_idx = break_points(block + 1);

        % Update alpha for the current block 
        alpha = 2 * rand(N, 1);  % Randomize alpha for this block

        % Generate rewards for each arm in this block using autoregressive model
        for t = start_idx:end_idx-1  
            c(:, t+1) = max(0, min(1, alpha .* c(:, t) + 2 * (rand(N, 1) - 0.5)));
        end

        % Store sample mean for the current block
        sample_means(:, block) = mean(c(:, start_idx:end_idx), 2);
    end

    % Final rewards matrix
    rewards = c;

    % Compute the overall sample mean per arm (average over all blocks)
    sample_mean_per_arm = mean(sample_means, 2);

    % Output the per-block sample means as well
    per_block_sample_mean = sample_means;
end
