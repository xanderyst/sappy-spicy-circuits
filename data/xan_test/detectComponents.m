function [imgLabel, out] = detectComponents(name, img, imgLabel, out)
    %name is the name of the components
    %img is the input image
    %out is the output struct array of the specified components
    %resAndCapGroundTruth = load('data/xan_test/groundTruth_resCap.mat'); %load ground truth
    resAndCapGroundTruth = load('data/bencircuits_fixed.mat');
    resGroundTruth = selectLabels(resAndCapGroundTruth.gTruth, name);%select components
    trainingData = objectDetectorTrainingData(resGroundTruth,'SamplingFactor', 1);
    acfDetector = trainACFObjectDetector(trainingData,'NegativeSamplesFactor',5);
    fprintf('\n');
    fprintf('*** DONE TRAINING FOR: %s *** \n', name);
    fprintf('\n');
    %img = imread('data/xan_test/testing/testing2.jpg');
    [bboxes, scores] = detect(acfDetector, img);
    maxValue = max(scores);
    maxValue = maxValue - 15;
    for i = 1:length(scores)
       if (scores(i)> maxValue) %use 60 for resistor and 80 for capacitors
           %sprintf('%.1f\n', scores(i))
           %disp(bboxes(i,:));
           box = bboxes(i,:);
           out(end + 1).CompName = name;
           out(end).CompCentroid = floor( ...
                [(box(1) + (box(3) / 2)), ... % initialize with the
                 (box(2) + (box(4) / 2))]);   % center not centroid
           out(end).CompRect = box;
           %annotation = sprintf('Name: %s, Confidence = %.1f', name, scores(i));
           annotation = sprintf('Name: %s', name, scores(i));
           imgLabel = insertObjectAnnotation(imgLabel, 'rectangle', bboxes(i,:), annotation);
       end
    end
end
