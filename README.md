# sappy-spicy-circuits

## Data Collection
Inside the matlab-api folder there is a file called "segmentImage.m". This function allows you to import a handrawn component image file (example file provided in img/res_cap1.jpg), and isolate the components from it. These components are converted to grayscale and to a 32x32 image, vectorized, and saved in the data/data.mat file. Class labels are:

- Resistor (0)
- Capacitor (1)
- Inductor (2)
- Voltage Source (3)
- Current Source (4)


Usage is briefly explained in the function file itself. 

## Git information
Brief summary on how to add to git:

- Modify a file, save it.
- Use the command `git add <filename>`
- To add all files, use `git add -A`
- Then, use the command `git commit -m "Wrote instructions for Suzhou"`
    - This saves a snapshot of your directory on your computer
- To send your changes to the cloud for us to see, use the command `git push`    
- Now we can see your changes!
