%resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
%resAndCapGroundTruth = load('data/xan_test/groundTruth_resCap.mat');
%resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'Res');
resAndCapGroundTruth = load('data/bencircuits_fixed.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'Resistor');
trainingData = objectDetectorTrainingData(resGroundTruth, 'SamplingFactor', 1);
acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',5);
%img = imread('matlab-api/RC_demo.PNG');
%img = imread('img/circuitImages/c64_edit.png');
img = imread('data/xan_test/testing/testing.jpg');
%img = rgb2gray(RGB);

[bboxes, scores] = detect(acfDetector, img);
maxValue = max(scores(:));
maxValue = maxValue-15;
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



