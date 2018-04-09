function [imgOut, components] = find_nodes(imgIn, components)
% [imgOut, components] = find_nodes(imgOut, components)
%
% Function used to find the nodes that each component is connected to.
%
% Input:
% - imgIn = input grayscale image with components removed
% - components = structure containing that following properties:
%   - CompNames = string denoting the name of the component
%   - CompRect = 1x4 vector containing the bounding box
% 
% Output:
% - imgOut = output image containing the labeled nodes
% - components = structure same as the one above with a new property:
%   - CompNodes = 1x2 vector denoting the nodes the component is connected
%
% Written by:
% Suzhou Li

    % Binarize the image
    if (~islogical(imgIn))
        imgOut = imbinarize(imgIn, 'adaptive', ...
            'ForegroundPolarity', 'dark', 'Sensitivity', 0.5); 
    else
        imgOut = imgIn;
    end
    
    % Clean the image
    imgOut = bwareaopen(~imgOut, 300);
    imgOut = imopen(~imgOut, strel('square', 16));
    
    % Label the nodes in the image
    imgOut = bwlabel(~imgOut);
    
    % Iterate through the components
    for i = 1 : numel(components)
        
        % Get the box containing the component
        box = components(i).CompRect;
        
        % Get the value indicating the radius to search for nodes
        pad = ceil(0.05 * box(3));
        
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
    