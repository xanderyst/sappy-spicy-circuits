function alphabet = read_alphabet_images(file_path)
% alphabet = read_alphabet_images(file_path)
%
% Function to read the images of the letters in the alphabet from the
% desired folder path.
%
% Inputs:
% - file_path = string denoting the file path containing all the files of
%               the letters in the alphabet
%
% Outputs:
% - alphabet = vector of structures containing the following properties:
%   - Case = string denoting the case of the letter (upper or lower)
%   - Letter = character denoting the letter of the image
%   - Image = matrix containing pixel values to the image of the letter
%
% Written by:
% Suzhou Li

    %% Load in the file path
    file_dir = ls(file_path);
    file_dir = file_dir(3 : end, :); % do not keep the '.' and '..'
    
    %% Initialize the output vector
    alphabet = struct('Case', '', 'Letter', '', 'Image', []);
    alphabet = repmat(alphabet, size(file_dir, 1), 1);
    
    %% Iterate through the files and store the information
    for i = 1 : size(file_dir, 1)
        
        % Determine if the letter is upper case or lower case
        if contains(file_dir(i, :), 'upper')
            alphabet(i).Case = 'Upper';
        elseif contains(file_dir(i, :), 'lower')
            alphabet(i).Case = 'Lower';
        else
            alphabet(i).Case = 'Not Specified';
        end
        
        % Determine what letter it is
        alphabet(i).Letter = sscanf(file_dir(i, :), '%c_%*s.jpg');
        
        % Load the image of the letter
        img = imread([file_path file_dir(i, :)]);
        
        % If the image is not grayscale, convert to grayscale
        if (size(img, 3) ~= 1)
            img = rgb2gray(img);
        end
        
        % Store the image of the letter
        alphabet(i).Image = pad_to_square(~imbinarize(img));
    end

end