function components = find_electronic_components(imgName, rotation, noise)
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
    if (nargin == 1)
        rotation = 0;
        noise = [];
    end
    
    if (ischar(imgName)) 
        imgName = {imgName};
    end
    
    % Initialize the output matrix
    components = []; % struct('FileName', [], 'CompIndex', [], 'CompName', []);
    
    % Iterate through image in the cell array
    i = 1;
    while (i <= numel(imgName))
        
        % Read the inputted image
        imgRGB = imread(char(imgName(i)));
        
        if (rotation ~= 0)
            imgRGB = imrotate(imgRGB, rotation);
        end
            
        if (~isempty(noise))
            imgRGB = imnoise(imgRGB, noise);
        end
        
        % Find the connected components
        [imgCC, imgOut] = find_segments(imgRGB);
        imgCC = combine_inside_components(imgCC);
        imgCC = combine_close_components(imgCC, imgOut, 2);
        
        % Show the labeled image
        show_object_boundaries(imgRGB, imgCC);
        
        % Ask if this data is okay
        data_okay = input('Does this look okay? (y/n): ', 's');
        
        % If data is not okay, skip the rest of the code
        if (data_okay == 'n')
            continue;
        end
        
        % Initialize the component name
        comp_name = [];
        
        % Keep asking until you get the proper input
        while (isempty(comp_name))
            
            % Ask which electronic component we are looking at
            comp_num = input( ...
                ['Component List: \n', ...
                 '(1) Resistor \n', ...
                 '(2) Capacitor \n', ...
                 '(3) Inductor \n', ...
                 '(4) Current Source \n', ...
                 '(5) Voltage Source \n', ...
                 'Enter Component Number (1-5): ']);

            % Select the component
            switch (comp_num)
                case 1 
                    comp_name = 'Res';
                case 2
                    comp_name = 'Cap';
                case 3
                    comp_name = 'Ind';
                case 4
                    comp_name = 'CurrentSrc';
                case 5
                    comp_name = 'VoltageSrc';
                otherwise
                    error('Component does not exist!');
            end
        end
        
        % Translate the indices to Ben's indices 
        indices = suzhou_to_ben(imgCC);
        
        % Collect the output
        components(end + 1).FileName = char(imgName(i));
        components(end).CompName = comp_name;
        components(end).CompIndex = indices;
        
        % Ask if there are any other component types
        others = input('Are there any other component types? (y/n): ', 's');
        
        % If there are other component types, rescan the image
        if (others == 'n')
            i = i + 1;
        end
    end
    
    % Change components to a table instead of a structure
    components = make_ben_table(components);
end