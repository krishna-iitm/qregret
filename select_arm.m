function selected_arm = select_arm(p)
    %%slect an arm based on the current probability distribution
    selected_arm = find(rand <= cumsum(p), 1); % CDF-based \\
end
