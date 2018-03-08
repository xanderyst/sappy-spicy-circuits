function outPic = block_binarize(inPic, blockSize, conf)
% outPic = block_binarize(inPic, blockSize, conf_thresh)
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
    
    if (nargin <= 2)
        conf = 0.75;
    end
    
    block_fun = @(block_struct) process_block(block_struct.data, conf);
    outPic = blockproc(inPic, blockSize, block_fun, ...
        'UseParallel', true);
end

function outBlock = process_block(inBlock, conf)
    [thresh, eff] = graythresh(inBlock);
    
    if ((eff < conf) || (thresh > 0.85))
        thresh = 0;
    end
    
    outBlock = imbinarize(inBlock, thresh);
end