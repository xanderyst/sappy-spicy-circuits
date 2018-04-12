function components = get_component_name(components)

    % Initialize the component names
    comp_names = { ...
        'CurrentSource', ...
        'VoltageSource', ...
        'Inductor', ...
        'Resistor', ...
        'Capacitor'};
    
    % Initialize the new field
    for i = 1 : numel(components)
        components(i).CompDetect = [];
        components(i).CompDetect.Name = {};
        components(i).CompDetect.Confidence = [];
    end
    
    % Run the object detection code to find confidence for each component
    for i = 1 : numel(comp_names)
        components = get_component_confidence( ...
            components, char(comp_names(i)));
    end
    
    % Find the maximum confidence in each component and identify
    for i = 1 : numel(components)
        
        % Get the maximum confidence
        [~, idx] = max(components(i).CompDetect.Confidence);
        
        % Get the component name
        components(i).CompName = components(i).CompDetect.Name(idx);
    end
end