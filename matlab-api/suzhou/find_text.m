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
    img_mid = erase_components(imgIn, 'large');
    img_txt = ocr(img_mid, 'TextLayout', 'Block');
    
    % Iterate through the components to find the characters and the words
    % that are closest to the component
    for i = 1 : numel(components)
        
        % Find the component centroid
        comp_ctr = components(i).CompCentroid;
        
        % Iterate through the characters
        char_dist = zeros(1, numel(img_txt.Text));
        for j = 1 : numel(img_txt.Text)
            
            % Get the bounding box
            txt_box = img_txt.CharacterBoundingBoxes(j, :);
            txt_ctr = floor([ ...
                txt_box(1) + (txt_box(3) / 2), ...
                txt_box(2) + (txt_box(4) / 2)]);
            
            % Calculate the distances between the characters and the
            % bounding box
            char_dist(j) = pdist([comp_ctr; txt_ctr]);
        end
        
        % Iterate through the words
        word_dist = zeros(1, numel(img_txt.Words));
        for j = 1 : numel(img_txt.Words)
            
            % Get the bounding box
            txt_box = img_txt.CharacterBoundingBoxes(j, :);
            txt_ctr = floor([ ...
                txt_box(1) + (txt_box(3) / 2), ...
                txt_box(2) + (txt_box(4) / 2)]);
            
            % Calculate the distances between the characters and the
            % bounding box
            word_dist(j) = pdist([comp_ctr; txt_ctr]);
        end
        
        % Define the distance threshold
        thresh = 0.23 * max(char_dist);
        
        % Find the characters closest to the component
        components(i).Characters.Values = img_txt.Text(char_dist < thresh);
        components(i).Characters.BoundingBoxes = ...
            img_txt.CharacterBoundingBoxes(char_dist < thresh, :);
        
        % Define the distance threshold
        thresh = 0.22 * max(word_dist);
        
        % Find the words closest to the component
        components(i).Words.Values = img_txt.Words(word_dist < thresh);
        components(i).Words.BoundingBoxes = ...
            img_txt.WordBoundingBoxes(word_dist < thresh);
    end
    
    % Remove the small components from the image
    imgOut = erase_components(imgIn, 'small');
end