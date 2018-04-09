%resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
%resAndCapGroundTruth = load('data/xan_test/groundTruth_resCap.mat');
%resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'Res');
resAndCapGroundTruth = load('data/bencircuits_fixed.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'Resistor');
trainingData = objectDetectorTrainingData(resGroundTruth, 'SamplingFactor', 1);
acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',3);
img = imread('img/circuitImages/customTest.PNG');
%img = rgb2gray(RGB);

[bboxes, scores] = detect(acfDetector, img);
maxValue = max(scores(:));
maxValue = maxValue*0.9;
for i = 1:length(scores)
   if (scores(i)>maxValue) %use 60 for resistor and 80 for capacitors
       %sprintf('%.1f\n', scores(i))
       %disp(bboxes(i,:));
       annotation = sprintf('Confidence = %.1f', scores(i));
       img = insertObjectAnnotation(img, 'rectangle', bboxes(i,:), annotation);
   end
end

figure
imshow(img)



