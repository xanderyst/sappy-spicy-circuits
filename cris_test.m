%% making some images
% for i = 1:size(cris.X, 1)
%     crismat = vec2mat(cris.X(i,:),32);
%     figure(i); 
%     imshow(crismat)
%     filename = sprintf('%s_%d.jpg', 'image', i);
%     if cris.Y(i) == 0
%         filename = strcat('data/cris_img/resistor/res', filename);
%     end
%     if cris.Y(i) == 1
%         filename = strcat('data/cris_img/capacitor/cap', filename);
%     end
%     saveas(gcf, filename);
% end

%% image data store works??
imds = imageDatastore('data/cris_img', 'IncludeSubFolders', true, 'FileExtensions', '.jpg', 'LabelSource', 'foldernames')
tbl= countEachLabel(imds);
minSetCount = min(tbl{:,2}); 
imds = splitEachLabel(imds, minSetCount, 'randomize');
%% gimme a bag of features

[train, validate] = splitEachLabel(imds, 0.3, 'randomize');
% bag = bagOfFeatures(train);

%% can i modify this bag
bag = bagOfFeatures(train);


%% test it
catClass = trainImageCategoryClassifier(train, bag);
confMatrix = evaluate(catClass, train);

%% Test it 2
img = imread('data/xan_test/resimage_7.jpg');
[labelIdx, scores]=predict(catClass, img);
catClass.Labels(labelIdx);