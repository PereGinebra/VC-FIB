clear 
close all

img = rgb2gray(imread('Matricula5649jsn.png'));
imshow(img);
BI = img < 65;
BI = bwmorph(BI,'majority');
figure;
imshow(BI);