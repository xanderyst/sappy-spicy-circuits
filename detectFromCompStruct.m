function imgArray = detectFromCompStruct(imgArray, netTrained)
% imgArray : struct array containing important field CompImage
% 
% Returns cell array of components in list according to bounding boxes

% Load trained network
if nargin < 2
    netTrained = load('data/netTrained.mat');
    netTrained = netTrained.netTrained;
end

% labels = cell(size(imgArray));
for i = 1:length(imgArray)
    im = imgArray(i).CompImage;
    
    % resize image
    im = imresize(im, [32 32]);
    im = cat(3, im, im, im); % Reshape for input?
    
    % 
    label = netTrained.classify(im);
    imgArray(i).CompName = label;
end

end