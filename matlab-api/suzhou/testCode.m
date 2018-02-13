%% Initialize the workspace
clear, close all;

%% Load the transform
imgRGB = imread('../../img/res_cap1.jpg');
imgGray = rgb2gray(imgRGB);

%% Process the image

%  Median filter to denoise (optional)
imgMid = medfilt2(imgGray);
figure, clf;
imshow(imgMid);

%  Binarize the image using blocks of 256x256 pixels
imgBW = block_binarize(imgMid, [2 2] .^ 8);
figure, clf;
imshow(imgBW);