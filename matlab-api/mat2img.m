function mat2img(infile, outfolder)
figure(1);clf;
imdata = load(infile);

for i = 1:size(imdata.X, 1)
    crismat = vec2mat(imdata.X(i,:),32); 
    imshow(crismat)
    filename = sprintf('img%d.jpg', i);
    if imdata.Y(i) == 0
        filename = strcat(outfolder, '/res/', 'res_', filename);
    end
    if imdata.Y(i) == 1
        filename = strcat(outfolder, '/cap/', 'cap_', filename);
    end
    saveas(gcf, filename);
    title(sprintf('Image %d', i))
    clf;
end

end