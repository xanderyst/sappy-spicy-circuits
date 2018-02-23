resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'resistor');
trainingData = objectDetectorTrainingData(resGroundTruth);
summary(trainingData)
acfDetector = trainACFObjectDetector(trainingData);
I = imread('data/xan_test/testing3.jpg');
bboxes = detect(acfDetector,I);
annotation = acfDetector.ModelName;
I = insertObjectAnnotation(I,'rectangle',bboxes,annotation);
figure 
imshow(I)
