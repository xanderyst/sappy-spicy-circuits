resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'resistor');
trainingData = objectDetectorTrainingData(resGroundTruth);

negativeFolder = fullfile('data','xan_test','noRes');
negativeImages = imageDatastore(negativeFolder);
trainCascadeObjectDetector('resDetector.xml',trainingData, ...
    negativeFolder,'FalseAlarmRate',0.08,'NumCascadeStages',4);

detector = vision.CascadeObjectDetector('resDetector.xml');
img = imread('data/xan_test/testing6.jpg');

bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'resistor');
figure; imshow(detectedImg);
