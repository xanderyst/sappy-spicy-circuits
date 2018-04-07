function [imgOut, components, mask] = remove_components(imgIn, components)
% [imgOut, components] = remove_components(imgIn, components)
%
% Function to remove components in an interactive method. Uses the
% regionfill() function to fill in the regions and remove the selected 
% components.
%
% Written by:
% Suzhou Li
    
    % Initialize the mask to fill in regions
    img_w = size(imgIn, 1); img_h = size(imgIn, 2);
    mask = false(img_w, img_h);
    
    % Iterate through each component to get the overall mask
    for i = 1 : numel(components)
        
        % Get the box for the specified component
        box = components(i).CompRect;
        
        % Specify the vertices of the box
        x_box = [box(1), box(1) + box(3), box(1) + box(3), box(1)];
        y_box = [box(2), box(2), box(2) + box(4), box(2) + box(4)]; 
        
        % Add the mask for this component to the overall component mask
        mask = mask | poly2mask(x_box, y_box, img_w, img_h);
    end
    
    % Fill in the region to remove the component
    imgOut = regionfill(imgIn, mask);
    imshow(imgOut);
    
    % Get the connected components from the mask
    comp_cc = regionprops(mask, 'Centroid');
    
    % Iterate through the components to figure out what the centroids are
    for i = 1 : numel(components)
        
        % Iterate through the mask regions to get the distances
        distances = zeros(numel(comp_cc), 2);
        for j = 1 : numel(comp_cc)
            distances(j, :) = pdist( ...
                [components(i).CompCentroid; comp_cc(j).Centroid]);
        end
        
        % Get the component with the minimum distance
        [~, idx] = min(distances);
        
        % Add the data for the centroid
        components(i).CompCentroid = comp_cc(idx).Centroid;
    end
end