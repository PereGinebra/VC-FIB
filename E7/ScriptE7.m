clear 
close all

img = imread('bigben.png');
imshow(img);

rect = getrect;
PI = 3.14159265359;

imgHSV = rgb2hsv(img);
imgH = imgHSV(:,:,1);
imgS = imgHSV(:,:,2);
imgV = imgHSV(:,:,3);

O(:,1) = cos(imgH(:)*2*PI);   %Hx
O(:,2) = sin(imgH(:)*2*PI);   %Hy
O(:,3) = imgS(:);
O(:,4) = imgV(:);

k = 35;
C = kmeans(O,k);

[n,m] = size(imgH);
IC = reshape(C,n,m); %transformem la llista C en una matriu
ICrgb = label2rgb(IC); %donem color als 'labels' de C
figure
imshow(ICrgb);

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

RES(:) = Hist1(:) > Hist0(:);

M(:) = RES(C(:));
IM = reshape(M,n,m);
figure
imshow(IM);

SE1 = strel('sphere', 3);
SE2 = strel('sphere', 5);
IMfilt = medfilt2(IM, [2 2]);
IMfilt = imopen(IMfilt, SE1);
IMfilt = imclose(IMfilt, SE1);
IMfilt = imopen(IMfilt, SE2);
figure
imshow(IMfilt);

SE3 = strel('sphere', 2);
IMcontorn = imdilate(IMfilt, SE3);
IMcontorn = IMcontorn - IMfilt;
figure 
imshow(IMcontorn);

imgSol(:,:,3) = max(uint8(IMcontorn(:,:)*255), img(:,:,3));
imgSol(:,:,2) = img(:,:,2)-(img(:,:,2).*uint8(IMcontorn(:,:)));
imgSol(:,:,1) = img(:,:,1)-(img(:,:,3).*uint8(IMcontorn(:,:)));

imshow(imgSol);
hold on
rectangle('Position', rect, 'EdgeColor', 'r');

% figure
% montage({ICrgb, IM, IMfilt, imgSol});