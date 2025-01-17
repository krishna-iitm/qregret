function plot_cum_ch_gain_regret(T,N,cum_ch_gain_algo,rewards,m)
   
    figure;
    hold on;
    plot_handles = [];
    % h_regret = plot(1:T, cum_ch_gain_regret, 'DisplayName','Cum Channel Gain Regret', 'LineWidth',1.5);
    for arm = 1:N
        h= plot(1:T, cum_ch_gain_algo - cumsum(rewards(arm,:)), 'DisplayName', ['Regret with Ch' num2str(arm)], 'LineWidth', 1.5);
        plot_handles = [plot_handles, h];
    end

    colors = [0.95, 0.95, 0.95;  0.9, 0.9, 0.9 ];

    %compute block size (number of time steps per block)....
    block_size = floor(T / m);
    
    % compute the min and max of q_regret and add buffer for the y-axis.
    % For visual formatting only.
    y_min= inf;
    y_max = -inf;

    for arm = 1:N
        temp_min = min(cum_ch_gain_algo - cumsum(rewards(arm,:)));
        temp_max = max(cum_ch_gain_algo - cumsum(rewards(arm,:)));
        if(temp_min < y_min )
            y_min = temp_min;
        end
        if(temp_max > y_max)
            y_max = temp_max;
        end
    end
    % 
    % y_min = min(cum_ch_gain_regret);
    % y_max = max(cum_ch_gain_regret);

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
    ylabel('Regret ');
    legend( plot_handles, 'Location', 'best');  % Only include the Q-Regret plot handle in the legend
    title('(Cumulative Channel Gains Regret (Algorithm vs All Arms)');
    

end