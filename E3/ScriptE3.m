 clear 
 close all

 i1 = imread('_61A5845.jpg');
 i2 = imread('_61A5855.jpg');
 i3 = imread('_61A5861.jpg');
 
 img1 = double(rgb2gray(i1));
 img2 = double(rgb2gray(i2));
 img3 = double(rgb2gray(i3));
 
 h_Sobv = fspecial('sobel');
 h_Sobh = h_Sobv';
 %  h_Lap = fspecial('laplacian');
 
 s1 = abs(imfilter(img1,h_Sobv)) + abs(imfilter(img1,h_Sobh));
 s2 = abs(imfilter(img2,h_Sobv)) + abs(imfilter(img2,h_Sobh));
 s3 = abs(imfilter(img3,h_Sobv)) + abs(imfilter(img3,h_Sobh)); 
 
 montage({i1, i2, i3})
 figure
 imshow(s1,[])
 figure
 imshow(s2,[])
 figure 
 imshow(s3,[])
 
 [rows, columns] = size(img1);
 centre_pond = 0.2; %com més baix el valor, més importància se li dona al centre
 matgauss = fspecial('gaussian',[rows,columns],((rows+columns)/2)*centre_pond );
 matgauss = (matgauss)*10000;
 
 m1 = sum(sum(s1.*matgauss))/(rows*columns)
 m2 = sum(sum(s2.*matgauss))/(rows*columns)
 m3 = sum(sum(s3.*matgauss))/(rows*columns)
 
 
 