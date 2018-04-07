function [left, top, right, bottom] = boundingBox_to_borders(boundingBox)
    
    % Check the input arguments
    
    if (nargin ~= 1)
        error('Wrong number of input arguments!');
    end
    
    if (numel(boundingBox) ~= 4)
        error('Bounding Box requires 4 values!');
    end
    
    % Get the borders of the box
    left   = boundingBox(1);
    top    = boundingBox(2);
    right  = left + boundingBox(3);
    bottom = top + boundingBox(4);
end