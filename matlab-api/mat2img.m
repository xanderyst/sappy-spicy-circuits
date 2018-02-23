function mat2img(infile, outfolder)
% mat2img   functionized version of Cristina's code 
%
% Author: Ben Hoover
% Date: 2018-02-23

%% Initialization
subfldrs = {'res', 'cap', 'ind', 'vsrc', 'isrc'};
outfolder = strip(outfolder, 'right', '/'); 
outfolder = strip(outfolder, 'right', '\'); 
% Make folders and subfolders if nonexistant
for i = 1:length(subfldrs)
    foldname = strcat(outfolder, '/', subfldrs{i});
    if ~exist(foldname, 'dir')
        mkdir(foldname);
    end
end
%% Loop
figure(1);clf;
imdata = load(infile);

counts = zeros(5,1);

for i = 1:size(imdata.X, 1)
    fprintf('On file: %d\n', i);
    
    clf;
    immat = vec2mat(imdata.X(i,:),32); 
    imshow(immat)
    lab = imdata.Y(i) + 1; % Offset labels so indexing is possible
    counts(lab) = counts(lab) + 1;
    filename = sprintf('img%d.jpg', counts(lab)); 
    filename = strcat(outfolder, '/', subfldrs{lab}, '/res_', filename);
    saveas(gcf, filename);
end

end
