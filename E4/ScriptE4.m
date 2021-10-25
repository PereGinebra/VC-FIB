clear
close all

img = imread('Wally.png');
img1(:,:,1) = medfilt2(img(:,:,1), [1 4]);
img1(:,:,2) = medfilt2(img(:,:,2), [1 4]);
img1(:,:,3) = medfilt2(img(:,:,3), [1 4]);
imgHSV = rgb2hsv(img1);

yello =  0.133 <= imgHSV(:,:,1) <= 0.144;
blck = imgHSV(:,:,3) <= 0.2;

SE7 = strel('line',7,90);
SE14 = strel('sphere',14);
SE4 = strel('sphere',4);
SE2 = strel('sphere',2);
SE1 = strel('sphere',1);

ystripes = imerode(yello, SE7);
ystripes = yello - ystripes;
ystripes = imclose(ystripes, SE2);
ystripes = imopen(ystripes, SE4);
ystripes = imdilate(ystripes, SE1);

bstripes1 = imerode(blck, SE7);
bstripes = blck - bstripes1;
bstripes = imclose(bstripes, SE2);
bstripes = imopen(bstripes, SE2);
bstripes = imdilate(bstripes, SE1);

res = bstripes & ystripes;
res = imdilate(res, SE14);

resRGB(:,:,1) = uint8(255*res(:,:));
resRGB(:,:,2) = 0;
resRGB(:,:,3) = 0;

backGray = rgb2gray(img);
backGrayRGB = cat(3, backGray, backGray, backGray);

finalRGB = backGrayRGB + resRGB;

figure
montage({img, yello, blck, ystripes, bstripes, finalRGB})
figure
montage({img, finalRGB})
figure 
imshow(finalRGB);
