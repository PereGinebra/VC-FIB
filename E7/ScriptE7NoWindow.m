clear 
close all

img = imread('bigben.png');
imshow(img);

% rect = getrect;

PI = 3.14159265359;

imgHSV = rgb2hsv(img);
imgH = imgHSV(:,:,1);
imgS = imgHSV(:,:,2);
imgV = imgHSV(:,:,3);

[n,m] = size(imgH);

O(:,1) = cos(imgH(:)*2*PI);   %Hx
O(:,2) = sin(imgH(:)*2*PI);   %Hy
O(:,3) = imgS(:);
O(:,4) = imgV(:);
distToCenter = zeros(n,m);
for i = 1:n
    for j = 1:m
        distToCenter(i,j) = norm([i,j]-[n/2,m/2]);
    end
end
boxImportance = 1; %importancia de la distancia del rectangle
O(:,5) = distToCenter(:)/(norm([0,0]-[n,m])/boxImportance); 

k = 35;
C = kmeans(O,k);

IC = reshape(C,n,m); 
rgb = label2rgb(IC);
figure
imshow(rgb);

Hist0 = zeros(1,k);
Hist1 = zeros(1,k);

H = [C, distToCenter(:)];
distanceToFocus = 0.34; %how many half diagonals do you want the circle's diagonal to be
diagonal = sqrt(n^2+m^2)/2; %half diagonal (distance from centre to a corner)

for i = 1:(n*m)
    if H(i,2) < distanceToFocus*diagonal
        Hist1(H(i,1)) = Hist1(H(i,1)) + 1; 
    else 
        Hist0(H(i,1)) = Hist0(H(i,1)) + 1;
    end
end

RES(:) = Hist1(:) > Hist0(:);

M(:) = RES(C(:));
IM = reshape(M,n,m);
figure
imshow(IM);

SE1 = strel('sphere', 3);
SE2 = strel('sphere', 5);
IM = medfilt2(IM, [2 2]);
IM = imopen(IM, SE1);
IM = imclose(IM, SE1);
IM = imopen(IM, SE2);
figure
imshow(IM);

%pinta el contorn de l'objecte
SE3 = strel('sphere', 2);
IMcontorn = imdilate(IM, SE3);
IMcontorn = IMcontorn - IM;
figure 
imshow(IMcontorn);

imgSol(:,:,3) = max(uint8(IMcontorn(:,:)*255), img(:,:,3));
imgSol(:,:,2) = img(:,:,2)-(img(:,:,2).*uint8(IMcontorn(:,:)));
imgSol(:,:,1) = img(:,:,1)-(img(:,:,3).*uint8(IMcontorn(:,:)));

%pinta el cercle que s'utilitza com a finestra 
imgSol(:,:,1) = max(uint8(distanceToFocus*diagonal > distToCenter(:,:)-1 & distToCenter(:,:)+1 > distanceToFocus*diagonal)*255, imgSol(:,:,1));
imshow(imgSol);
