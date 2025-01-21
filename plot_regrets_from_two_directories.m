% Directory paths for the two different sets of simulation results
folder1 = 'results/18-stationary-500runs-epsilon-0.25-medium-load';
folder2 = 'results/19-stationary-500runs-epsilon-0.05-heavy-load';
folder3 = 'results/20-stationary-500runs-epsilon-0.15'
% Load data from folder 18
q_regret_avg_18 = readmatrix(fullfile(folder1, 'avg_q_regret.csv'));
q_regret_qths_avg_18 = readmatrix(fullfile(folder1, 'avg_qths_regret.csv'));
q_regret_stahlbuhk_avg_18 = readmatrix(fullfile(folder1, 'avg_stahlbuhk_regret.csv'));

% Load data from folder 19
q_regret_avg_19 = readmatrix(fullfile(folder2, 'avg_q_regret.csv'));
q_regret_qths_avg_19 = readmatrix(fullfile(folder2, 'avg_qths_regret.csv'));
q_regret_stahlbuhk_avg_19 = readmatrix(fullfile(folder2, 'avg_stahlbuhk_regret.csv'));

% Load from folder 20
q_regret_avg_20 = readmatrix(fullfile(folder3, 'avg_q_regret.csv'));
q_regret_qths_avg_20 = readmatrix(fullfile(folder3, 'avg_qths_regret.csv'));
q_regret_stahlbuhk_avg_20 = readmatrix(fullfile(folder3, 'avg_stahlbuhk_regret.csv'));

% Define the number of time steps (T) and the parameter m (assuming it's a constant across simulations)
T = length(q_regret_avg_18);  % Assuming T is the same for both sets of data
m = 1;  % Modify this as needed

% Plot the first dataset (from folder '18') using plot_regret
disp('Plotting data from folder 18...');
plot_regret(T, q_regret_avg_18, m, q_regret_qths_avg_18, q_regret_stahlbuhk_avg_18, '', [14 14 14 14],0,1);

% Hold on to overlay the second dataset (from folder '19') on the same figure
hold on;

% Plot the second dataset (from folder '19') using plot_regret
disp('Plotting data from folder 19...');
plot_regret(T, q_regret_avg_19, m, q_regret_qths_avg_19, q_regret_stahlbuhk_avg_19, '', [14 14 14 14],0,0);


% Optionally, customize the plot (e.g., add legend, labels)
% xlabel('Time (T)', 'FontSize', 12);
% ylabel('Average Regret', 'FontSize', 12);
% title('Comparison of Regret for Different Simulation Runs', 'FontSize', 14);
% legend({'Folder 18', 'Folder 19'}, 'Location', 'best');
% grid on;

% Release hold
hold off;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Manual overlay
[h11 h22 h33] = plot_regret(T, q_regret_avg_19, m, q_regret_qths_avg_19, q_regret_stahlbuhk_avg_19, '', [14 14 14 14],0,1);
% Get the default color order
default_colors = get(gca, 'ColorOrder');
hold on;
h1=plot(1:T, q_regret_avg_18, 'Color', [default_colors(1,:), 0.25], 'LineWidth', 1.5,'DisplayName', 'This work' );
h2=plot(1:T, q_regret_qths_avg_18, 'Color', [default_colors(2,:), 0.25], 'LineWidth', 1.5, 'DisplayName','Q-ThS (S. Krishnasamy et al. [8])');
h3=plot(1:T, q_regret_stahlbuhk_avg_18, 'Color', [default_colors(3,:), 0.25], 'LineWidth', 1.5, 'DisplayName', 'Stahlbuhk et al. [7]');
plot_handles = [h11 h22 h33];

h1=plot(1:T, q_regret_avg_20, 'Color', [default_colors(1,:), 0.45], 'LineWidth', 1.5,'DisplayName', 'This work' );
h2=plot(1:T, q_regret_qths_avg_20, 'Color', [default_colors(2,:), 0.45], 'LineWidth', 1.5, 'DisplayName','Q-ThS (S. Krishnasamy et al. [8])');
h3=plot(1:T, q_regret_stahlbuhk_avg_20, 'Color', [default_colors(3,:), 0.45], 'LineWidth', 1.5, 'DisplayName', 'Stahlbuhk et al. [7]');
% 
legend(plot_handles,'Location','best', 'FontSize',14, 'FontName', 'Arial');
