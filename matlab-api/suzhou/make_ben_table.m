function compTable = make_ben_table(components)
    
    % Get the file names
    fileNames = {components.FileName};
    fileNames = unique(fileNames);
    
    % Initialize the structure that will be changed to a table
    comp_struct = struct( ...
        'imageFilename', [], ...
        'Cap', [], ...
        'CurrentSrc', [], ...
        'Ind', [], ...
        'Res', [], ...
        'VoltageSrc', []);
    
    % Iterate through the images
    for i = 1 : numel(fileNames)
        
        % Get the image file name
        comp_struct(i).imageFilename = fileNames(i);
        
        for j = 1 : numel(components)
            
            % Is this the same component?
            if strcmp(fileNames(i), components(j).FileName)
                
                % Capacitors
                if strcmp(components(j).CompName, 'Cap')
                    comp_struct(i).Cap = components(j).CompIndex;
                    
                % Current Sources
                elseif strcmp(components(j).CompName, 'CurrentSrc')
                    comp_struct(i).CurrentSrc = components(j).CompIndex;
                    
                % Inductors
                elseif strcmp(components(j).CompName, 'Ind')
                    comp_struct(i).Ind = components(j).CompIndex;
                    
                % Resistors
                elseif strcmp(components(j).CompName, 'Res')
                    comp_struct(i).Res = components(j).CompIndex;
                    
                % Voltage Sources
                elseif strcmp(components(j).CompName, 'VoltageSrc')
                    comp_struct(i).VoltageSrc = components(j).CompIndex;
                    
                % Unknown (throw an error)
                else
                    error('Unknown component identified!');
                end
            end
        end
    end
    
    % Convert the structure to a table
    compTable = struct2table(comp_struct, 'AsArray', true);
end