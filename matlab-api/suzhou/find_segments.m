function [imgCC, outPic] = find_segments(inPic, crop)
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
    figure, clf;
    [inPic_cropped, crop_box] = imcrop(inPic);
    close;
    
    %% Binarize and smooth the image
    midPic = imbinarize(inPic_cropped, 'adaptive', ...
        'ForegroundPolarity', 'dark', 'Sensitivity', 0.5); 
    % midPic = block_binarize(inPic_cropped, [2 2] .^ 8, 0.7, 0.7);
    midPic = imopen(midPic, strel('disk', 8));
    % midPic = medfilt2(midPic, [2 2] .^ 8); % too slow
    outPic = midPic;
    
    %% Find the different segments
    connected = bwconncomp(~midPic); % find the connected components
    imgCC = regionprops(connected, ...
        'Area', 'BoundingBox', 'Centroid', 'Image'); % extract data
    
    %% Perform other processes on the components to combine or remove
    imgCC = remove_small_components(imgCC);
    imgCC = recover_crop_indices(imgCC, crop_box);
    imgCC = pad_boxes(imgCC, 1.15);
end