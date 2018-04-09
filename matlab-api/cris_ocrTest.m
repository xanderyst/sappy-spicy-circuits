% J = imread('capseries.png');
figure(3); clf
imshow(J)
BW = imbinarize(J);


BW = ~BW;
CC = bwconncomp(BW);
 
[biggest, idx] = max(cellfun(@numel, CC.PixelIdxList));
BW(CC.PixelIdxList{idx}) = 0;
figure(1); clf
imshow(BW)

results = ocr(BW, 'TextLayout', 'Block');

WBB = results.WordBoundingBoxes;
Iocr         = insertObjectAnnotation(J, 'rectangle', ...
                           results.WordBoundingBoxes, ...
                           results.Words);
figure(2); clf                       
imshow(Iocr)

valArray = [];

for i = 1:size(WBB,1)-1
    j = i + 1;
    if abs((WBB(i,1)+WBB(i,3))-WBB(j,1)) <= 20 
        x = char(strcat(results.Words(i), {' '}, results.Words(j)));
        x = string(x);
        valArray = [valArray x];
    end
end

        
    


                     
                     