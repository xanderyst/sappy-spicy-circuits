function Tout = loadImds2Table(filename)
% loadImds2Table    loadImds2Table loads a saved file acquired from
% imageLabeler and converts it to the table format expected for
% trainFasterRCNNObjectDetector
s = load(filename); % Loads gTruth
gTruth = s.gTruth;
imgTable = table(gTruth.DataSource.Source, 'VariableNames', {'imageFilename'});
Tout = [imgTable gTruth.LabelData];

end