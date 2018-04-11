classes = {'Capacitor', 'CurrentSource', 'Inductor',...
    'Resistor', 'VoltageSource'};
netTrained = importKerasNetwork('data/minivggnet_indivprinted_weights32x32.hdf5', ...
    'ClassNames', classes);

%% Train network
options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.001, ...
    'Verbose',false, ...
    'Plots','training-progress');

imdsTrain = imageDatastore('img/indivPrinted/', ...
    'IncludeSubfolders', true, 'LabelSource', 'foldernames');

netTrained = trainNetwork(imdsTrain,netTrained.Layers,options);

%% Load Test Images
% imageLabeler('img/testPrinted/')

testTruth = load('data/ben_testGtruth.mat');
testTruth = testTruth.gTruth;
gTruth2imgFolders(testTruth, 'img/indivPrintedTest')

%% Test network on all images in folder
TESTFOLDER = 'img/indivPrintedTest';
imgfiles = dir(fullfile(TESTFOLDER, '*.png'));
nfiles = length(imgfiles);

for i = 1:nfiles
    fname = fullfile(imgfiles(i).folder, imgfiles(i).name);
    im = imresize(imread(fname), [32 32]);
    im = cat(3, im, im, im); % Reshape for input?
    label = classify(netTrained, im);
    figure(1);clf;
    imshow(im)
    fprintf('Label detected: %s\n', label)
    pause;
end

