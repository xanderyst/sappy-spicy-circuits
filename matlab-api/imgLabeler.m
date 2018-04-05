imgFolder = fullfile('..', 'img', 'orig');
imds = imageDatastore(imgFolder);

% Make sure to save images when selection is done!
imageLabeler(imds) 