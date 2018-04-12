function fig = show_circuit_data(imgIn, imgNoComp, components)
% fig = show_circuit_data(imgIn, imgNoComp)
%
% Function to show the circuit data.
%
% Inputs:
% - imgIn = regular input image
% - imgNoComp = binarized image with no components
%
% Written by:
% Suzhou Li

    % Get the connected components properties of the node
    node_cc = regionprops(imgNoComp, 'BoundingBox', 'Centroid');
    
    % Show the original image
    fig = figure; clf;
    imshow(imgIn);
    
    % Get the number of pixels to shift
    shift_x = floor(0.02 * size(imgIn, 2)); 
    shift_y = floor(0.02 * size(imgIn, 1));
    
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
                text(x_min, y_min - shift_y, ...
                    str, 'Color', colors(i, :), 'FontWeight', 'bold');
            case 2 % northeast
                text(x_min + width + shift_x, y_min - shift_y, ...
                    str, 'Color', colors(i, :), 'FontWeight', 'bold');
            case 3 % southeast
                text(x_min + width + shift_x, y_min + height - shift_y, ...
                    str, 'Color', colors(i, :), 'FontWeight', 'bold');
            case 4 % southwest
                text(x_min, y_min + height + shift_y, ...
                    str, 'Color', colors(i, :), 'FontWeight', 'bold');
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
            components(i).CompRect(1) + shift_x, ...
            components(i).CompRect(2) + shift_y, ...
            str, 'Color', 'r', 'FontWeight', 'bold');
        
        % Get the string of text associated with each node
        comp_word = sprintf('');
        for j = 1 : numel(components(i).Words.Values)
            comp_word = strcat( comp_word, ...
                sprintf('  %s', char(components(i).Words.Values(j))));
        end
        comp_word = comp_word(3 : end);
        
        % Show the text associated with each node
        text( ...
            components(i).CompRect(1), ...
            components(i).CompRect(2) - shift_y, ...
            comp_word, 'Color', 'b');
        
        % Show the component name
        text( ...
            components(i).CompRect(1), ...
            components(i).CompRect(2)+components(i).CompRect(4)+shift_y, ...
            char(components(i).CompName), 'Color', 'b');
    end
    hold off
end