function bwOut = erase_components(bwIn, small, thresh)
% bwOut = remove_small_components_image(bwIn)
%
% Function to remove the smaller components based on the size of their
% bounding box instead of just the number of pixels in the component.
%
% Inputs:
% - bwIn = binary input image
% - small = 'small' or 'large'
% - thresh = threshold of what is small/large
%
% Output:
% - bwOut = binary output image with small/large components removed
%
% Written by:
% Suzhou Li

    % Check input arguments
    if (nargin == 2)
        thresh = 0.005;
    end

    % Initialize the output
    bwOut = bwIn;
    
    % Obtain the region properties in the form of the connected components
    img_cc = regionprops(~bwIn, 'BoundingBox', 'PixelIdxList');
    
    % Iterate through the connected components
    areas = zeros(1, numel(img_cc));
    for i = 1 : numel(img_cc)
        
        % Get the area of the bounding box
        areas(i) = img_cc(i).BoundingBox(3) * img_cc(i).BoundingBox(4);
    end
    
    % Get the maximum area
    max_area = max(areas);
    
    % Get the components that are smaller/larger than a particular area
    if strcmp(small, 'small')
        img_cc = img_cc(areas <= thresh * max_area);
    elseif strcmp(small, 'large')
        img_cc = img_cc(areas >= thresh * max_area);
    else
        error('Input not recognized');
    end
    
    % Iterate through the connected components now to remove the components
    for i = 1 : numel(img_cc)
        bwOut(img_cc(i).PixelIdxList) = 1;
    end
end