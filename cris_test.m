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

%% gimme a bag of features
[train, validate] = splitEachLabel(imds, 0.8, 'randomize');
% bag = bagOfFeatures(train);

%% can i modify this bag
cornerFcn = @cornerFeatureExtractor;

corner_bag = bagOfFeatures(train, 'CustomExtractor', cornerFcn);
%% test it
catClass = trainImageCategoryClassifier(train, corner_bag);
confMatrix = evaluate(catClass, train);