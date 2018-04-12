function components = get_component_confidence(components, name)
% components = get_component_confidence(components, name)
% 
% Runs Xander's object detection code on an image of a single component and
% gives the confidences of that component.
%
% Written by:
% Xander (see detectComponents.m)
%
% Modified by:
% Suzhou Li
    
    % Obtain the ground truth data
    ground_truth_data = load('data/bencircuits_fixed.mat');
    comp_ground_truth = selectLabels(ground_truth_data.gTruth, name);
    
    % Run the code to train the object detector
    training_data = objectDetectorTrainingData( ...
        comp_ground_truth, 'SamplingFactor', 1);
    acf_detector = trainACFObjectDetector( ...
        training_data, 'NegativeSamplesFactor', 5);
    fprintf('\n*** DONE TRAINING FOR: %s ***\n', name);
    
    % Iterate through the components to get the confidences
    for i = 1 : numel(components)
        
        % Detect the components in the image (should be just one component)
        img = components(i).CompImage;
        [boxes, scores] = detect(acf_detector, img);
        
        % Get the threshold value
        %thresh = max(scores) - 15;
        
        % Get the boxes and the scores that are above that threshold value
        %boxes = boxes(scores > thresh, :);
        %scores = scores(scores > thresh);
        
        % Get the box with the maximum score
        [max_score, max_idx] = max(scores);
        max_box = boxes(max_idx, :);
        
        % Store this data
        if (~isempty(max_score))
            components(i).CompDetect.Name(end + 1) = {name};
            components(i).CompDetect.Confidence(end + 1) = max_score;
        end
    end
end