%% making some images
% for i = 1:size(cris.X, 1)
%     crismat = vec2mat(cris.X(i,:),32);
%     figure(i); 
%     imshow(crismat)
%     filename = sprintf('%s_%d.jpg', 'image', i);
%     filename = strcat('data/cris_img/', filename);
%     saveas(gcf, filename);
% end

%% image data store works??
% imds = imageDatastore('data/cris_img', 'IncludeSubFolders', true, 'FileExtensions', '.jpg', 'LabelSource', 'foldernames')

%% gimme a bag of features
[train, validate] = splitEachLabel(imds, 0.8, 'randomize');
bag = bagOfFeatures(train);
catClass = trainImageCategoryClassifier(train, bag);
confMatrix = evaluate(catClass, train);