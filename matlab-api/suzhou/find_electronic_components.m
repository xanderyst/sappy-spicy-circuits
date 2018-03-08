function components = find_electronic_components(imgName)
% components = find_electronic_components(imgName)
%
% Function that finds the electronic components in the given file.
%
% Input:
% - imgName = 1xN cell array containing the names of the files/images that 
%             we want to find electronic components in
%
% Output:
% - components = 1xN structure containing:
%   - FileName = name of the image/file
%   - CompIndex = indices of the electronic components in that file
%
% Written by:
% Suzhou Li

    % Check the input arguments
    if (ischar(imgName)) 
        imgName = {imgName};
    end

    % Initialize the output matrix
    components = struct('FileName', [], 'CompIndex', []);
    
    % Iterate through image in the cell array
    for i = 1 : numel(imgName)
        
        % Read the inputted image
        imgRGB = imread(char(imgName(i)));

        % Find the connected components
        [imgCC, ~] = find_segments(imgRGB);

        % Ask if this data is okay
        data_okay = input('Does this look okay? (y/n): ', 's');
        
        % If data is not okay, skip the rest of the cod
        if (data_okay == 'n')
            continue;
        end
        
        % Translate the indices to Ben's indices 
        indices = suzhou_to_ben(imgCC);
        
        % Collect the output
        components(i).FileName = char(imgName(i));
        components(i).CompIndex = indices;
    end
end