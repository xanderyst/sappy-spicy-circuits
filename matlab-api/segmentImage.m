function segmentImage(filename, componentType, init)
    % segmentImage  segmentImage(filename, componentType) loads an image
    % file of handdrawn components and allows the user to manually convert
    % all of ONE TYPE OF COMPONENT to the datastorage type. 
    %
    % data.X is a matrix where each row is a flattened 32x32, and Y is a
    % vector where each row is labeled according to the component it
    % represents (resistor (0), capacitor (1), etc.). This is the easiest
    % data type to manipulate in Matlab and allows for easy porting to
    % Python for CNN analysis.
    %
    % NOTE: stoploop works funky with the ROI code. You need to select
    % 'done' in the split second between region selects in order for the
    % loop to recognize that you want the loop to be done. Then you need to
    % select one more region before the saving will happen
    %
    % PARAMETERS:
    % 
    %   - filename  ::  Name of the image file to select regions on
    %   - componentType  ::  One of {'resistor', 'capacitor', 'inductor',
    %                      'voltage source', 'current source'}
    %   - init  ::  '1' if existing data does not already exist. '0' by
    %   default

    %%
    if nargin < 3
        init = 0;
    end
    
    %% Convert component type into label
    switch lower(componentType)
        case 'resistor'
            label = 0;
        case 'capacitor'
            label = 1;
        case 'inductor'
            label = 2;
        case 'voltage source'
            label = 3;
        case 'current source'
            label = 4;
        otherwise
            msgId = 'InvalidArg:InvalidParameter';
            msg = 'Please enter a valid componentType';
            error(msgId, '%s', msg);
    end
    
    %% Initialization
    image = imread(filename);
    imgray = rgb2gray(image);
    
    % Initialize new X and Y cell array (used for variable sizing)
    Xnew = {};
    Ynew = {};
    
    % Initialize 'stoploop' dialog box for saving 
    FS = stoploop('Stop the loop');
    
    i = 1;
    %% Loop and Process
    while ~FS.Stop()
        % Select component region
        ROI = imSelectROI(imgray, 'AllowedShape', 'Square',...
            'FastReturn', 'on');         
        newimg = imgray(ROI.Yrange, ROI.Xrange);
        
        % Resize image, flatten and add to cell array
        newimg_resized = imresize(newimg, [32, 32]);
        Xnew{i} = newimg_resized(:)';
        Ynew{i} = label;
        i = i + 1;
    end
    
    % Convert cell array to matrix
    if ~isempty(Xnew) && ~isempty(Ynew)
        Xout = cell2mat(Xnew');
        Yout = cell2mat(Ynew');
    end
    
    %% Append to old data
    dat_fname = '../data/data.mat';
    if ~init
        oldData = load(dat_fname);
        
        % Append new data to old data
        newData = struct('X', [oldData.X; Xout], 'Y', [oldData.Y;Yout]);
    
        % Save
        fprintf('Saving %d new samples... ', length(Yout))
        save(dat_fname, '-struct', 'newData')
        fprintf('Done!\n');
    else
        newData = struct('X', Xout, 'Y', Yout);
        
        % Save data to file
        fprintf('Saving %d new samples... ', length(Yout))
        save(dat_fname, '-struct', 'newData')
        fprintf('Done!\n');
    end
end