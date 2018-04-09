load('gTruthTable.mat');
positiveInstances = gTruthTable(:,1:2);
%positiveInstances = fullfile('data','cris_img','resistor');
negativeInstances = fullfile('data','cris_img','capacitor');
negativeFolder = imageDatastore(negativeInstances);
trainCascadeObjectDetector('resistorDetector.xml',positiveInstances, ...
    negativeFolder,'FalseAlarmRate',0.05,'NumCascadeStages',3);
detector = vision.CascadeObjectDetector('resistorDetector.xml');
img = imread('data/xan_test/testing3.jpg');
bbox = step(detector,img);
detectedImg = insertObjectAnnotation(img,'rectangle',bbox,'resistor');
figure; imshow(detectedImg);