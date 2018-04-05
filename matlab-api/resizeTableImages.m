function t_out = resizeTableImages(t_in, out_folder, scale)
    % resizeTableImages     resizeTableImages takes the table input and resizes
    % the corresponding images and bounding boxes to a smaller size for the CNN

    % Set default scaling
    if nargin < 3
        scale = 1/10; % Default scale size
    end

    % Extract full file from out_folder
    s = what(out_folder);
    out_folder = s.path;
    
    % Create cell array for bounding boxes and new file names
    new_img_filenames = cell(height(t_in), 1);
    
    % Iterate through table rows
    for i = 1:height(t_in)
        img_name = t_in{i,1}{1};
        img = imread(img_name);
%         if isa(img,'uint8')
%             img = double(img);
%         end
        img_resized = imresize(img, scale);
        
        % Save resized image
        [~, raw_fname, ext] = fileparts(img_name);
        savename = fullfile(out_folder, [raw_fname ext]);
        imwrite(img_resized, savename, 'JPEG');
        new_img_filenames{i} = savename;
    end
    
    % Make new_img_filenames a table
    t_fname = table(new_img_filenames, 'VariableNames', ...
        {'imageFilename'});
    
    % Rescale all bounding boxes
    bbox_out = cellfun(@(x) ceil(scale * x), t_in{:, 2:end}, ...
        'UniformOutput', false);
    
    % Recreate table
    t_vars = t_in.Properties.VariableNames;
    t_objs = table();
    for i = 1:size(bbox_out, 2)
        t_objs = [t_objs table(bbox_out(:,i), 'VariableNames', t_vars(i+1))];
    end
    
    t_out = [t_fname t_objs];
end