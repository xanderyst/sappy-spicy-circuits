function Tout = imgAugmentor(T)
% imgAugmentor  imgAugmentor(T) will take a table formatted to the
% specificationns for passing to fasterRCNN and will modify the images to
% make a more robust training. It returns Tout, a modified table pointing
% to the new file locations with the new bounding boxes

Tout = table();

for i = 1:size(T,1)
    Tnow = modImdsShear()
    Tout = [Tout; Tnow]
end

end

function [Tout, bbox_out] = modImdsShear(filename, outfolder)


end