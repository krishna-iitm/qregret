function mean_A = chunked_mean(A,T, m)
    % Input: 
    % A is a 1xT array
    % m is the number of chunks
    
    T = length(A);  % Length of the array
    chunk_size = T / m;  % Size of each chunk
    
    % Check if T is divisible by m
    if mod(T, m) ~= 0
        % If not divisible, pad the array with NaNs or zeros (customize as needed)
        padding_size = m - mod(T, m);  % Calculate how much padding is needed
        A = [A, zeros(1, padding_size)];  % Add padding (zeros or NaNs)
        T = length(A);  % Update the length after padding
        chunk_size = T / m;  % Recalculate chunk_size after padding
    end
    
    % Reshape A into an m x chunk_size matrix
    reshaped_A = reshape(A, chunk_size, m);
    
    % Take the mean across each column (each chunk)
    mean_A = mean(reshaped_A);
end
