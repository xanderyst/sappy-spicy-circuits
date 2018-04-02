J = imread('RC_example.png');
BW = imbinarize(J);

BW = ~BW;
CC = bwconncomp(BW);
 
[biggest, idx] = max(cellfun(@numel, CC.PixelIdxList));
BW(CC.PixelIdxList{idx}) = 0;

results = ocr(BW, 'TextLayout', 'Block');


Iocr         = insertObjectAnnotation(J, 'rectangle', ...
                           results.WordBoundingBoxes, ...
                           results.Words);
                       
imshow(Iocr)
                     
                     