% polygonal boundary of a BW image
I = imread('Joc_de_caracters.jpg');
[f,c] = size(I);
imshow(I); 

%binarization
BW = rgb2gray(I) < 168;

%conected components
CC = bwconncomp(BW);

%pixel list to coordinates
[F,C] = ind2sub([f,c], CC.PixelIdxList{23});

% exterior boundary
b = boundary([F,C]);

% some boundary measures
c_center = mean(C(b)); % center
f_center = mean(F(b));

%min and max radius
min_r = sqrt(min((C(b) - c_center).^2 + (F(b) - f_center).^2)); 
max_r = sqrt(max((C(b) - c_center).^2 + (F(b) - f_center).^2)); 
r = min_r /max_r;

%plot boundary
figure;
imshow(BW);
plot(C(b),f-F(b),'LineWidth',2,'Color',[1 0 0]);hold;
plot(c_center,f-f_center,'*b');