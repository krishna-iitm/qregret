% % Function 2: Plot the Queue evolution
% function plot_algorithm_queue_evolution(T, queue_evolution_algo, queue_evolution_optimal)
%     figure;
%     hold on;
%     plot(1:T, queue_evolution_algo, 'DisplayName', 'Our Algorithm', 'LineWidth',1.5);
%     plot(1:T, queue_evolution_optimal, 'DisplayName', 'Optimal Arm Queue', 'LineWidth',1.5);
%     xlabel('Time Step');
%     ylabel('Queue Length');
%     legend;
%     title('Queue Evolution for the Learning Algorithm');
% end

% Function 2: Plot the Queue evolution
function plot_algorithm_queue_evolution(T, queue_evolution_algo, queue_evolution_optimal, m, optimal_arm)
    figure;
    hold on;
    
    % plot Queue Evolution for the Algorithm and the Optimal Arm
    h_algo = plot(1:T, queue_evolution_algo, 'DisplayName', 'Our Algorithm', 'LineWidth', 1.5);
    h_optimal = plot(1:T, queue_evolution_optimal, 'DisplayName', ['Static Optimal Channel' num2str(optimal_arm)], 'LineWidth', 1.5);
    h_qths = plot(1:T, queue_)
    % 
    colors = [0.95, 0.95, 0.95; % White
        0.9, 0.9, 0.9];   % Grey
   
    
   
    block_size = floor(T / m);
    
    % Compute the min and max of both queues and add buffer for the y-axis
    y_min = min([queue_evolution_algo, queue_evolution_optimal]);
    y_max = max([queue_evolution_algo, queue_evolution_optimal]);
    buffer = 0.05 * (y_max - y_min);  % 5% buffer above the max
    y_min_extended = y_min;
    y_max_extended = y_max + buffer;
    
    % Set the fixed y-axis limits
    ylim([y_min_extended, y_max_extended]);

    % Increase the y-tick resolution by setting more ticks
    y_tick_interval = 0.1 * (y_max_extended - y_min_extended);  % Adjust tick spacing
    yticks(y_min_extended:y_tick_interval:y_max_extended);

    % Overlay transparent rectangular windows for each block with alternating colors
    for block_idx = 1:m
        block_start = (block_idx - 1) * block_size + 1;
        block_end = min(block_idx * block_size, T); 

        % Alternate colors based on the block index
        color_idx = mod(block_idx, 2) + 1;  
        block_color = colors(color_idx, :); 
        
        % Create a transparent rectangle to highlight the block (using patch)
        x = [block_start, block_end, block_end, block_start];
        y = [y_min_extended, y_min_extended, y_max_extended, y_max_extended];  % Extend y range to fill the plot area
        h_patch = patch(x, y, block_color, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
        
        set(h_patch, 'DisplayName', '');
    end
    
    xlabel('Time Step');
    ylabel('Queue Length');
    legend([h_algo, h_optimal], 'Location', 'best');  % Only include the algorithm and optimal queue plot handles in the legend
    title('Queue Evolution - Static Optimal vs. Our Algorithm Comparison');
    
    hold off;
end
