resAndCapGroundTruth = load('data/xan_test/groundTruth.mat');
resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth,'resistor');
trainingData = objectDetectorTrainingData(resGroundTruth);
acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',2);
I = imread('data/xan_test/testing/testing2.jpg');

[bboxes, scores] = detect(acfDetector, img);

for i = 1:length(scores)
   if (scores(i)>85.0)
       sprintf('%.1f\n', scores(i))
       annotation = sprintf('Confidence = %.1f', scores(i));
       %img = insertObjectAnnotation(img, 'rectangle', bboxes(i,:), annotation);
   end
end

figure
imshow(img)



