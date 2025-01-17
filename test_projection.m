% 1. Test Case 1: Basic test case
v1 = [0.5, 0.2, 0.3];
p_proj1 = proj_simplex(v1);
disp('Test Case 1: Basic Test Case');
disp(p_proj1);
disp(['Sum of projected vector: ', num2str(sum(p_proj1))]); % should sum to 1
disp('-----------------------------');

% 2. Test Case 2: Boundary test case with all zero elements
v2 = [0, 0, 0];
p_proj2 = proj_simplex(v2);
disp('Test Case 2: Boundary Case (All Zero Elements)');
disp(p_proj2);
disp(['Sum of projected vector: ', num2str(sum(p_proj2))]); % should sum to 1 (even though elements are zero)
disp('-----------------------------');

% 3. Test Case 3: Random vector
v3 = rand(1, 10);  % Generate a random vector with 10 elements
p_proj3 = proj_simplex(v3);
disp('Test Case 3: Random Vector');
disp(p_proj3);
disp(['Sum of projected vector: ', num2str(sum(p_proj3))]); % should sum to 1
disp('-----------------------------');

% 4. Test Case 4: Test with some negative values
v4 = [0.5, -0.2, 0.3, -0.4, 0.8];
p_proj4 = proj_simplex(v4);
disp('Test Case 4: With Negative Values');
disp(p_proj4);
disp(['Sum of projected vector: ', num2str(sum(p_proj4))]); % should sum to 1
disp('-----------------------------');

% 5. Test Case 5: Check that all values are non-negative
v5 = [0.7, 0.2, -0.1, 0.5];
p_proj5 = proj_simplex(v5);
disp('Test Case 5: Check Non-Negative Result');
disp(p_proj5);
disp('All values should be non-negative');
disp(['Min value in projected vector: ', num2str(min(p_proj5))]); % should be >= 0
disp(['Sum of projected vector: ', num2str(sum(p_proj5))]); % should sum to 1
disp('-----------------------------');

% 6. Test Case 6: Large random vector for performance testing
v6 = rand(1, 1000);  % Large vector
tic;
p_proj6 = proj_simplex(v6);
toc;
disp('Test Case 6: Large Random Vector (Performance Test)');
disp(['Sum of projected vector: ', num2str(sum(p_proj6))]); % should sum to 1
disp('-----------------------------');

% 7. Test Case 7: Edge case with large numbers
v7 = [1e6, 2e6, 3e6, 4e6];
p_proj7 = proj_simplex(v7);
disp('Test Case 7: Large Numbers');
disp(p_proj7);
disp(['Sum of projected vector: ', num2str(sum(p_proj7))]); % should sum to 1
disp('-----------------------------');

% 8. Test Case 8: Edge case with very small numbers (close to zero)
v8 = [1e-6, 2e-6, 3e-6, 4e-6];
p_proj8 = proj_simplex(v8);
disp('Test Case 8: Very Small Numbers');
disp(p_proj8);
disp(['Sum of projected vector: ', num2str(sum(p_proj8))]); % should sum to 1
disp('-----------------------------');
