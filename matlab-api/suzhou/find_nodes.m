function [imgOut, components] = find_nodes(imgOut, components)
% [imgOut, components] = find_nodes(imgOut, components)
%
% Function used to find the nodes that each component is connected to.
%
% Input:
% - imgIn = input grayscale image with components removed
% - components = structure containing that following properties:
%   - CompNames = string denoting the name of the component
%   - CompLocation = 1x4 vector containing the bounding box
% 
% Output:
% - imgOut = output image containing the labeled nodes
% - components = structure same as the one above with a new property:
%   - CompNodes = 1x2 vector denoting the nodes the component is connected
%
% Written by:
% Suzhou Li

%     % Check input arguments
%     if (nargin == 1)
%         crop = 1;
%     end
%     
%     % Crop the image
%     if crop
%         figure, clf;
%         imgOut = imcrop(imgIn);
%         close;
%     else
%         imgOut = imgIn;
%     end
    
    % Get the image with the removed components
    %[imgOut, components] = remove_components(imgOut);
    
    % Binarize the image
    imgOut = imgIn;
    imgOut = imbinarize(imgOut, 'adaptive', ...
        'ForegroundPolarity', 'dark', 'Sensitivity', 0.5); 
    imgOut = bwareaopen(~imgOut, 100);
    imgOut = imopen(~imgOut, strel('disk', 16));
    
    % Label the nodes in the image
    imgOut = bwlabel(~imgOut);
    
    % Initialize the value indicating the radius to search for nodes
    pad = 100;
    
    % Iterate through the components
    for i = 1 : numel(components)
        
        % Get the box containing the component
        box = components(i).CompLocation;
        
        % Increase the box dimensions based on the padding
        box(1) = box(1) - pad;
        box(2) = box(2) - pad;
        box(3) = (2 * pad) + box(3);
        box(4) = (2 * pad) + box(4);
        
        % Make sure that the box dimensions are within bounds of the image
        box(1) = limit_value(box(1), 1, size(imgOut, 2));
        box(2) = limit_value(box(2), 1, size(imgOut, 1));
        box(3) = limit_value(box(1)+box(3), 1, size(imgOut,2))-box(1);
        box(4) = limit_value(box(2)+box(4), 1, size(imgOut,1))-box(2);
        
        % Convert from the rectangle dimensions to a bounding box
        x_box = [box(1), box(1) + box(3), box(1) + box(3), box(1)];
        y_box = [box(2), box(2), box(2) + box(4), box(2) + box(4)]; 
        
        % Get the values in that box 
        mask = poly2mask(x_box, y_box, size(imgOut,1), size(imgOut,2));
        nodes = imgOut(mask);
        
        % Collect the unique values in that box
        nodes = unique(nodes(nodes > 0));
        
        % Add a property to the components structure and put the node
        % values into the components
        components(i).CompNodes = nodes;
    end
    
    % Get the connected components properties of the node
    node_cc = regionprops(imgOut, 'BoundingBox', 'Centroid');
    
    % Show the image with colored nodes
    colors = jet(numel(node_cc));
    imshow(label2rgb(imgOut, colors))
    
    % Iterate through the nodes to print their values
    for i = 1 : numel(node_cc)
        
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
            'Position', components(i).CompLocation, ...
            'EdgeColor', 'r');
        
        % Initialize the string
        str = sprintf('');
        
        % Iterate through the nodes to add them to the string
        for j = 1 : numel(components(i).CompNodes)
            str = strcat(str, sprintf('\n%d', components(i).CompNodes(j)));
        end
        
        % Show the node values
        text( ...
            components(i).CompLocation(1) + 10, ...
            components(i).CompLocation(2) + 30, ...
            str, 'Color', 'r');
    end
    hold off
end

function out = limit_value(in, min, max)
    if (in < min)
        out = min;
    elseif (in > max)
        out = max;
    else
        out = in;
    end
end
    