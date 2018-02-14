function outPic = block_binarize(inPic, blockSize)
% outPic = block_binarize(inPic, blockSize)
% 
% Binarizes the image in blocks.
% 
% Input:
% - inPic = matrix containing the grayscale image
% - blockSize = 1x2 vector containing length and width of the block
%
% Output:
% - outPic = matrix containing the binarized output image
%
% Written by:
% Suzhou Li

    block_fun = @(block_struct) process_block(block_struct.data);
    outPic = blockproc(inPic, blockSize, block_fun, ...
        'UseParallel', true);
end

function outBlock = process_block(inBlock)
    [thresh, eff] = graythresh(inBlock);
    
    if (eff < 0.75)
        thresh = 0;
    end
    
    outBlock = imbinarize(inBlock, thresh);
end