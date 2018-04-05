function outCC = recover_crop_indices(inCC, cropBox)
% outCC = recover_crop_indices(inCC, cropBox)
% 
% Function to recover the indices of the image in relation to the original
% image instead of in relation to the croppped image.
%
% Inputs:
% - inCC = vector of connected component structures containing the original
%          indices that are related to the cropped image
% - cropBox = 1x4 vector containing the rectangular indices of the crop in
%             the form of [x_min, y_min, width, height]
%
% Output:
% - outCC = vector of connected component structures containing the new
%           indices that are related to the original full image
%
% Written by:
% Suzhou Li

    outCC = inCC;
    
    x_corner = cropBox(1);
    y_corner = cropBox(2);
    
    for i = 1 : numel(inCC)
        outCC(i).Centroid(1) = outCC(i).Centroid(1) + x_corner;
        outCC(i).Centroid(2) = outCC(i).Centroid(2) + y_corner;
        outCC(i).BoundingBox(1) = outCC(i).BoundingBox(1) + x_corner;
        outCC(i).BoundingBox(2) = outCC(i).BoundingBox(2) + y_corner;
    end
end