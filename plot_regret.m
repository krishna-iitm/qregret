function plot_regret(T, q_regret, m, q_regret_qths, titleString)
    figure;
    hold on;
    
    % plot Q-Regret, store the plot handle for legend
    h_regret = plot(1:T, q_regret, 'DisplayName', 'Q-Regret', 'LineWidth', 1.5);
    h_regret_qths = plot(1:T, q_regret_qths, 'DisplayName','Q-ThS Regret', 'LineWidth',1.5);
    % If you want to plot cumulative regret too, uncomment the following
    % line but cum_regret have to check 
    % h_cumulative = plot(1:T, cumulative_regret_gainbased, 'DisplayName', 'Gain-Regret-Over-Time', 'LineWidth', 2);

   % colors for blocks...
    colors = [0.95, 0.95, 0.95;  0.9, 0.9, 0.9 ];
    
    %compute block size (number of time steps per block)....
    block_size = floor(T / m);
    
    % compute the min and max of q_regret and add buffer for the y-axis.
    % For visual formatting only.
    y_min = min(min(q_regret), min(q_regret_qths));
    y_max = max(max(q_regret),max(q_regret_qths));
    buffer = 0.05 * (y_max - y_min);  % 5% buffer above the max
    y_min_extended = y_min;
    y_max_extended = y_max + buffer;
    
    % set the  fixed y-axis limits
    ylim([y_min_extended, y_max_extended]);

    %increase the y-tick resolution by setting more ticks
    y_tick_interval = 0.1 * (y_max_extended - y_min_extended);  % Adjust tick spacing
    yticks(y_min_extended:y_tick_interval:y_max_extended);

    % overlay rectangles for each block with alternating colors
    for block_idx = 1:m
        block_start = (block_idx - 1) * block_size + 1;
        block_end = min(block_idx * block_size, T);  
       
        % alternate colors based on the block index
        color_idx = mod(block_idx, 2) + 1;  
        block_color = colors(color_idx, :);  
        
        %Create a transparent rectangle to demarcate the blocks
        x = [block_start, block_end, block_end, block_start];
        y = [y_min_extended, y_min_extended, y_max_extended, y_max_extended];  % Extend y range to fill the plot area
        h_patch = patch(x, y, block_color, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
       
        set(h_patch, 'DisplayName', '');
    end
    
    xlabel('Time Step');
    ylabel('Q-Regret');
    legend([h_regret h_regret_qths], 'Location', 'best');  % Only include the Q-Regret plot handle in the legend
    title(['Q-Regret over Time' titleString]);
    
    hold off;
end
