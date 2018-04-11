function gTruth2imgFolders(gTruth, outfolder, resizeShape)
% gTruth2imgFolders     Takes a gTruth struct object (as outputted from
% imgLabeler) and creates images in subfolders as given by the names in the
% table columns 
% 
% gTruth structure:
%   - DataSource (groundTruthDataSource)
%       - Source (cell array of file names)
%   - LabelDefinitions (table)
%   - LabelData (table)

if nargin < 3
    resizeShape = 0;
end

if ~exist(outfolder, 'dir')
    mkdir(outfolder)
end
% Get useful data
filenames = gTruth.DataSource.Source;
bboxTable = gTruth.LabelData;

% Go through filenames
for i = 1:length(filenames)
    % Load original image
    img = imread(filenames{i});
    
    % Go through all variables for that image
    var_names = bboxTable.Properties.VariableNames;
    for v = 1:length(var_names)
        % Make folder
        labelDirOut = fullfile(outfolder, var_names{v});
        if ~exist(labelDirOut, 'dir')
            mkdir(labelDirOut);
        end
        
        % Extract bboxes
        bboxes = bboxTable{i, v}{1};
        for j = 1:size(bboxes,1)
            bbox = bboxes(j, :);
            yrange = bbox(1) : bbox(1) + bbox(3);
            xrange = bbox(2) : bbox(2) + bbox(4);
            imout = img(xrange, yrange);
            
            % Save imout to new file
            [~, b, c] = fileparts(filenames{i});
            imname = fullfile(labelDirOut, [b, '_p', num2str(j), c]);
            
            if resizeShape ~= 0
                imout = imresize(imout, resizeShape);
            end
            imwrite(imout, imname, 'JPEG')
        end
    end
end
end