function idxClose = combine_close_words(inWords, sens)
% idxClose = combine_close_words(inWords)
%
% Function to get a mask of the words that are close to each other.
%
% Inputs:
% - inWords = OCR text object containing the words
% - sens = sensitivity defining how close the word has to be to another
%          word before they are combined
%
% Outputs:
% - idxClose = mask over the words identifying which words belong in groups
%
% Written By:
% Suzhou Li
    
    % Check the input arguments
    if (nargin == 1)
        sens = 0.35;
    end
    
    % Initialize the output
    idx = false(numel(inWords.Words));
    
    % Iterate through the words
    for i = 1 : numel(inWords.Words)
        
        % Get the first word
        i_word = char(inWords.Words(i));
        i_rect = inWords.WordBoundingBoxes(i, :);
        [i_box(1), i_box(2), i_box(3), i_box(4)] = ...
            boundingBox_to_borders(i_rect);
        
        % Iterate through the comparison words
        for j = 1 : numel(inWords.Words)
            
            % Do not compare the same word
            if (i == j) 
                continue; 
            end
            
            % Get the second word
            j_word = char(inWords.Words(j));
            j_rect = inWords.WordBoundingBoxes(j, :);
            [j_box(1), j_box(2), j_box(3), j_box(4)] = ...
                boundingBox_to_borders(j_rect);
            
            % Check if the two boxes close enought toegether
            if is_close(i_box, j_box, sens * i_rect(4))
                idx(i, j) = true;
            end
        end
    end
    
    % Initialize the variables necessary for the for loop
    curr_idx = 1;
    visited = false(1, numel(inWords.Words));
    idxClose = zeros(1, numel(inWords.Words));
    
    % Iterate through each word
    for i = 1 : numel(inWords.Words)
        
        % Clear the near vector in every iteration
        near = false(1, numel(inWords.Words));
        
        % Get the close words
        [near, visited] = find_close_words(i, near, visited, idx);
        
        % At the close words put the index in
        if any(near)
            near(i) = true;
            idxClose(near) = curr_idx;
            curr_idx = curr_idx + 1;
        elseif (~any(idx(i, :)))
            idxClose(i) = curr_idx;
            curr_idx = curr_idx + 1;
        end
    end
end

function [near, visited] = find_close_words(word, near, visited, idx)

    % If we have not already visited the current word
    if (~visited(word))
        
        % Add the current word to the visited vector
        visited(word) = true;
        
        % Iterate from the current word to the end of the vector
        for i = word : size(idx, 1)
            
            % If the current index is identified as close to the word
            if idx(word, i)
                
                % Set the index of the close word to true
                near(i) = true; 
                
                % Recursively run the code for the close word
                [near, visited] = find_close_words(i, near, visited, idx);
            end
        end
    end
end
    
function isClose = is_close(box1, box2, sens)

    % Initialize the output
    isClose = false;
    
    % Expand the box in order to 
    box1 = [box1(1)-sens, box1(2)-sens, box1(3)+sens, box1(4)+sens];
    box2 = [box2(1)-sens, box2(2)-sens, box2(3)+sens, box2(4)+sens];
    
    % Check if the left side of box1 is within the bounds of box2 or if the
    % right side of box1 is within the bounds of box2
    if (in_bound(box1(1), box2(1), box2(3)) || ...
            in_bound(box1(3), box2(1), box2(3)))
        
        % Check if the top side of box1 is within the bounds of box2 or if
        % the bottom side of box1 is within the bounds of box2
        if (in_bound(box1(2), box2(2), box2(4)) || ...
                in_bound(box1(4), box2(2), box2(4)))
            isClose = true;
        end
        
        % Check if the top side of box2 is within the bounds of box1 or if
        % the bottom side of box2 is within the bounds of box1
        if (in_bound(box2(2), box1(2), box1(4)) || ...
                in_bound(box2(4), box1(2), box1(4)))
            isClose = true;
        end
    end
    
    % Check if the left side of box2 is within the bounds of box1 or if the
    % right side of box2 is within the bounds of box1
    if (in_bound(box2(1), box1(1), box1(3)) || ...
            in_bound(box2(3), box1(1), box1(3)))
        
        % Check if the top side of box1 is within the bounds of box2 or if
        % the bottom side of box1 is within the bounds of box2
        if (in_bound(box1(2), box2(2), box2(4)) || ...
                in_bound(box1(4), box2(2), box2(4)))
            isClose = true;
        end
        
        % Check if the top side of box1 is within the bounds of box2 or if
        % the bottom side of box1 is within the bounds of box2
        if (in_bound(box2(2), box1(2), box1(4)) || ...
                in_bound(box2(4), box1(2), box1(4)))
            isClose = true;
        end
    end
end

function inBound = in_bound(value, min, max)
    inBound = (value >= min) && (value <= max);
end