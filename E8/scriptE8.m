clear 
close all

%------------------------------------------- SET UP THE CLASSIFIER -------------------------------------------------------------

I = rgb2gray(imread('Joc_de_caracters.jpg'));
BI = I < 128;
imshow(BI)
CC = bwconncomp(BI);

props = regionprops(CC,'MajoraxisLength','MinoraxisLength','Solidity','Extent','Circularity','Eccentricity','Centroid','BoundingBox');

ratio = [props(:).MinorAxisLength]./[props(:).MajorAxisLength];
centroids = cat(1, props.Centroid);
boxes = cat(1,props.BoundingBox);
centroid_x1 = ([centroids(:,1)]'-[boxes(:,1)]');
centroid_y1 = ([centroids(:,2)]'-[boxes(:,2)]');
rel_cent_x1 = centroid_x1./[boxes(:,3)]';
rel_cent_y1 = centroid_y1./[boxes(:,4)]';

X = [ratio; props.Solidity; props.Extent; props.Eccentricity; props.Circularity; rel_cent_x1; rel_cent_y1]';

OUT = {'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' 'B' 'C' 'D' 'F' 'G' 'H' 'J' 'K' 'L' 'M' 'N' 'P' 'R' 'S' 'T' 'V' 'W' 'X' 'Y' 'Z'};

Classifier = TreeBagger(100, X, OUT);

%------------------------------------------- TEST WITH NEW IMAGES -------------------------------------------------------------

I = rgb2gray(imread('Joc_de_caracters_deformats.jpg'));
BI = I < 128;
BI = bwmorph(BI,'majority');
figure;
imshow(BI);
CC = bwconncomp(BI);

props = regionprops(CC,'MajoraxisLength','MinoraxisLength','Solidity','Extent','Circularity','Eccentricity','Centroid','BoundingBox');

ratio = [props(:).MinorAxisLength]./[props(:).MajorAxisLength];
centroids = cat(1, props.Centroid);
boxes = cat(1,props.BoundingBox);
centroid_x = ([centroids(:,1)]'-[boxes(:,1)]');
centroid_y = ([centroids(:,2)]'-[boxes(:,2)]');
rel_cent_x = centroid_x./[boxes(:,3)]';
rel_cent_y = centroid_y./[boxes(:,4)]';

X = [ratio; props.Solidity; props.Extent; props.Eccentricity; props.Circularity; rel_cent_x; rel_cent_y]';

[label,score] = predict(Classifier, X);
table(Classifier.ClassNames, label, max(score)', 'VariableNames',{'Name','Label','Score'})

