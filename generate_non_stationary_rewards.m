% Function to generate non-stationary rewards for N arms over T rounds
function [rewards,sample_mean_per_arm, sample_means] = generate_non_stationary_rewards(N, T, m, dist_type,mu_per_block)
    % N: Number of arms
    % T: Total number of rounds
    % m: Number of blocks (divisions)
    % dist_type: Type of distribution ('poisson', 'bernoulli', 'uniform', 'exprnd')
    
    %initialize reward matrix
    rewards = zeros(N, T);
    
    %divide time T into m blocks
    block_size = floor(T / m);  % Size of each block
    
    %generate a random rate (lambda) for each arm and each block (if needed)
    
    lambda = rand(N, m);  % Random rates for each arm and each block
    % disp('Lambda per block')
    % display(lambda);
    % disp('Mean lambda per arm')
    % display(mean(lambda,2))

    %sample mean variable
    sample_means = zeros(N,m);

    % generate rewards for each arm and each round
    for arm = 1:N
        for block = 1:m
            %starting and ending indices of the current block
            start_idx = (block - 1) * block_size + 1;
            if block == m
                end_idx = T;  % Ensure we cover the remaining
            else
                end_idx = block * block_size;
            end
            
            %generate rewards based on the chosen distribution type
            switch dist_type
                case 'poisson'
                    %generate Poisson distributed rewards with mean lambda
                    block_rewards = poissrnd(lambda(arm, block), 1, end_idx - start_idx + 1);
                
                case 'bernoulli'
                    %generate Bernoulli distributed rewards (binary rewards)
                    p = 1 / (1 + exp(-lambda(arm, block))); 
                    block_rewards = rand(1, end_idx - start_idx + 1) < p;
                
                case 'uniform'
                    % generate uniformly distributed rewards in the range [0, 1]
                    % block_rewards = 2*lambda(arm,block) * rand(1, end_idx - start_idx + 1);
                    block_rewards = unifrnd(0,2*mu_per_block(arm,block),[1,end_idx - start_idx + 1]);
                
                case 'exprnd'
                    %generate Exponential-distributed rewards with rate lambda
                    block_rewards = exprnd(1 / lambda(arm, block), 1, end_idx - start_idx + 1);
                
                otherwise
                    error('Distribution type: Not yet written %s', dist_type);
            end
            %
            % Truncate the rewards to [0, 1] (for cases like poisson or exponential)
            rewards(arm, start_idx:end_idx) = min(block_rewards, 1);
            sample_means(arm,block) = mean(rewards(arm,start_idx:end_idx), 2);
        end
    end
    disp('Sample Mean')
    display(sample_means);
    sample_mean_per_arm = mean(sample_means,2);
    disp('Avg sample mean per arm')
    display(sample_mean_per_arm );
    
end