function [h_regret, h_regret_qths, h_regret_stahlbuhk] = plot_regret(T, q_regret, m, q_regret_qths, q_regret_stahlbuhk, titleString, fontsize, isWithLegend, isNewFigure, use_custom_breakpoints, break_points)
    % T: Total time steps
    % q_regret: Regret values for the first method
    % m: Number of blocks (for T/m blocks only, unused if custom breakpoints are used)
    % q_regret_qths: Regret values for the second method
    % q_regret_stahlbuhk: Regret values for the third method
    % titleString: Title of the plot
    % fontsize: Font size for various elements
    % isWithLegend: Boolean to include the legend
    % isNewFigure: Boolean to start a new figure
    % use_custom_breakpoints: Boolean flag to use custom breakpoints (true) or T/m (false)
    % break_points: Custom break points (used only if use_custom_breakpoints is true)

    if isNewFigure
        figure;
    end
    hold on;

    % Plot Q-Regret, store the plot handle for legend
    h_regret = plot(1:T, q_regret, 'DisplayName', 'This work', 'LineWidth', 2);
    h_regret_qths = plot(1:T, q_regret_qths, 'DisplayName', 'Q-ThS (S. Krishnasamy et al. [8])', 'LineWidth', 2);
    h_regret_stahlbuhk = plot(1:T, q_regret_stahlbuhk, 'DisplayName', 'Stahlbuhk et al. [7]', 'LineWidth', 2);

    % Colors for blocks
    colors = [0.98, 0.98, 0.98; 0.88, 0.88, 0.88];

    % Compute block size (number of time steps per block)
    if use_custom_breakpoints
        % If custom break points are provided, use them
        m = length(break_points) - 1;  % Number of blocks
        block_sizes = diff(break_points);  % Sizes of blocks based on break points
    else
        % If no custom break points, divide T into m equal blocks
        block_size = floor(T / m);  % Size of each block
        block_sizes = repmat(block_size, 1, m);  % Uniform block sizes
        block_sizes(end) = T - sum(block_sizes(1:end-1));  % Adjust last block to cover any remainder
        break_points = [1, cumsum(block_sizes)];  % Generate break points
    end

    % Compute the min and max of q_regret and add buffer for the y-axis
    y_min = min([min(q_regret), min(q_regret_qths), min(q_regret_stahlbuhk)]);
    y_max = max([max(q_regret), max(q_regret_qths), max(q_regret_stahlbuhk)]);
    buffer = 0.05 * (y_max - y_min);  % 5% buffer above the max
    y_min_extended = y_min;
    y_max_extended = y_max + buffer;

    % Set the fixed y-axis limits
    ylim([y_min_extended, y_max_extended]);

    % Dynamically determine the tick interval based on the range
    y_range = y_max_extended - y_min_extended;
    
    % Choose a suitable tick interval so that we have a reasonable number of ticks
    num_ticks = 10;  % Choose the number of ticks you want to display
    tick_interval = round(y_range / num_ticks);  % Round to get a manageable interval
    
    if tick_interval == 0
        tick_interval = 1;  % Ensure we don't end up with a zero interval
    end
    
    % Adjust the ticks to be integer values
    y_ticks = y_min_extended:tick_interval:y_max_extended;
    
    % Make sure we start and end on integer values
    y_ticks = round(y_ticks);
    
    yticks(y_ticks);  % Set the y-axis ticks

    % Overlay rectangles for each block with alternating colors
    for block_idx = 1:m
        block_start = break_points(block_idx);
        block_end = break_points(block_idx + 1);

        % Alternate colors based on the block index
        color_idx = mod(block_idx, 2) + 1;
        block_color = colors(color_idx, :);

        % Create a transparent rectangle to demarcate the blocks
        x = [block_start, block_end, block_end, block_start];
        y = [y_min_extended, y_min_extended, y_max_extended, y_max_extended];  % Extend y range to fill the plot area
        h_patch = patch(x, y, block_color, 'EdgeColor', 'none', 'FaceAlpha', 0.3);

        set(h_patch, 'DisplayName', '');
        
        % Add a dashed vertical line at the end of each block
        plot([block_end, block_end], [y_min_extended, y_max_extended], 'k--', 'LineWidth', 0.5);  % Dashed line
    end

    % Set axis labels with larger fonts
    xlabel('Time Slot', 'FontSize', fontsize(1), 'FontName', 'Arial', 'FontWeight', 'normal');
    ylabel('Regret', 'FontSize', fontsize(1), 'FontName', 'Arial', 'FontWeight', 'normal');
    
    % Title with larger font
    title(['' titleString], 'FontSize', fontsize(4), 'FontName', 'Arial', 'FontWeight', 'normal');
    
    % Adjust the legend font size
    if isWithLegend
        legend([h_regret_stahlbuhk, h_regret_qths, h_regret], 'Location', 'best', 'FontSize', fontsize(2), 'FontName', 'Arial');
    end

    % Set grid and axes properties for clarity
    grid on;
    set(gca, 'FontSize', fontsize(3), 'FontName', 'Arial', 'FontWeight', 'normal');
    
    hold off;
