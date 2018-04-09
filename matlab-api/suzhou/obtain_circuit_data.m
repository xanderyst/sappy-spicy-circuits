function [imgOut, components] = obtain_circuit_data(imgIn)
% imgOut = obtain_circuit_data(imgIn)
%
% Function to separate and classify all the circuit data. The process to
% use this function is as listed in the following steps.
%   (1) Draw a box around just the component, do not include anything else.
%   (2) Double click on the type of the component that was just selected.
%   (3) When prompted if there are more components, click yes if there are
%       more components and no if there are no more components.
%   (4) Repeat steps 1 to 3 until there are no more components.
%
% Input:
% - imgIn = image file name or matrix containing the image pixel data
%
% Outputs:
% - imgOut = image (nothing special about this image)
% - components = struct array with each struct containing the properties:
%   - CompName = name of the component, currently limited to the following:
%           + Current Source
%           + Voltage Source
%           + Inductor
%           + Resistor
%           + Capacitor
%   - CompCentroid = centroid of the component
%   - CompRect = 4x1 vector denoting the rectangle surrounding the
%                component in the form: [min x, min y, width, height]
%   - Characters = properties of the characters associated with the
%                  component
%       - Values = character array of the characters that are closest to
%                  the particular component 
%       - BoundingBoxes = rectangle surrounding the characters in the form:
%                         [minimum x, minimum y, width, height]
%   - Words = properties of the words associated with the component
%       - Values = cell array containing strings denoting the words that
%                  are closest to the particular component
%       - BoundingBoxes = rectangle surrounding the words in the form:
%                         [minimum x, minimum y, width, height]
%   - CompNodes = nodes that are connected to the component, should be a
%                 2x1 vector (if not, then there is something wrong)
%
% Written by:
% Suzhou Li

    % Find the components
    %components = manual_detect_components(imgIn);
    components = detectComponents('Capacitor', imgIn);
    % Remove the electronic components from the input image
    [imgOut, components] = remove_components(imgIn, components);
    
    % Find the text associated with the input image
    [imgOut, components] = find_text(imgOut, components);
    
    % Get the associated nodes for each electronic component
    [imgOut, components] = find_nodes(imgOut, components);
    
    % Get the connected components properties of the node
    node_cc = regionprops(imgOut, 'BoundingBox', 'Centroid');
    
    % Show the original image
    imshow(imgIn);
    
    % Iterate through the nodes to print their values
    colors = jet(numel(node_cc));
    for i = 1 : numel(node_cc)
        
        % Get the bounding box
        x_min  = node_cc(i).BoundingBox(1);
        y_min  = node_cc(i).BoundingBox(2);
        width  = node_cc(i).BoundingBox(3);
        height = node_cc(i).BoundingBox(4);
        
        % Get the center (not the centroid of the bounding box)
        x_center = x_min + (width / 2);
        y_center = y_min + (height / 2);
        
        % Get where the centroid is relative to the center
        relative_loc = 1;
        if (node_cc(i).Centroid(1) < x_center)
            if (node_cc(i).Centroid(2) < y_center)
                relative_loc = 1; % northwest corner
            else
                relative_loc = 4; % southwest corner
            end
        else
            if (node_cc(i).Centroid(2) < y_center)
                relative_loc = 2; % northeast corner
            else
                relative_loc = 3; % southeast corner
            end
        end
        
        % Print the text depending on where the location is
        str = sprintf('Node %d', i);
        switch relative_loc
            case 1 % northwest
                text(x_min + 30,          y_min - 40, ...
                    str, 'Color', colors(i, :));
            case 2 % northeast
                text(x_min + width - 240, y_min - 40, ...
                    str, 'Color', colors(i, :));
            case 3 % southeast
                text(x_min + width - 240, y_min + height + 20, ...
                    str, 'Color', colors(i, :));
            case 4 % southwest
                text(x_min + 30,          y_min + height + 20, ...
                    str, 'Color', colors(i, :));
        end
    end
    
    % Iterate through the components to show the labels
    hold on
    for i = 1 : numel(components)
        
        % Show the rectangle that contains the component
        rectangle( ...
            'Position', components(i).CompRect, ...
            'EdgeColor', 'r');
        
        % Initialize the string
        str = sprintf('');
        
        % Iterate through the nodes to add them to the string
        for j = 1 : numel(components(i).CompNodes)
            str = strcat(str, sprintf('\n%d', components(i).CompNodes(j)));
        end
        
        % Show the node values
        text( ...
            components(i).CompRect(1) + 10, ...
            components(i).CompRect(2) + 30, ...
            str, 'Color', 'r');
        
        % Show the text associated with each node
        text( ...
            components(i).CompRect(1), ...
            components(i).CompRect(2), ...
            components(i).Characters.Values, ...
            'Color', 'b');
    end
    hold off
end