%Expects queue_lengths of size NxT
function optimal_arm = select_optimal_arm(queue_lengths)
    % Select the arm with the minimum total queue length over all time
    total_queue_lengths = sum(queue_lengths, 2);
    [~, optimal_arm] = min(total_queue_lengths); % Find the arm with the minimum sum of queues
end