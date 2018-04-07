function components = manual_detect_components(imgIn)
% components = manual_components_box(imgIn)
%
% Function to manually draw boxes around the components.
% 
% Written By:
% Suzhou Li

    % If the input is a image name, load the image
    if ischar(imgIn)
        imgIn = imread(imgIn);
    end
    
    % If the image is in RGB, convert it to grayscale
    if (size(imgIn, 3) ~= 1)
        imgIn = rgb2gray(imgIn);
    end
    
    % Display the image on a new figure
    fig = figure; clf; % initialize figure and store figure handle
    imshow(imgIn); % display the actual grayscale image
    
    % Initialize the string array containing the component names
    component_names = {'Current Source', 'Voltage Source', ...
        'Inductor', 'Capacitor', 'Resistor'};
    
    % Initialize the output vector
    components = [];
    
    % While you are still trying to acquire components
    hold on
    get_components = true;
    while get_components
        
        % Get the rectangle's boundaries that the user chooses
        box = getrect(fig);
        box = [floor([box(1), box(2)]), ceil([box(3), box(4)])];
        [lft, top, rgt, btm] = boundingBox_to_borders(box);
        
        % Limit the rectangle's boundaries to the borders of the image
        lft = limit_value(lft, 1, size(imgIn, 2));
        rgt = limit_value(rgt, 1, size(imgIn, 2));
        top = limit_value(top, 1, size(imgIn, 1));
        btm = limit_value(btm, 1, size(imgIn, 1));
        
        % Convert the boundaries to a bounding box
        box(1) = lft; % minimum x
        box(2) = top; % minimum y
        box(3) = rgt - lft; % width
        box(4) = btm - top; % height
        
        % Draw a box over the selection
        rectangle('Position', box, 'EdgeColor', 'r');
        
        % Ask what component the user found
        [part, selection_made] = listdlg( ...
            'ListString', component_names, ...
            'PromptString', 'What component is this?', ...
            'SelectionMode', 'single', ...
            'Name', 'Component Selection');
        
        % Put the component properties in
        if selection_made
            components(end + 1).CompName = component_names(part);
            components(end).CompCentroid = floor( ...
                [(box(1) + (box(3) / 2)), ... % initialize with the
                 (box(2) + (box(4) / 2))]);   % center not centroid
            components(end).CompRect = box;
        else
            error('No selection made.');
        end
        
        % Ask if the user wants to keep finding components in the image
        answer = questdlg( ...
            'Are there any more components in this image?', ...
            'Verify Components', 'Yes', 'No', 'Yes');
        
        % Update get_components based on the answer that was given above
        switch answer
            case 'Yes'
                get_components = true;
            case 'No'
                get_components = false;
        end
    end
    hold off
    
end

function out = limit_value(in, min, max)
    if (in < min)
        out = min;
    elseif (in > max)
        out = max;
    else
        out = in;
    end
end