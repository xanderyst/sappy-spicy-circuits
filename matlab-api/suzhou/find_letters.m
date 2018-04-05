function outCC = find_letters(inPic)
% outCC = find_letters(inPic)
%
% Function to detect what letters are in the picture.
%
% Input:
% - inPic = matrix containing the pixels to the image
%
% Output:
% - outCC = vector of connected component structures containing the
%           following properties:
%   - Area = actual number of pixels in the region
%   - BoundingBox = rectangle coordinates containing the region of the
%                   connected components in the image
%   - Centroid = center of mass of the region of the connected components
%                in the image
%   - Letter = character denoting what letter the connected component is
%
% Written by:
% Suzhou Li

    %% Find the connected components in the picture
    [imgCC, imgBW] = find_segments(inPic);
    
    %% Find the i's and j's in order to combine the dots
    
    %  Initialize the iterating variable
    iCC = 1;
    
    %  Iterate through all the connected components
    while (iCC <= numel(imgCC))
        
        % Obtain the dot connected component
        ccDot = imgCC(iCC);
        
        % If this connected component is a dot (small)
        if (imgCC(iCC).Area < 50)
            
            % Store the old size of the connected components vector
            oldSize = numel(imgCC);
            
            % Iterate through the connected components found after the
            % current connected component
            for jCC = 1 : numel(imgCC)
                
                % Skip when you are looking at the same components
                if (iCC == jCC)
                    continue;
                end
                
                % Obtain the body connected component
                ccBody = imgCC(jCC);
                
                % Extract the information of the body
                [ccBodyLft, ccBodyTop, ccBodyRgt, ccBodyBtm] = ...
                    boundingBox_to_borders(ccBody.BoundingBox);
                ccBodyX = ccBody.Centroid(1);
                ccBodyY = ccBody.Centroid(2);
                
                % Extract the information of the dot
                [ccDotLft, ccDotTop, ccDotRgt, ccDotBtm] = ...
                    boundingBox_to_borders(ccDot.BoundingBox);
                ccDotX = ccDot.Centroid(1);
                ccDotY = ccDot.Centroid(2);
                
                % Check if this body part belongs to the dot
                if ...  % If the dot is centered between the left and right 
                    ... % boundaries of the compared segment
                    (ccDotX >= ccBodyLft - 10) && ...
                    (ccDotX <= ccBodyRgt + 10) && ...
                    ... % If the distance between the center of the dot
                    ... % and the tope of the compared segment is less than
                    ... % 10 times the size of the dot
                    ((ccBodyTop - ccDotY) <= (10 * ccDot.BoundingBox(4)))
                    
                    % Find the new centroid
                    newCtr = zeros(1, 2);
                    newCtr(1) = ((ccDot.Area * ccDotX) + ...
                        (ccBody.Area * ccDotX)) ./ ...
                        (ccDot.Area + ccBody.Area);
                    newCtr(2) = ((ccDot.Area * ccDotY) + ...
                        (ccBody.Area * ccBodyY)) ./ ...
                        (ccDot.Area + ccBody.Area);
                    
                    % Find the new boundaries
                    newBound = zeros(1, 4);
                    newBound(1) = min(ccDotLft, ccBodyLft);
                    newBound(2) = ccDotTop;
                    newBound(3) = max(ccDotRgt, ccBodyRgt) - newBound(1);
                    newBound(4) = ccBodyBtm - newBound(2);
                    
                    % Obtain the new image
                    newImg = imgBW( ...
                        newBound(2) : (newBound(2) + newBound(4)), ...
                        newBound(1) : (newBound(1) + newBound(3)));
                    
                    % Find the new area
                    newArea = sum(newImg(:));
                    
                    % Put the new connected component properties together
                    imgCC(iCC).Area = newArea;
                    imgCC(iCC).Centroid = newCtr;
                    imgCC(iCC).BoundingBox = newBound;
                    imgCC(iCC).Image = newImg;
                    
                    % Remove the component
                    imgCC(jCC) = [];
                    
                    % Backtrace the i value if i is greater than j
                    if (iCC > jCC)
                        iCC = iCC - 1;
                    end
                    
                    % Skips the rest of the for loop
                    break;
                end
            end
            
            % If no body was found remove the component
            if (numel(imgCC) == oldSize)
                imgCC(iCC) = [];
                iCC = iCC - 1;
            end
        end
        
        % Iterate the i values
        iCC = iCC + 1;
    end
    
    %% Show the new letter object boundaries
    show_object_boundaries(imgBW, imgCC);
    
    %% Load the character images
    filePath = '../../img/img_alphabet/';
    alphabet = read_alphabet_images(filePath);
    
    %% Iterate through the connected components to find the characters
    
    %  Add the Letter property to the connected component structure
    imgCC(1).Letter = '';
    
    %  Iterate through each connected component
    for iCC = 1 : numel(imgCC)
        
        % Obtain the current connected component
        currComp = imgCC(iCC);
        
        % Initialize the matrix to hold the correlation values
        corrVals = zeros(1, numel(alphabet));
        
        % Iterate through the alphabet
        for a = 1 : numel(alphabet)
            
            % Resize the current image to a square
            currImg = pad_to_square(currComp.Image);
            
            % Extract the image of the letter and scale it to the size of
            % the current connected component
            alphaImg = imresize(alphabet(a).Image, size(currImg));
            
            % Calculate the correlation
            corrVals(a) = abs(corr2(alphaImg, currImg));
        end
        
        % Store the letter
        imgCC(iCC).Letter = alphabet(corrVals == max(corrVals)).Letter;
        
        % Show the letter on the image
        hold on
        text( ...
            imgCC(iCC).BoundingBox(1) + imgCC(iCC).BoundingBox(3), ...
            imgCC(iCC).BoundingBox(2) + imgCC(iCC).BoundingBox(4), ...
            imgCC(iCC).Letter, 'FontSize', 32, 'Color', 'r');
        hold off
    end
    
    outCC = imgCC;
end