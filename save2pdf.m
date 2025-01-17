% Get all open figure handles
figHandles = findobj('Type', 'figure');

% Loop through each figure handle
for i = 1:length(figHandles)

    
    % Set the figure handle as the current figure
    figure(figHandles(i));
    
    % filename(e.g., '01.pdf', '02.pdf', ...)
    filename = sprintf('%02d.pdf', i);
    
    % Save the current figure as a PDF
    saveas(figHandles(i), filename);
end
