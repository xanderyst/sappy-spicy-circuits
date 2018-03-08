function outBen = suzhou_to_ben(inCC)
% outBen = suzhou_to_ben(inCC) 
%
% Converts the output from Suzhou's format to Ben's format
%
% Input:
% - inCC = Nx1 vector of connected component structures in Suzhou's format
%
% Output:
% - outBen = Nx4 matrix of indices where each row has 
%            [x_center y_center width height]
% 
% Written by:
% Suzhou Li
    
    % Initialize the output matrix
    outBen = zeros(numel(inCC), 4);
    
    % Iterate through the output matrix
    for i = 1 : numel(inCC)
        
        % Get the indexes of the bounding box in terms of Ben's matrix
        x_ctr = inCC(i).centroid(1);
        y_ctr = inCC(i).centroid(2);
        width  = inCC(i).BoundingBox(3);
        height = inCC(i).BoundingBox(4);
        
        % Input the indices into the output matrix
        outBen(i, :) = [x_ctr, y_ctr, width, height];
    end
end