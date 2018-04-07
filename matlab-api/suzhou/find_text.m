function [imgOut, components] = find_text(imgIn, components)
% [imgOut, components] = find_text(imgIn, components)
%
% Finds the associated text for each component from the inputted binary
% image, which has the electronic components removed.
%
% Inputs:
% - imgIn = binary image with the electronic components removed
% - components = vector of components
%
% Output:
% - imgOut = binary image with just the nodes
% - components = vector of components with the text properties
%
% Written by:
% Suzhou Li

    % Binarize the image
    imgOut = imbinarize(imgIn, 'adaptive', ...
        'ForegroundPolarity', 'dark', 'Sensitivity', 0.5); 
    
    % Get the text in the image
    img_mid = erase_components(imgOut, 'large');
    img_txt = ocr(img_mid, 'TextLayout', 'Block');
    
    % Sort the components by their xmin and ymin location, such that we
    % iterate through the image left through right. We take advantage of
    % this to find the words within a particular row.
    pxl_loc = zeros(1, numel(components));
    for i = 1 : numel(components)
        pxl_loc(i) = size(imgIn, 2) * (components(i).CompRect(2) - 1) + ...
            components(i).CompRect(2);
    end
    [~, idx] = sort(pxl_loc);
    
    % Iterate through the components to find the characters and the words
    % that are closest to the component
    for i = idx
        
        % Find the component centroid and the borders of the component
        comp_ctr = components(i).CompCentroid;
        [lft, top, rgt, btm] = boundingBox_to_borders( ...
            components(i).CompRect);
        
        % Iterate through the words
        x_dist = zeros(1, numel(img_txt.Words));
        y_dist = zeros(1, numel(img_txt.Words));
        word_dist = zeros(1, numel(img_txt.Words));
        for j = 1 : numel(img_txt.Words)
            
            % Get the center and the bounding box
            txt_box = img_txt.CharacterBoundingBoxes(j, :);
            txt_ctr = floor([ ...
                txt_box(1) + (txt_box(3) / 2), ...
                txt_box(2) + (txt_box(4) / 2)]);
            [txt_lft, txt_top, txt_rgt, txt_btm]= ...
                boundingBox_to_borders(txt_box);
            
            % Calculate the Cartesian distances between the characters and 
            % the bounding box
            word_dist(j) = pdist([comp_ctr; txt_ctr]);
            
            % Calucate the distances between the closest x edges of the
            % bounding box of the characters
            if (txt_ctr(1) >= comp_ctr(1)) % if the text is on the right
                x_dist(j) = txt_lft - rgt;
            else % if the txt is on the left
                x_dist(j) = lft - txt_rgt;
            end
            
            % Calculate the distances between the closest y edges of the
            % bounding box of the characters
            if (txt_ctr(2) >= comp_ctr(2)) % if the text is on the top
                y_dist(j) = txt_btm - top;
            else % if the text if on the bottom
                y_dist(j) = btm - txt_top;
            end
            
            % Make the distance values all positive
            x_dist = abs(x_dist); y_dist = abs(y_dist);
        end
        
        % Define the distance threshold
        x_thresh = 0.5 * components(i).CompRect(3);
        y_thresh = 0.5 * components(i).CompRect(4);
        
        % Create the mask
        mask = (x_dist < x_thresh) & (y_dist < y_thresh).
        
        % Find the words closest to the component
        components(i).Words.Values = img_txt.Words(mask);
        components(i).Words.BoundingBoxes = ...
            img_txt.WordBoundingBoxes(mask);
    end
    
    % Remove the small components from the image
    imgOut = erase_components(imgIn, 'small');
end