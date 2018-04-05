resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'resistor');
trainingData = objectDetectorTrainingData(resGroundTruth);
acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',2);
I = imread('data/xan_test/testing3.jpg');
bboxes = detect(acfDetector,I);
annotation = acfDetector.ModelName;
I = insertObjectAnnotation(I,'rectangle',bboxes,annotation);
figure 
imshow(I)
