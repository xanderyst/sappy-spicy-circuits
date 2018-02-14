function show_object_boundaries(imgBW, imgCC)
% show_object_boundaries(imgBW, imgCC)
%
% Function that shows the component boundaries.
%
% Inputs:
% - imgBW = matrix containing the pixel values for the binarized image
% - imgCC = vector of connected component structures
%
% Written by:
% Suzhou Li
    
    %% Initialize the figure
    figure, clf;
    
    %% Show the binarized image
    imshow(imgBW);
    
    %% Plot the rectangle boundaries
    hold on
    for cc = 1 : numel(imgCC)
        rectangle('Position', imgCC(cc).BoundingBox, 'EdgeColor', 'b');
    end
    hold off
end
