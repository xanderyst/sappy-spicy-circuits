function out = pad_to_square(in)
% out = pad_to_square(in)
%
% Function to pad the input image with zeros until the image is square.
%
% Input:
% - in = input image
%
% Output:
% - out = output image that is a square version of the input image

    % Initialize the output image
    out = in;
    
    % If there are more columns, pad columns until square
    if (size(out, 1) > size(out, 2))
        lft_pad = floor((size(out, 1) - size(out, 2)) / 2);
        rgt_pad = floor((size(out, 1) - size(out, 2) + 1) / 2);
        out = padarray(out, [0 lft_pad], false, 'pre');
        out = padarray(out, [0 rgt_pad], false, 'post');

    % If there are more rows, pad rows until square
    else
        top_pad = floor((size(out, 2) - size(out, 1)) / 2);
        btm_pad = floor((size(out, 2) - size(out, 1) + 1) / 2);
        out = padarray(out, [top_pad 0], false, 'pre');
        out = padarray(out, [btm_pad 0], false, 'post');
    end
end