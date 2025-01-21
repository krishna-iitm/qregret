% % Generating autoregressive channel
% function [rewards,sample_mean_per_arm] = non_stat_channel_mult(N, T)
% 
% c=zeros(N,T);
% c(:,1)=rand(N,1);
% alpha=rand(N,1); % channel gain for one particular channel
% for t=1:T-1
%     c(:,t+1)=max(0,min(1,alpha.*c(:,t)+2*(rand(N,1)-0.5)));
% end
% rewards=c;
% d=c';
% sample_mean_per_arm = mean(d(:,:))
% 

% plot(c(1,:));


function [rewards, sample_mean_per_arm, per_block_sample_mean] = non_stat_channel_mult(N, T, m)
    % N: Number of arms (channels)
    % T: Number of time steps
    % m: Number of blocks to divide time T into

    % Initialize the reward matrix
    c = zeros(N, T);

    % Set initial rewards (at time t=1) to random values between 0 and 1
    c(:, 1) = rand(N, 1);

    % Number of time steps in each block
    block_size = floor(T / m);  % Size of each block

    % Initialize channel gain coefficient
    alpha = rand(N, 1);  % Initial channel gain values for all arms

    % Sample means storage
    sample_means = zeros(N, m);  % To store the sample mean for each arm per block

    % Divide time T into m blocks and adjust alpha for each block
    for block = 1:m
        % Starting and ending indices of the current block
        start_idx = (block - 1) * block_size + 1;
        if block == m
            end_idx = T;  % Ensure we cover the remaining time steps in the last block
        else
            end_idx = block * block_size;
        end

        % Update alpha for the current block 
        alpha = 2*rand(N, 1);  % Randomize alpha for this block

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
    % for i=1:N
    %     plot(c(i,:));
    %     hold on;
    % end
    % Display results 
    % disp('Sample Mean per Arm per Block');
    % disp(sample_means);
    per_block_sample_mean = sample_means;
    % disp('Average Sample Mean per Arm');
    % disp(sample_mean_per_arm);
end
