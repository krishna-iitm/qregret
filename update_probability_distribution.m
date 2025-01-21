% Subroutine for our-algorithm [Sinha and Krishnakumar]
function p = update_probability_distribution(p, g, eta)
    % p: curr probability distribution (N-dim vector)
    % g: gain
    % eta: Step size
    
    % Step 1: 
    p = p + eta * g;  % Update using the gradient

    % Step 2: Project the updated vector onto the probability simplex
    p = proj_simplex(p);  %valid
end
