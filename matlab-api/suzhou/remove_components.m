function [imgOut, components] = remove_components(imgIn)
% [imgOut, components] = remove_components(imgIn)
%
% Function to remove components in an interactive method. Uses the
% regionfill() function to fill in the regions and remove the selected 
% components.
%
% Written by:
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
        
        % Get the rectangle's bounding box that the user chooses
        box = getrect(fig);
        box = [floor([box(1), box(2)]), ceil([box(3), box(4)])];
        
        % Draw a box over the selection
        rectangle('Position', box, 'EdgeColor', 'r');
        
        % Ask what component the user found
        [part, selection_made] = listdlg( ...
            'ListString', component_names, ...
            'PromptString', 'What component is this?', ...
            'SelectionMode', 'single', ...
            'Name', 'Component Selection');
        
        % Retrieve the name of the component based on the selection index
        if selection_made
            components(end + 1).CompName = component_names(part);
            components(end).CompLocation = box;
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
    
    % Initialize the mask to fill in regions
    img_w = size(imgIn, 1); img_h = size(imgIn, 2);
    mask = false(img_w, img_h);
    
    for i = 1 : numel(components)
        % Get the box for the specified component
        box = components(i).CompLocation;
        
        % Specify the vertices of the box
        x_box = [box(1), box(1) + box(3), box(1) + box(3), box(1)];
        y_box = [box(2), box(2), box(2) + box(4), box(2) + box(4)]; 
        
        % Add the mask for this component to the overall component mask
        mask = mask | poly2mask(x_box, y_box, img_w, img_h);
    end
    
    % Fill in the region to remove the component
    imgOut = regionfill(imgIn, mask);
    imshow(imgOut);
end