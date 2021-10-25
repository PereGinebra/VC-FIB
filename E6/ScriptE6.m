clear
close all

img = imread('LoremIpsum.jpeg');
imgGray = rgb2gray(img);
h = imhist(imgGray);
plot(h);

%binarització del full de paper
BW = imgGray > 95;
figure
imshow(BW);

%retallat del full de paper
imgCrop = imcrop(imgGray, [153 69 977 1405]);
figure
imshow(imgCrop);

%filtre de columna, colFunc calcula la mitja de la finestra
F = colfilt(imgCrop, [35 15], 'sliding', @colFunc);

%binaritzat local  a partir del filtre de F
K = 0.85;
imgDouble = double(imgCrop);
letters = imgDouble < (K * F);

%neteja de la imatge amb imclose i anàlisis dels components connexos 
SE1 = strel('sphere', 1);
letters = imopen(letters, SE1);
figure
imshow(letters);
cons = bwconncomp(letters);
chars = cons.NumObjects

%montage dels passos i imatge binària final
montage({img, imgGray, BW, imgCrop, letters}) 
figure
imshow(imgCrop);
hold on

%encuadrament dels simbols detectats sobre la imatge original
contorns = regionprops(cons, 'BoundingBox');
for i = 1:chars
    rectangle('Position', contorns(i).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 1);
end


