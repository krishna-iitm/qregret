% Function 6: Plot Difference Regret Over Time (Comparing Algorithm's Arm and Optimal Arm)
function plot_diff_regret(T,N,queue_evolution_algo, all_arms_queue_evolutions, queue_evolution_qths, queue_evolution_qths_opt)
    figure;
    hold on;
    plot_handles = [];
    for arm = 1:N
        h = plot(1:T, queue_evolution_algo-all_arms_queue_evolutions(arm,:), 'DisplayName',['Q(t)-Q^' num2str(arm) '(t)'],'LineWidth',1.5);
        plot_handles = [plot_handles h];
    end
    h1 = plot(1:T, queue_evolution_qths - queue_evolution_qths_opt, 'DisplayName','Q-ThS Q-Q_{opt}', 'LineWidth',1.5);
   
    plot_handles = [plot_handles h1];
    xlabel('Time Step');
    ylabel('Q(t)-Q^i(t)');
    legend(plot_handles, 'Location', 'best');
    title('Difference of Queue Evolution over Time (Algorithm vs Other Channels)');
end