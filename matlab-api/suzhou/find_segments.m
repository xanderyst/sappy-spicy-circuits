function [imgCC, outPic] = find_segments(inPic)
% [imgCC, outPic] = find_segments(inPic)
%
% Function to find different connected segments in the picture.
%
% Inputs:
% - inPic = matrix containing the pixel values for the RGB or grayvalue
%           images
%
% Outputs:
% - imgCC = connected components structure containing the following
%           parameters:
%   - Area = actual number of pixels in the region
%   - BoundingBox = rectangle coordinates containing the region of the
%                   connected components in the image
%   - Centroid = center of mass of the region of the connected components
%                in the image
% - outPic = matrix containing the logic values of the binarized image 
%
% Written by:
% Suzhou Li

    %% Make the image grayscale
    if (size(inPic, 3) ~= 1)
        inPic = rgb2gray(inPic);
    end
    
    %% Crop the image
    inPic = imcrop(inPic);
    close;
    
    %% Binarize and smooth the image
    midPic = block_binarize(inPic, [2 2] .^ 6);
    midPic = imclose(~midPic, strel('disk', 5));
    midPic = bwareaopen(midPic, 20);
    outPic = ~midPic;
    
    %% Find the different segments
    connected = bwconncomp(midPic);
    imgCC = regionprops(connected, ...
        'Area', 'BoundingBox', 'Centroid', 'Image');
    
    %% Show the labeled image
    show_object_boundaries(outPic, imgCC);
    
    %% Skip the rest of the code
    return;
    
    %% Self made connected component finding code (probably no good)
    
    %  Pad the matrix with 0's
    midPic = [true(size(midPic, 1), 1), midPic, true(size(midPic, 1), 1)];
    midPic = [true(1, size(midPic, 2)); midPic; true(1, size(midPic, 2))];
    
    %  Initialize the variables
    outPic = false(size(midPic)); % matrix to hold segment values
    curr_seg = 0; % initialize the current segment value
    
    %  Iterate through the image
    for row = 2 : size(midPic, 1) - 1
        for col = 2 : size(midPic, 2) - 1
            
            % If there is an element at the pixel
            if (midPic(row, col) == 0)
                
                % Get the box of neighboring pixel values and neighboring
                % currently found segments
                box = midPic(row - 1 : row + 1, col - 1 : col + 1);
                box(2, 2) = 0;
                seg_box = outPic(row - 1 : row + 1, col - 1 : col + 1);
                
                % If there are neighboring pixels
                if any(box(:) == 0)
                    
                    % If there is a segment in the surrounding box
                    if any(seg_box(:)) 
                        seg = seg_box(seg_box ~= 0);
                        seg = seg(1);
                        
                    % If there has not been a segment found in the
                    % surrounding box
                    else
                        curr_seg = curr_seg + 1;
                        seg = curr_seg;
                    end
                    
                    % Name the pixel as the specified segment
                    outPic(row, col) = seg;
                end
            end
        end
    end
    
    outPic = outPic(2 : size(inPic, 1) + 1, 2 : size(inPic, 2) + 1);
end