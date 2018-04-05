%% Load / create your data
% Load small data
T = load('data/small_table.mat');
T = T.Tout;

% Create small data from Imds
% T = loadImds2Table('../data/cap_is.mat');
% % Convert table to smaller image
% T = resizeTableImages(T, 'img/resized');

%% Initiaize parameters
height = 32;
width = 32;
numChannels = 3; % Make this a gray scale learner
numImageCategories = size(T, 2); % Number of categories + 1

imageSize = [height width numChannels];
inputLayer = imageInputLayer(imageSize);

filterSize = [3 3];
numFilters = 32;

%% Define middle layers
middleLayers = [

% The first convolutional layer has a bank of 32 5x5x3 filters. A
% symmetric padding of 2 pixels is added to ensure that image borders
% are included in the processing. This is important to avoid
% information at the borders being washed away too early in the
% network.
convolution2dLayer(filterSize, numFilters, 'Padding', 2)

% Note that the third dimension of the filter can be omitted because it
% is automatically deduced based on the connectivity of the network. In
% this case because this layer follows the image layer, the third
% dimension must be 3 to match the number of channels in the input
% image.

% Next add the ReLU layer:
reluLayer()
convolution2dLayer(filterSize, numFilters, 'Padding', 1)
reluLayer()
maxPooling2dLayer(3, 'Stride', 2)

% Follow this with a max pooling layer that has a 3x3 spatial pooling area
% and a stride of 2 pixels. This down-samples the data dimensions from
% 32x32 to 15x15.
% maxPooling2dLayer(3, 'Stride', 2)

% % Repeat the 3 core layers to complete the middle of the network.
convolution2dLayer(filterSize, numFilters, 'Padding', 2)
reluLayer()
maxPooling2dLayer(3, 'Stride',2)

convolution2dLayer(filterSize, 2 * numFilters, 'Padding', 2)
reluLayer()
maxPooling2dLayer(3, 'Stride',2)

];

%% Define final layer
finalLayers = [

% Add a fully connected layer with 64 output neurons. The output size of
% this layer will be an array with a length of 64.
fullyConnectedLayer(64)

% Add an ReLU non-linearity.
reluLayer()

% Add the last fully connected layer. At this point, the network must
% produce 10 signals that can be used to measure whether the input image
% belongs to one category or another. This measurement is made using the
% subsequent loss layers.
fullyConnectedLayer(numImageCategories)

% Add the softmax loss layer and classification layer. The final layers use
% the output of the fully connected layer to compute the categorical
% probability distribution over the image classes. During the training
% process, all the network weights are tuned to minimize the loss over this
% categorical distribution.
softmaxLayer
classificationLayer
];

%% Combine the layers
layers = [
    inputLayer
    middleLayers
    finalLayers
    ];

% data = load('fasterRCNNVehicleTrainingData.mat');
% layers = data.layers;
% layers(2).Weights = 0.0001 * randn([filterSize numChannels numFilters]);
%% 
% Set the network training options
% opts = trainingOptions('sgdm', ...
%     'Momentum', 0.9, ...
%     'InitialLearnRate', 1e-4, ...
%     'LearnRateSchedule', 'piecewise', ...
%     'LearnRateDropFactor', 0.1, ...
%     'LearnRateDropPeriod', 8, ...
%     'L2Regularization', 0.004, ...
%     'MaxEpochs', 40, ...
%     'MiniBatchSize', 128, ...
%     'Verbose', true);

opts = trainingOptions('sgdm', ...
    'InitialLearnRate', 1e-6, ...
    'MaxEpochs', 40, ...
    'Verbose', true,....
    'MiniBatchSize', 128);

%% Establish training data
data = load('fasterRCNNVehicleTrainingData.mat');
tdat = struct('T', T, 'layers', layers, 'opts', opts);

%% Train detector
detector = trainFasterRCNNObjectDetector(tdat.T, tdat.layers, tdat.opts, ...
    'PositiveOverlapRange', [0.5 1]);

%% Test detector
imtest = imread('img/resized/LVI_1.jpg');
[bbox, score, label] = detect(detector, imtest);

detectedImTest = insertShape(imtest, 'Rectangle', bbox);

figure
imshow(detectedImTest)