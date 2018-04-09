function out = detectComponents(name, img)
    %name is the name of the components
    %img is the input image
    %out is the output struct array of the specified components
    %resAndCapGroundTruth = load('data/xan_test/groundTruth_resCap.mat'); %load ground truth
    resAndCapGroundTruth = load('data/bencircuits_fixed.mat');
    resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth, name);%select components
    trainingData = objectDetectorTrainingData(resGroundTruth);
    acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',2);
    %img = imread('data/xan_test/testing/testing2.jpg');
    [bboxes, scores] = detect(acfDetector, img);
    out = [];
    maxValue = max(scores);
    maxValue = maxValue - 10;
    for i = 1:length(scores)
       if (scores(i)> maxValue) %use 60 for resistor and 80 for capacitors
           %sprintf('%.1f\n', scores(i))
           %disp(bboxes(i,:));
           box = bboxes(i,:);
           out(end + 1).CompName = name;
           out(end).CompCentroid = floor( ...
                [(box(1) + (box(3) / 2)), ... % initialize with the
                 (box(2) + (box(4) / 2))]);   % center not centroid
           out(end).CompLocation = box;
           annotation = sprintf('Name: %s, Confidence = %.1f', name, scores(i));
           img = insertObjectAnnotation(img, 'rectangle', bboxes(i,:), annotation);
       end
    end
%     figure
%     imshow(img)
end
