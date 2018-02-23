%% Go through all files in data and convert to images

mainPath = '../data';
files = dir(fullfile(mainPath, '*.mat'));

for i = 1:length(files)
    % Extract filename components
    fn = files(i).name;
    [pathname, fname, ext] = fileparts(fn);
    folderName = strcat(fname, '_img');
    
    workingFolder = fullfile(mainPath, folderName);
    
    if ~exist(workingFolder, 'dir')
        mkdir(workingFolder)
    end
    
    mat2img(fullfile(mainPath, fn), workingFolder)
end