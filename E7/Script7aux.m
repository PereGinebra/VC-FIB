clear 
close all

img = imread('monster.jpg');
imshow(img);

rect = getrect;
PI = 3.14159265359;

imgHSV = rgb2hsv(img);
imgH = imgHSV(:,:,1);
imgS = imgHSV(:,:,2);
imgV = imgHSV(:,:,3);

[n,m] = size(imgH);

O(:,1) = cos(imgH(:)*2*PI);   %Hx
O(:,2) = sin(imgH(:)*2*PI);   %Hy
O(:,3) = imgS(:)*2;
O(:,4) = imgV(:)*2;
%calcular la distància de cada pixel al rectangle
distToRect = zeros(n,m);
for i = 1:n
    for j = 1:m
        distToRect(i,j) = distFromRectangle2(i,j,rect);
    end
end
boxImportance = 1.4; %importancia de la distancia del rectangle
O(:,5) = distToRect(:)/(norm([0,0]-[n,m])/boxImportance); 

k = 35;
C = kmeans(O,k);


IC = reshape(C,n,m); 
rgb = label2rgb(IC);
figure
imshow(rgb);

MASK = zeros(n,m);
MASK(rect(2):(rect(2)+rect(4)), rect(1):(rect(1)+rect(3))) = 1;

H = [C, MASK(:)];

Hist0 = zeros(1,k);
Hist1 = zeros(1,k);

for i = 1:(n*m)
    if H(i,2) == 1 
        Hist1(H(i,1)) = Hist1(H(i,1)) + 1; 
    else 
        Hist0(H(i,1)) = Hist0(H(i,1)) + 1;
    end
end

%les divisions per fer el nombre relatiu a la mida del rectangle
RES(:) = Hist1(:)/(rect(3)*rect(4)) > Hist0(:)/((m*n)-(rect(3)*rect(4)));

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

SE3 = strel('sphere', 2);
IMcontorn = imdilate(IM, SE3);
IMcontorn = IMcontorn - IM;
figure 
imshow(IMcontorn);

imgSol(:,:,3) = max(uint8(IMcontorn(:,:)*255), img(:,:,3));
imgSol(:,:,2) = img(:,:,2)-(img(:,:,2).*uint8(IMcontorn(:,:)));
imgSol(:,:,1) = img(:,:,1)-(img(:,:,3).*uint8(IMcontorn(:,:)));

imshow(imgSol);
hold on
rectangle('Position', rect, 'EdgeColor', 'r');
