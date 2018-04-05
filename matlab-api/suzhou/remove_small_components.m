function outCC = remove_small_components(inCC, smallSize)
% outCC = remove_small_components(inCC, smallSize)
%
% Iterates through the connected components to remove all the small
% components smaller than a specified size.
%
% Inputs:
% - inCC = connected components structure
% - smallSize = value defining smallest area that you want to keep
%
% Outputs:
% - outCC = connected components structure with small components removed
%
% Written by:
% Suzhou Li

    % Check the input arguments
    if (nargin == 1)
        smallSize = 100;
    end
    
    % Initialize the output
    outCC = inCC;
    
    % Iterate through the components
    i = 1;
    while (i <= numel(outCC))
        
        % If the area is smaller than the specified size
        if (outCC(i).Area <= smallSize)
            
            % Remove the component
            outCC(i) = [];
            
            % Decrement i
            i = i - 1;
        end
        
        % Increment i
        i = i + 1;
    end
end