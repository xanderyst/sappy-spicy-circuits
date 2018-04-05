function outCC = combine_close_components(inCC, imgBW, gap)
% outCC = combine_close_components(inCC, imgBW, gap)
%
% Inputs:
% - inCC = vector of connected component structures
% - imgBW = matrix containing the data of the binarized image
% - gap = number of pixels to allow leeway for in defining how close the 
%         components are
%
% Output:
% - outCC = vector of connected component structures with the close
%           components combined
%
% Written by:
% Suzhou Li

    % Check the number of input arguments
    if (nargin <= 2)
        gap = 0;
    end
    
    % Initialize the output
    outCC = inCC;
    
    % Iterate through the components
    i = 1;
    while (i <= numel(outCC))
        
        % Get the border of the current connected component
        [i_border(1), i_border(2), i_border(3), i_border(4)] = ...
            boundingBox_to_borders(outCC(i).BoundingBox);
        i_x = outCC(i).Centroid(1); i_y = outCC(i).Centroid(2);
        
        % Iterate through the components to compare with
        j = 1;
        while (j <= numel(outCC))
            
            % If these are the same components, then skip
            if (i == j)
                j = j + 1;
                continue;
            end
            
            % Get the border of the connected component you are comparing
            [j_border(1), j_border(2), j_border(3), j_border(4)] = ...
                boundingBox_to_borders(outCC(j).BoundingBox);
            j_x = outCC(j).Centroid(1); j_y = outCC(j).Centroid(2);
            
            % Are the two borders overlapping or close enough?
            if is_close(i_border, j_border, gap)
                
                % Find the new centroid
                newCtr = zeros(1, 2);
                newCtr(1) = ((outCC(i).Area * i_x) + ...
                    (outCC(j).Area * j_x)) ./ ...
                    (outCC(i).Area + outCC(j).Area);
                newCtr(2) = ((outCC(i).Area * i_y) + ...
                    (outCC(j).Area * j_y)) ./ ...
                    (outCC(i).Area + outCC(j).Area);

                % Find the new boundaries
                newBound = zeros(1, 4);
                newBound(1) = min(i_border(1), j_border(1));
                newBound(2) = min(i_border(2), j_border(2));
                newBound(3) = max(i_border(3), j_border(3)) - newBound(1);
                newBound(4) = max(i_border(4), j_border(4)) - newBound(2);

                % Obtain the new image
                newImg = imgBW( ...
                    floor(newBound(2)) : ...
                        (floor(newBound(2)) + ceil(newBound(4))), ...
                    floor(newBound(1)) : ...
                        (floor(newBound(1)) + ceil(newBound(3))));

                % Find the new area
                newArea = sum(newImg(:));

                % Put the new connected component properties together
                outCC(i).Area = newArea;
                outCC(i).Centroid = newCtr;
                outCC(i).BoundingBox = newBound;
                outCC(i).Image = newImg;
                
                % Remove the component
                outCC(j) = [];
                
                % If i is greater than j, then decrement i
                if (i > j)
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

function combine = is_close(b1, b2, gap)

    x_close = false;
    y_close = false;
    
    % Is the left side of b2 within the range of b1?
    if ((b2(1) >= (b1(1) - gap)) && (b2(1) <= (b1(3) + gap)))
        x_close = true;
    end
        
    % Is the right side of b2 within the range of b1?
    if ((b2(3) >= (b1(1) - gap)) && (b2(1) <= (b1(3) + gap)))
        x_close = true;
    end
        
    % Is the top of b2 within the range of b1?
    if ((b2(2) >= (b1(2) - gap)) && (b2(2) <= (b1(4) + gap)))
        y_close = true;
    end
        
    % Is the bottom of b2 within the range of b1?
    if ((b2(4) >= (b1(2) - gap)) && (b2(4) <= (b1(4) + gap)))
        y_close = true;
    end
    
    combine = x_close && y_close;
end
    