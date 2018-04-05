%resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
resAndCapGroundTruth = load('data/xan_test/groundTruth_resCap.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'resistor');
trainingData = objectDetectorTrainingData(resGroundTruth);

negativeFolder = fullfile('data','xan_test','noRes');
negativeImages = imageDatastore(negativeFolder);
trainCascadeObjectDetector('resDetector.xml',trainingData, ...
    negativeFolder,'FalseAlarmRate',0.1,'NumCascadeStages',7);

detector = vision.CascadeObjectDetector('resDetector.xml');
img = imread('data/xan_test/testing/testing.jpg');

bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'resistor');
figure; imshow(detectedImg);
