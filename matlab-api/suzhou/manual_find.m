function [components] = manual_find(imgIn)
% components = manual_components_box(imgIn)
%
% Function to manually draw boxes around the components and extract the
% components in those boxes. Does not identify the components.
% 
% Written By:
% Suzhou Li
    
    % Initialize the global get_components
    global get_components;
    get_components = true;
    
    % Display the image on a new figure
    fig = figure; clf; % initialize figure and store figure handle
    imshow(imgIn); % display the actual grayscale image
    
    % Initialize the string array containing the component names
    component_names = {'Current Source', 'Voltage Source', ...
        'Inductor', 'Capacitor', 'Resistor'};
    
    % Initialize the output vector
    components = [];
    
    % Create the finish button
    uicontrol('Style', 'pushbutton', 'String', 'Done', 'Callback', @finish_selection);
    
    % While you are still trying to acquire components
    hold on
    while (1)
        
        % Get the rectangle's boundaries that the user chooses
        box = getrect(fig);
        
        if ~get_components
            close;
            return;
        end
        
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
        
        % Put the component properties in
        components(end + 1).CompCentroid = floor( ...
            [(box(1) + (box(3) / 2)), ... % initialize with the
             (box(2) + (box(4) / 2))]);   % center not centroid
        components(end).CompRect = box;
        components(end).CompImage = imcrop(imgIn, box);
    end
    hold off
    
    % Create function to end the loop
    function finish_selection(source, event)
        
        % Force rectangle recognition to end
        global GETRECT_H1
        set(GETRECT_H1, 'UserData', 'Completed');
        
        % Exit the big loop
        get_components = false;
    end
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