clear 
close all

%------------------------------------------- SET UP THE CLASSIFIER -------------------------------------------------------------

I = rgb2gray(imread('Joc_de_caracters.jpg'));
BI = I < 128;
imshow(BI)

CC = bwconncomp(BI);

props = regionprops(CC,'Area','MajoraxisLength','MinoraxisLength','Solidity','Extent','Circularity','Eccentricity','EulerNumber','Centroid','BoundingBox');
ratio = [props(:).MinorAxisLength]./[props(:).MajorAxisLength];
boxes = cat(1,props.BoundingBox);
centroids = cat(1, props.Centroid);
centroid_x1 = ([centroids(:,1)]'-[boxes(:,1)]');
centroid_y1 = ([centroids(:,2)]'-[boxes(:,2)]');
rel_cent_x1 = centroid_x1./[boxes(:,3)]';
rel_cent_y1 = centroid_y1./[boxes(:,4)]';
% X = [props.Area; ratio_axis]';  
X = [ratio; props.Extent; props.Circularity; props.Eccentricity; rel_cent_x1; rel_cent_y1]';

OUT = {'0' '1' '2' '3' '4' '5' '6' '7' '8' '9' 'B' 'C' 'D' 'F' 'G' 'H' 'J' 'K' 'L' 'M' 'N' 'P' 'R' 'S' 'T' 'V' 'W' 'X' 'Y' 'Z'};

Classifier = TreeBagger(100, X, OUT);

%------------------------------------------- TEST WITH NEW IMAGES -------------------------------------------------------------

img = rgb2gray(imread('Matricula2093gsw.png'));
figure;
imshow(img);
BI = img < 65;
BI = bwmorph(BI,'majority');
figure;
imshow(BI);

CC = bwconncomp(BI);
props = regionprops(CC,'Area', 'MajoraxisLength', 'MinoraxisLength','Solidity','Extent','Circularity','Eccentricity','EulerNumber','Centroid','BoundingBox');
ratio = [props(:).MinorAxisLength]./[props(:).MajorAxisLength];
boxes = cat(1,props.BoundingBox);
centroids = cat(1, props.Centroid);
centroid_x = ([centroids(:,1)]'-[boxes(:,1)]');
centroid_y = ([centroids(:,2)]'-[boxes(:,2)]');
rel_cent_x = centroid_x./[boxes(:,3)]';
rel_cent_y = centroid_y./[boxes(:,4)]';
% X = [props.Area; ratio_axis]';  
X = [ratio; props.Extent; props.Circularity; props.Eccentricity; rel_cent_x; rel_cent_y]';

%matricula = ['5';'6';'4';'9';'J';'S';'N'];
matricula = ['2';'0';'9';'3';'G';'S';'W'];
X_mat = [X(:,:); X(:,:); X(:,:); X(:,:); X(1:2,:)];

[label,score] = predict(Classifier, X_mat);
label1 = label(1:7);
score1 = score(1:7,:)';
m = max(score1)';
table(matricula, label1, m, 'VariableNames',{'Name','Label','Score'})

