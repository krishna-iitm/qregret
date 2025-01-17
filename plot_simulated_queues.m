%Function: To plot all channel's evolution
function plot_simulated_queues(N, T, queue_evolutions, m, sample_mean_per_arm, mean_arrival)
    figure;
    hold on;
    
    block_size = floor(T / m);
    
    %  plot handles for legend
    plot_handles = [];
    
    % plot the queue evolution for each arm
    for arm = 1:N
        h = plot(1:T, queue_evolutions(arm, :), 'DisplayName', ['Arm ' num2str(arm) '- Mean Service =' num2str(sample_mean_per_arm(arm)) ], 'LineWidth', 1.5);
        plot_handles = [plot_handles, h];  % Store the plot handle
    end
    
    % alternating colors for the blocks
    colors = [
        0.95, 0.95, 0.95; % White
        0.9, 0.9, 0.9    % Grey
    ];
    
    % Compute the min and max of queue_evolutions and add space for the y-axis
    y_min = min(queue_evolutions(:));
    y_max = max(queue_evolutions(:));
    buffer = 0.1 * (y_max - y_min);  
    y_min_extended = 0;
    y_max_extended = y_max + buffer;
    
    % Set the fixed y-axis limits
    ylim([y_min_extended, y_max_extended]);

    % Plot the transparent rectangular windows for each block with alternating colors
    for block_idx = 1:m
        block_start = (block_idx - 1) * block_size + 1;
        block_end = min(block_idx * block_size, T);  % Ensure block doesn't exceed T
        
        % Alternate colors based on the block index
        color_idx = mod(block_idx, 2) + 1;  %% 1 for white, 2 for Grey
        block_color = colors(color_idx, :); %%Choose Color
        
        % Create a transparent rectangle to highlight the block (using patch)
        x = [block_start, block_end, block_end, block_start];
        y = [y_min_extended, y_min_extended, y_max_extended, y_max_extended];  % Extend y range to fill the plot area
        h = patch(x, y, block_color, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
        
        % Set the rectangle's DisplayName to empty so that it doesnt show up in the legend
        set(h, 'DisplayName', '');
    end
    
    xlabel('Time Step');
    ylabel('Queue Length');
    legend(plot_handles, 'Location', 'best');  % Only include the plot handles in the legend
    title(['Queue Evolution for Each Arm - Mean Arrival \lambda = ' num2str(mean_arrival)]);

    hold off;
end



