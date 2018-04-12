function imgOut = fill_in_binary(imgIn, components, fillValue)
    
    % Check the input arguments
    if (nargin == 2)
        fillValue = false;
    end
    
    % Fill in the bounding boxes of the component
    comp_mask = false(size(imgIn));
    for i = 1 : numel(components)
        
        % Convert the rectangle to a box
        x_box = [ ...
            components(i).CompRect(1), ...
            components(i).CompRect(1) + components(i).CompRect(3), ...
            components(i).CompRect(1) + components(i).CompRect(3), ...
            components(i).CompRect(1)];
        y_box = [ ...
            components(i).CompRect(2), ...
            components(i).CompRect(2), ...
            components(i).CompRect(2) + components(i).CompRect(4), ...
            components(i).CompRect(2) + components(i).CompRect(4)];
        
        % Convert the box to a mask
        comp_mask = comp_mask | ...
            poly2mask(x_box, y_box, size(imgIn, 1), size(imgIn, 2));
    end
    
    % Fill in the values
    imgOut = imgIn;
    imgOut(comp_mask) = fillValue;
    
    % Close the image
    if ~fillValue
        %imgOut = imopen(imgOut, strel('square', 1));
    end
    
end