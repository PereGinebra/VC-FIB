 clear 
 close all

 i1 = imread('SmintBack .jpeg');
 i2 = imread('SmintFront.jpeg');
 
 img1 = double(rgb2gray(i1));
 img2 = double(rgb2gray(i2));
 
 h_Sobv = fspecial('sobel');
 h_Sobh = h_Sobv';
 h_Lap = fspecial('laplacian');
 
 s1 = abs(imfilter(img1,h_Sobv)) + abs(imfilter(img1,h_Sobh));
 s2 = abs(imfilter(img2,h_Sobv)) + abs(imfilter(img2,h_Sobh)); 
 
 [rows, columns] = size(img1);
 centre_pond = 0.15; %com més baix el valor, més importància se li dona al centre
 matgauss = fspecial('gaussian',[rows,columns],((rows+columns)/2)*centre_pond );
 matgauss = (matgauss)*10000;
 
 m1 = sum(sum(s1.*matgauss))/(rows*columns)
 m2 = sum(sum(s2.*matgauss))/(rows*columns)
 
 montage({i1, i2})
 figure
 imshow(s1,[])
 figure
 imshow(s2,[])

