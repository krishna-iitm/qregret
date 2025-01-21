% Save figures to PDF and .fig inside a specified folder
function save2pdf(varargin)

    % Check if the folder path is provided via varargin
    if nargin > 0
        % Assign the folder path to a variable
        newFolderPath = varargin{1};  % The path to the specific simulation folder
    else
        % If no folder path is provided, default to the current working directory
        newFolderPath = pwd;  % Current directory if no argument is passed
    end

    % Get all open figure handles
    figHandles = findobj('Type', 'figure');

    % Check if the specified folder exists, if not, create it
    if ~exist(newFolderPath, 'dir')
        mkdir(newFolderPath);
    end

    % Get the list of all existing PDF files in the specified folder
    pdfFiles = dir(fullfile(newFolderPath, '*.pdf'));

    % Extract numerical part of the file names (e.g., '01.pdf' -> 1, '02.pdf' -> 2)
    existingNumbers = [];
    for i = 1:length(pdfFiles)
        [~, name, ~] = fileparts(pdfFiles(i).name);  % Extract file name without extension
        if ~isempty(name) && all(isstrprop(name, 'digit'))  % Check if the name is purely digits
            existingNumbers = [existingNumbers, str2double(name)];  % Convert to number and store
        end
    end

    % If there are existing PDFs, find the maximum number and increment by 1
    if ~isempty(existingNumbers)
        nextFileNumber = max(existingNumbers) + 1;
    else
        nextFileNumber = 1;  % If no PDFs exist, start with 1
    end

    % Loop through each figure handle
    for i = 1:length(figHandles)
        % Set the figure handle as the current figure
        figure(figHandles(i));

        % Generate the next file name (e.g., '03.pdf')
        filename = sprintf('%02d.pdf', nextFileNumber);

        % Define the full file path in the specified folder
        filePath = fullfile(newFolderPath, filename);

        % Save the current figure as a PDF in the specified folder
        saveas(figHandles(i), filePath);

        % Save the figure as .fig as well in the specified folder
        savefig(figHandles(i), fullfile(newFolderPath, sprintf('%02d.fig', nextFileNumber)));

        % Increment the next file number for the next figure
        nextFileNumber = nextFileNumber + 1;
    end

end
