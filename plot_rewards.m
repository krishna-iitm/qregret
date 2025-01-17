%Fucntion: To plot non-stationary rewards over time T
function plot_rewards(rewards,N)
% Plotting the rewards for each arm over time
figure;

hold on;

% Plot rewards..
for arm = 1:N 
    plot(rewards(arm, :), 'DisplayName', ['Arm ' num2str(arm)]);
end

xlabel('Time Step (t)');
ylabel('Reward');
legend;
title('Non-Stationary Rewards for N Arms over Time');
hold off;