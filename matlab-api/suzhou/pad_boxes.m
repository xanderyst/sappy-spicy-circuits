function outCC = pad_boxes(inCC, scale)
% outCC = pad_boxes(inCC, scale)
% 
% Function to pad the boxes by a particular scale factor.
% 
% Inputs:
% - inCC = vector of connected component structures
% - scale = scale factor to multiply height and width by
%
% Output:
% - outCC = vector of connected component structure with the padded boxes
%
% Written by:
% Suzhou Li

    % Initialize the output
    outCC = inCC;
    
    for i = 1 : numel(inCC)
        
        % Get the borders of the bounding box
        [lft, top, right, bottom] = ...
            boundingBox_to_borders(outCC(i).BoundingBox);
        
        % Calculate the new width and height
        newWidth = scale * outCC(i).BoundingBox(3);
        newHeight = scale * outCC(i).BoundingBox(4);
        
        % Calculate the new minimum x and minimum y
        newMinX = ((lft + right) / 2) - (newWidth / 2);
        newMinY = ((top + bottom) / 2) - (newHeight / 2);
        
        % Set the new values in the bounding box
        outCC(i).BoundingBox = [newMinX, newMinY, newWidth, newHeight];
    end
end