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
    
    % Initialize the character set of characters we want to find
    character_set = '+-()=LRCVIFHnumckKM0123456789'; % can we find p?
    
    % Fill in the components with black box
    img_mid = fill_in_binary(imgOut, components, false);
    
    % Remove the largest component in the image
    CC = bwconncomp(~img_mid);
    [~, comp_idx] = max(cellfun(@numel, CC.PixelIdxList));
    img_mid(CC.PixelIdxList{comp_idx}) = true;
    img_mid = bwareaopen(img_mid, 8);
    
    % Get the output image
    imgOut = true(size(imgIn));
    imgOut(CC.PixelIdxList{comp_idx}) = false;
    imgOut = fill_in_binary(imgOut, components, true);
    
    % Get the text in the image
    img_ocr = ocr(img_mid, 'TextLayout', 'Block', ...
        'CharacterSet', character_set);
    img_txt.Text                   = img_ocr.Text;
    img_txt.CharacterBoundingBoxes = img_ocr.CharacterBoundingBoxes;
    img_txt.CharacterConfidences   = img_ocr.CharacterConfidences;
    img_txt.Words             = img_ocr.Words;
    img_txt.WordBoundingBoxes = img_ocr.WordBoundingBoxes;
    img_txt.WordConfidences   = img_ocr.WordConfidences;
    
    % Iterate through the characters and change all low confidence p to y
    word_count = 1; no_new = false;
    for i = 1 : numel(img_txt.Text)
        
        % If character is not a space or a new line
        if (~isnan(img_txt.CharacterConfidences(i)))
            
            % If character is a low confidence p
            if ((img_txt.Text(i) == 'p') && ... 
                (img_txt.CharacterConfidences(i) < 0.8))
                
                % Change the character
                img_txt.Text(i) = 'u';
                
                % Change the word
                word = char(img_txt.Words(word_count));
                word(word == 'p') = 'u';
                img_txt.Words(word_count) = {word};
            end
            
            % Set the no_new to true
            no_new = true;
            
        % If no new character has been found
        elseif no_new
            word_count = word_count + 1;
            no_new = false;
        end
    end
    
    % Iterate through the words to remove them from the output image
    mask = false(size(imgIn));
    for i = 1 : numel(img_txt.Words)
        % Get the box coordinates for the word
        bound = img_txt.WordBoundingBoxes(i, :);
        x_box = [bound(1), bound(1)+bound(3), bound(1)+bound(3), bound(1)];
        y_box = [bound(2), bound(2), bound(2)+bound(4), bound(2)+bound(4)];
        
        % Add the mask onto the current mask
        mask = mask | poly2mask(x_box,y_box,size(imgIn,1),size(imgIn,2));
    end
    
    % Remove the words from the image
    imgOut = imgIn;
    imgOut(mask) = 1;
    
    % Remove the small components from the image
    %imgOut = erase_components(imgOut, 'small');
    imgOut = bwareaopen(imgOut, 8);
    
    % Remove any non alphanumeric characters
    i = 1;
    while (i <= numel(img_txt.Words))
        
        % Get the mask of the letters and numbers
        alphanum_mask= isstrprop(char(img_txt.Words(i)), 'alphanum');
        
        % If all the characters are not letters or numbers
        if all(~alphanum_mask)
            img_txt.Words(i) = [];
            img_txt.WordBoundingBoxes(i, :) = [];
            img_txt.WordConfidences(i) = [];
            
        % If only some of the characters are not letters or numbers
        elseif any(~alphanum_mask)
            word = char(img_txt.Words(i));
            img_txt.Words(i) = {word(alphanum_mask)};
        end
        
        % Increment i
        i = i + 1;
    end
    
    % Group the close words together
    close_words = combine_close_words(img_txt);
    
    % Sort the components by their xmin and ymin location, such that we
    % iterate through the image left through right. We take advantage of
    % this to find the words within a particular row.
    pxl_loc = zeros(1, numel(components));
    for i = 2 : numel(components)
        pxl_loc(i) = size(imgIn, 2) * (components(i).CompRect(2) - 1) + ...
            components(i).CompRect(2);
    end
    [~, idx] = sort(pxl_loc);
    
    % Iterate through the components to find the characters and the words
    % that are closest to the component
    for i = 1 : numel(components)
        
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
            txt_box = img_txt.WordBoundingBoxes(j, :);
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
            else % if the text is on the left
                x_dist(j) = lft - txt_rgt;
            end
            
            % Calculate the distances between the closest y edges of the
            % bounding box of the characters
            if (txt_ctr(2) >= comp_ctr(2)) % if the text is on the top
                y_dist(j) = txt_btm - top;
            else % if the text is on the bottom
                y_dist(j) = btm - txt_top;
            end
            
            % Make the distance values all positive
            x_dist(j) = min(abs(x_dist(j)), abs(comp_ctr(1) - txt_ctr(1))); 
            y_dist(j) = min(abs(y_dist(j)), abs(comp_ctr(2) - txt_ctr(2)));
        end
        
        % Define the distance threshold
        x_thresh = 0.5 * components(i).CompRect(3);
        y_thresh = 0.5 * components(i).CompRect(4);
        word_thresh = 0.25 * max(word_dist);
        
        % Create the mask
        mask = ...
            (x_dist <= x_thresh) & ...
            (y_dist <= y_thresh) & ...
            (word_dist < word_thresh);
        
        % Find the grouped words
        for j = unique(close_words(mask))
            mask = mask | (close_words == j);
        end
        
        components(i).Words.Values = img_txt.Words(mask);
        components(i).Words.BoundingBoxes = ...
            img_txt.WordBoundingBoxes(mask, :);
    end
    figure;
    imshow(imgOut);
end