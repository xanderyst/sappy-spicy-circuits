function [imgOut, mask] = enlarge_image(imgIn, dimensions)
% [imgOut, mask] = enlarge_image(imgIn, dimensions)
% 
% Function to enlarge the image in size.
%
% Written by:
% Suzhou Li
    
    % Get the size of the image
    width  = size(imgIn, 2);
    height = size(imgIn, 1);
    
    % Get the dimensions necessary for the input image relative to the
    % output image
    x_min = floor((dimensions(2) - width) / 2);
    y_min = floor((dimensions(1) - height) / 2);
    x_box = [x_min, x_min + width, x_min + width, x_min];
    y_box = [y_min, y_min, y_min + height, y_min + height];
    
    % Get the mask of the input image relative to the output image
    mask = poly2mask(x_box, y_box, dimensions(1), dimensions(2));
    
    % Initialize the output image
    imgOut = zeros(dimensions);
    imgOut(y_min : (y_min + height - 1), x_min : (x_min + width - 1)) = imgIn;
    
    % Fill out the rest of the image
    imgOut = regionfill(imgOut, ~mask);
end