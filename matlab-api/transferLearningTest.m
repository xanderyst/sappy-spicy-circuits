%% Load / create your data
% Load small data
T = loadImds2Table('data/ashwin_labels2.mat');
T = resizeTableImages(T, '../img/resized', 1/7);


% Create small data from Imds
% T = loadImds2Table('../data/cap_is.mat');
% % Convert table to smaller image
% T = resizeTableImages(T, 'img/resized');

%% Perform transfer learning modification
net = alexnet;
% layersTransfer = net.Layers(1:end-3);
% numImageCategories = size(T, 2); % Number of categories + 1
% layers = [
%     layersTransfer
%     fullyConnectedLayer(numImageCategories,'WeightLearnRateFactor',20,'BiasLearnRateFactor',20)
%     softmaxLayer
%     classificationLayer];


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
    'Momentum', 0.9, ...
    'InitialLearnRate', 1e-6, ...
    'MaxEpochs', 400, ...
    'Verbose', true,....
    'MiniBatchSize', 128);

%% Establish training data
%data = load('fasterRCNNVehicleTrainingData.mat');
% tdat = struct('T', T, 'layers', layers, 'opts', opts);
tdat = struct('T', T, 'layers', net, 'opts', opts);

%% Train detector
detector = trainFasterRCNNObjectDetector(tdat.T, tdat.layers, tdat.opts, ...
    'PositiveOverlapRange', [0.5 1]);

%% Test detector
imtest = imread('img/resized/LVI_1.jpg');
[bbox, score, label] = detect(detector, imtest);

detectedImTest = insertShape(imtest, 'Rectangle', bbox);

figure
imshow(detectedImTest)