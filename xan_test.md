# ACF Object Detector
- Based on https://www.mathworks.com/help/vision/ref/acfobjectdetector.html
- To add images, open image labeler app, load imageLabelingSession.mat. Then, load an image from your computer and start labeling. Once done with labeling, export the labels as a file named groundTruth.mat under 'data/xan_test/'
- To run the ACF object detector, run xander_test.m

# Cascade Object Detector
- Based on https://www.mathworks.com/help/vision/ref/traincascadeobjectdetector.html
- To add images, open image labeler app, load imageLabelingSession.mat. Then, load an image from your computer and start labeling. Once done with labeling, export the labels as a file named groundTruth.mat under 'data/xan_test/'
- Currently, we are trying to detect the resistor. Thus, to add negative images (images that don't contain the desired object), add the images that don't have resistor under 'data/xan_test/noRes'
- To run the Cascade object detector, run xan_test_cascade.m
