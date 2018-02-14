%% Initialize the workspace
clear, close all;

%% Load the transform
imgRGB = imread('../../img/alphabet_li_1.jpg'); 
%imgRGB = imread('../../img/res_cap1.jpg');
imgGray = rgb2gray(imgRGB);

%% Find the segments in the image
[imgCC, imgBW] = find_segments(imgGray);
return;

%% Process the image

%  Crop out the unnecessary parts of the image
imgMid = imcrop(imgGray);

%  Median filter to denoise (optional)
imgMid = medfilt2(imgMid);
figure, clf;
imshow(imgMid);

%  Binarize the image using blocks of 256x256 pixels
imgBW = block_binarize(imgMid, [2 2] .^ 4);
figure, clf;
imshow(imgBW);
