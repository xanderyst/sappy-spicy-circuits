function outPic = block_binarize(inPic, blockSize, conf, thresh)
% outPic = block_binarize(inPic, blockSize, conf, thresh)
% 
% Binarizes the image in blocks.
% 
% Input:
% - inPic = matrix containing the grayscale image
% - blockSize = 1x2 vector containing length and width of the block
% - conf = confidence threshold of binarization (between 0 and 1)
%
% Output:
% - outPic = matrix containing the binarized output image
%
% Written by:
% Suzhou Li
    
    % Check the number of input arguments
    if (nargin <= 2)
        conf = 0.75;
        thresh = 0.75;
    end
    
    % Use block process to divide the image into blocks and binarize each
    % block of the image
    block_fun = @(block_struct) process_block(block_struct.data, conf, thresh);
    outPic = blockproc(inPic, blockSize, block_fun, ...
        'UseParallel', true);
end

function outBlock = process_block(inBlock, conf, thresh)

    % Obtain the threshold using Otsu's algorithm
    [th, eff] = graythresh(inBlock);
    
    % Check if the confidence is too low or the threshold is too high
    if ((eff < conf) || (th > thresh))
        th = 0;
    end
    
    % Return the binarized block
    outBlock = imbinarize(inBlock, th);
end