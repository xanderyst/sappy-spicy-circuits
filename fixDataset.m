%% fixDataset.m
% Fix the dataset to have the correct images

FILENAME = 'data\ben_printed129imgs.mat';

load(FILENAME)
% [a, b, c] = cellfun(@(x) fileparts(x), gTruth.DataSource.Source, ...
%     'UniformOutput', false);
% 
% a(:) = {fullfile('img', 'circuitData')};

newsrc = groundTruthDataSource('img\circuitImages\');

gTruth = groundTruth(newsrc, gTruth.LabelDefinitions, gTruth.LabelData);
