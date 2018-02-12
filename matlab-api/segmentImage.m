function segmentImage(filename, componentType)
    % segmentImage  segmentImage(filename, componentType) loads a .JPG
    % file of handdrawn components and allows the user to manually convert
    % all of ONE TYPE OF COMPONENT to the datastorage type. 
    %
    % data.X is a matrix where each row is a flattened 32x32, and Y is a
    % vector where each row is labeled according to the component it
    % represents (resistor (0), capacitor (1), etc.). This is the easiest
    % data type to manipulate in Matlab and allows for easy porting to
    % Python for CNN analysis.
    %
    % USAGE: Select a region around each component. When finished, exit
    % figure window and type either 'save' to save progress or 'exit'.
    % Note: gray boxes indicating the progress made of the image is not
    % saved atm.
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
    if length(size(image)) == 3
        imgray = rgb2gray(image);
    else
        imgray = image;
    end
    
    % Initialize new X and Y cell array (used for variable sizing)
    Xnew = {};
    Ynew = {};
    
    % Initialize 'stoploop' dialog box for saving 
    % FS = stoploop('Stop the loop');
    
    i = 1;
    %% Loop and Process
    % while ~FS.Stop()
    wantSave = 0;
    while 1
        try
        % Do the below if the selection window isn't canceled.
            % Select component region
            ROI = imSelectROI(imgray, 'AllowedShape', 'Square',...
                'FastReturn', 'on');
            newimg = imgray(ROI.Yrange, ROI.Xrange);

            % Gray out previous selection
            endStops = floor(length(ROI.Yrange) / 4);
            yGrayRange = ROI.Yrange(endStops:end-endStops);
            xGrayRange = ROI.Xrange(endStops:end-endStops);
            imgray(yGrayRange, xGrayRange) = 100;

            % Resize selected image, flatten and add to cell array
            newimg_resized = imresize(newimg, [32, 32]);
            Xnew{i} = newimg_resized(:)';
            Ynew{i} = label;
            i = i + 1;
        catch
            % Ask the user if new samples should be saved, discarded, or
            % 'x' was accidentally clicked
            
            validStr = 0;
            while ~validStr
                msg = sprintf(['Command window exited. Do you want to:\n',...
                    '\tSave progress (save)?\n',...
                    '\tContinue selecting (cont)?\n',...
                    '\tExit without saving (exit)?\n\t>> ']);
                    result = input(msg, 's');
                switch lower(result)
                    case 'save'
                        wantSave = 1;
                        validStr = 1;
                    case 'cont'
                        fprintf('Continuing to select images\n');
                        validStr = 1;
                    case 'exit'
                        fprintf('Exiting without saving... %d samples lost\n', length(Ynew))
                        return
                    otherwise
                        fprintf('Please enter a valid answer\n');
                        continue
                end
            end
        end
        
        % If you want to save, break loop and continue the program
        if wantSave
            break
        end
    end
    
    % Convert cell array to matrix
    if ~isempty(Xnew) && ~isempty(Ynew)
        Xout = cell2mat(Xnew');
        Yout = cell2mat(Ynew');
    end
    
    % Delete old saved images (assume .jpg extension)
    imgBaseName = [filename(1:end-4), '-gray'];
    delete([imgBaseName, '*.jpg']);
    
    % Save modified image
    newimgname = [imgBaseName, '_', datestr(now, 'yyyymmdd_HH.MM'), '.jpg'];
    imwrite(imgray, newimgname)
    
    %% Append to old data
    dat_fname = '../data/data.mat';
    try
        oldData = load(dat_fname);
        
        % Append new data to old data
        newData = struct('X', [oldData.X; Xout], 'Y', [oldData.Y;Yout]);
    
        % Save
        fprintf('Saving %d new samples... ', length(Yout))
        save(dat_fname, '-struct', 'newData')
        fprintf('Done!\n');
    catch ME
        if strcmp(ME.identifier, 'MATLAB:load:couldNotReadFile')
            newData = struct('X', Xout, 'Y', Yout);
        
            % Save data to file
            fprintf('Saving %d new samples... ', length(Yout))
            save(dat_fname, '-struct', 'newData')
            fprintf('Done!\n');
        else
            rethrow(ME)
        end
    end
end