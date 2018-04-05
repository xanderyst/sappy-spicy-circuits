function ccOut = combine_inside_components(ccIn)
% ccOut = combine_inside_components(ccIn)
%
% Function to combine any components that are inside other components.
%
% Input:
% - ccIn = input connected components structure vector
%
% Output:
% - ccOut = output connected components structure vector
%
% Written by:
% Suzhou Li

    % Initialize the output vector
    ccOut = ccIn;
    
    % Iterate through the connected components
    i = 1;
    while (i <= numel(ccOut))
        
        % Get the current connected component object
        ccI = ccOut(i);
        
        % Extract the bounding box information
        [ccI_lft, ccI_top, ccI_rgt, ccI_btm] = ...
            boundingBox_to_borders(ccI.BoundingBox);
        
        % Iterate through the connected components to compare
        j = 1;
        while (j <= numel(ccOut))
            
            % If you are looking at the same object skip this iteration
            if (i == j)
                j = j + 1;
                continue;
            end
            
            % Get the connected component object you are comparing with
            ccJ = ccOut(j);
            
            % Extract the bounding box information
            % ccJ_lft = ccJ.BoundingBox(1);
            % ccJ_top = ccJ.BoundingBox(2);
            % ccJ_rgt = ccJ_lft + ccJ.BoundingBox(3);
            % ccJ_btm = ccJ_top + ccJ.BoundingBox(4);
            ccJ_x = ccJ.Centroid(1);
            ccJ_y = ccJ.Centroid(2);
            
            % Check if the centroid of object j is within the bounding box
            % of object i
            if (((ccJ_x >= ccI_lft) && (ccJ_x <= ccI_rgt)) && ...
                ((ccJ_y >= ccI_top) && (ccJ_y <= ccI_btm)))
            
                % Remove the object
                ccOut(j) = [];
                
                % If the j is lower than i, decrement i as well
                if (j < i)
                    i = i - 1;
                end
                
                % Decrement j
                j = j - 1;
            end
            
            % Increment j
            j = j + 1;
        end
        
        % Increment i
        i = i + 1;
    end
end

