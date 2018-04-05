%resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
resAndCapGroundTruth = load('data/xan_test/groundTruth_resCap.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'capacitor');
trainingData = objectDetectorTrainingData(resGroundTruth);
acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',2);
img = imread('data/xan_test/testing/testing2.jpg');

[bboxes, scores] = detect(acfDetector, img);

for i = 1:length(scores)
   if (scores(i)>80.0) %use 60 for resistor and 80 for capacitors
       %sprintf('%.1f\n', scores(i))
       %disp(bboxes(i,:));
       annotation = sprintf('Confidence = %.1f', scores(i));
       img = insertObjectAnnotation(img, 'rectangle', bboxes(i,:), annotation);
   end
end

figure
imshow(img)