end


% function [h_regret, h_regret_qths, h_regret_stahlbuhk] = plot_regret(T, q_regret, m, q_regret_qths, q_regret_stahlbuhk, titleString, fontsize,isWithLegend, isNewFigure)
% 
%     if isNewFigure
%         figure;
%     end
%     hold on;
% 
%     % plot Q-Regret, store the plot handle for legend
%     h_regret = plot(1:T, q_regret, 'DisplayName', 'This work', 'LineWidth', 1.5);
%     h_regret_qths = plot(1:T, q_regret_qths, 'DisplayName','Q-ThS (S. Krishnasamy et al. [8])', 'LineWidth',1.5);
%     h_regret_stahlbuhk = plot(1:T, q_regret_stahlbuhk, 'DisplayName', 'Stahlbuhk et al. [7]', 'LineWidth',1.5);
% 
%     % colors for blocks...
%     colors = [0.98, 0.98, 0.98;  0.88, 0.88, 0.88 ];
% 
%     % compute block size (number of time steps per block)....
%     block_size = floor(T / m);
% 
%     % compute the min and max of q_regret and add buffer for the y-axis.
%     % For visual formatting only.
%     y_min = min([min(q_regret), min(q_regret_qths),min(q_regret_stahlbuhk)]);
%     y_max = max([max(q_regret),max(q_regret_qths), max(q_regret_stahlbuhk)]);
%     buffer = 0.05 * (y_max - y_min);  % 5% buffer above the max
%     y_min_extended = y_min;
%     y_max_extended = y_max + buffer;
% 
%     % set the fixed y-axis limits
%     ylim([y_min_extended, y_max_extended]);
% 
%     % Dynamically determine the tick interval based on the range
%     y_range = y_max_extended - y_min_extended;
% 
%     % Choose a suitable tick interval so that we have a reasonable number of ticks
%     % For example, let's aim for 5 to 10 ticks on the y-axis.
%     num_ticks = 10;  % Choose the number of ticks you want to display
%     tick_interval = round(y_range / num_ticks);  % Round to get a manageable interval
% 
%     if tick_interval == 0
%         tick_interval = 1;  % Ensure we don't end up with a zero interval
%     end
% 
%     % Adjust the ticks to be integer values
%     y_ticks = y_min_extended:tick_interval:y_max_extended;
% 
%     % Make sure we start and end on integer values
%     y_ticks = round(y_ticks);
% 
%     yticks(y_ticks);  % Set the y-axis ticks
%     % xticks(0:1000:T);
%     % overlay rectangles for each block with alternating colors
%     for block_idx = 1:m
%         block_start = (block_idx - 1) * block_size + 1;
%         block_end = min(block_idx * block_size, T);  
% 
%         % alternate colors based on the block index
%         color_idx = mod(block_idx, 2) + 1;  
%         block_color = colors(color_idx, :);  
% 
%         % Create a transparent rectangle to demarcate the blocks
%         x = [block_start, block_end, block_end, block_start];
%         y = [y_min_extended, y_min_extended, y_max_extended, y_max_extended];  % Extend y range to fill the plot area
%         h_patch = patch(x, y, block_color, 'EdgeColor', 'none', 'FaceAlpha', 0.3);
% 
%         set(h_patch, 'DisplayName', '');
%     end
% 
%     % Set axis labels with larger fonts
%     xlabel('Time Slot', 'FontSize', fontsize(1), 'FontName', 'Arial', 'FontWeight', 'normal');
%     ylabel('Regret', 'FontSize', fontsize(1), 'FontName', 'Arial', 'FontWeight', 'normal');
% 
%     % Title with larger font
%     title(['' titleString], 'FontSize', fontsize(4), 'FontName', 'Arial', 'FontWeight', 'normal');
% 
%     % Adjust the legend font size
%     if isWithLegend
%         legend([h_regret h_regret_qths, h_regret_stahlbuhk], 'Location', 'best', 'FontSize', fontsize(2), 'FontName', 'Arial');
%     end
%     % Set grid and axes properties for clarity
%     grid on;
%     set(gca, 'FontSize', fontsize(3), 'FontName', 'Arial', 'FontWeight', 'normal');
% 
%     hold off;
% end
