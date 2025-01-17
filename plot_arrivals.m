% Function 5: Plot the Arrival Process Over Time
function plot_arrivals(T, A)
    figure;
    plot(1:T, A, 'DisplayName', 'Arrivals (A(t))');
    xlabel('Time Step');
    ylabel('Arrival Value');
    legend;
    title('Arrival Process Over Time');
end
