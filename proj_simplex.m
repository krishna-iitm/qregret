% Subroutine for projection onto the probability simplex.
% Used in OGD of our algorithm.
function p_proj = proj_simplex(v)
    % v: Input vector to be projected onto the probability simplex
    
    % Step 1: Sort the elements of the vector in descending order
    v_sorted = sort(v, 'descend');   % Sort the vector in descending order
    N = length(v);                    % Get the length of the input vector
    
    % Step 2: Compute the cumulative sum of the sorted vector
    cumsum_v = cumsum(v_sorted);      % Cumulative sum of the sorted vector
    
    % Step 3: Compute the rho index, the largest index satisfying the condition
    % checking where v_sorted(rho) > (cumsum_v(rho) - 1) / rho
    rho = 0;  % Default value for rho if no valid index is found
    for i = 1:N
        if v_sorted(i) > (cumsum_v(i) - 1) / i
            rho = i;
        else
            break;  % Once the condition is violated, bre\ak the looop..
        end
    end
    
    % Step 4: Compute the threshold value (theta)
    if rho > 0
        theta = (cumsum_v(rho) - 1) / rho;
    else
        theta = 0;
    end
    
    % Step 5: Apply the threshold to the vector
    p_proj = max(v - theta, 0);   % Subtract theta and set any negative values to zero
    
    % Step 6: Normalize the result to ensure the sum is 1
    p_proj = p_proj / sum(p_proj);  % Ensure the sum of the projected vector is 1
end
