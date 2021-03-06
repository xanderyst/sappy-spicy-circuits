function [imgOut, components] = obtain_circuit_data(imgIn, components)
% imgOut = obtain_circuit_data(imgIn)
%
% Function to separate and classify all the circuit data. The process to
% use this function is as listed in the following steps.
%   (1) Draw a box around just the component, do not include anything else.
%   (2) Double click on the type of the component that was just selected.
%   (3) When prompted if there are more components, click yes if there are
%       more components and no if there are no more components.
%   (4) Repeat steps 1 to 3 until there are no more components.
%
% Input:
% - imgIn = image file name or matrix containing the image pixel data
%
% Outputs:
% - imgOut = image (nothing special about this image)
% - components = struct array with each struct containing the properties:
%   - CompName = name of the component, currently limited to the following:
%           + Current Source
%           + Voltage Source
%           + Inductor
%           + Resistor
%           + Capacitor
%   - CompCentroid = centroid of the component
%   - CompRect = 4x1 vector denoting the rectangle surrounding the
%                component in the form: [min x, min y, width, height]
%   - Characters = properties of the characters associated with the
%                  component
%       - Values = character array of the characters that are closest to
%                  the particular component 
%       - BoundingBoxes = rectangle surrounding the characters in the form:
%                         [minimum x, minimum y, width, height]
%   - Words = properties of the words associated with the component
%       - Values = cell array containing strings denoting the words that
%                  are closest to the particular component
%       - BoundingBoxes = rectangle surrounding the words in the form:
%                         [minimum x, minimum y, width, height]
%   - CompNodes = nodes that are connected to the component, should be a
%                 2x1 vector (if not, then there is something wrong)
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

    % Find the components
    if (nargin == 1)
        %[components, imgOut] = manual_detect_components(imgIn);
        % try running imgIn = imread('data/xan_test/testing/RC_demo.png');
        initialComponent = [];
        [imgLabel, components] = detectComponents('Capacitor', imgIn, imgIn, initialComponent);
        [imgLabel, components] = detectComponents('Resistor', imgIn, imgLabel, components);
        [imgLabel, components] = detectComponents('VoltageSource', imgIn, imgLabel, components);
        %[imgLabel, components] = detectComponents('CurrentSource', imgIn, imgLabel, components);
        %[imgLabel, components] = detectComponents('Inductor', imgIn, imgLabel, components);
        imgOut = imgIn;
    % Check if the image is RGB
    elseif (size(imgIn, 3) ~= 1)
        imgOut = rgb2gray(imgIn);
    else
        imgOut = imgIn;
        % Using Ben's method on single component images
        %components = manual_find(imgIn);
        %components = detectFromCompStruct(components);
    end
    
    % Initialize the output image
    imgOut = imgIn;
    
    % Remove the electronic components from the input image
    [imgOut, components] = remove_components(imgOut, components);
    
    % Find the text associated with the input image
    [imgOut, components] = find_text(imgOut, components);
    
    % Get the associated nodes for each electronic component
    [imgOut, components] = find_nodes(imgOut, components);
    
    % Show the circuit data
    show_circuit_data(imgIn, imgOut, components);
end
