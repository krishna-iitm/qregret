% Function 3: Plot Cumulative Service Offered 


function plot_cumulative_service_offered(N, T, rewards, total_service_algo, total_service_qths)
    figure;
    cumulative_service = zeros(N+2, 1);
    
   
    for arm = 1:N
        cumulative_service(arm) = sum(rewards(arm, :))/T;  % Sum of rewards (service offered) for each arm
    end
    
    cumulative_service(N+1) = total_service_algo/T;
    cumulative_service(N+2) = total_service_qths/T;
    
    % create a bar plot 
    h = bar(cumulative_service);
    
    %change the color of the N+1-th bar (the last bar, representing "Algorithm")
    h.FaceColor = 'flat'; % Allow individual color control for each bar
    h.CData(N+1, :) = [1, 0, 0];  % Change the N+1-th bar color to red (RGB)
    

    %xlabel('Channel');
    ylabel('Cummulative Service/T');
    title('Mean Service Offered');
    
    % xticks and xticklabels
    xticks(1:N+2);  % Set positions of the ticks for each arm + 1 for 'Algorithm'
    xticklabels([arrayfun(@(i) ['Channel ' num2str(i)], 1:N, 'UniformOutput', false), {'Our Algo'}, 'Q-ThS']); 
    
end
