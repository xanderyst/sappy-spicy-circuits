%resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
%resAndCapGroundTruth = load('data/xan_test/groundTruth_resCap.mat');
resAndCapGroundTruth = load('data/ashwin_labels2.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'Res');
trainingData = objectDetectorTrainingData(resGroundTruth);

negativeFolder = fullfile('data','xan_test','noRes');
negativeImages = imageDatastore(negativeFolder);
trainCascadeObjectDetector('resDetector.xml',trainingData, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',20);

detector = vision.CascadeObjectDetector('resDetector.xml');
RGB = imread('data/xan_test/testing/testing2.jpg');
img = rgb2gray(RGB);
bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'resistor');
figure; imshow(detectedImg);
