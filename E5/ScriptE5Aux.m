clear
close all

img = imread('Laberint.png');

imgHSV = rgb2hsv(img);
maze = imgHSV(:,:,3) > 0.5;
rdot = (imgHSV(:,:,1) < 0.1 | imgHSV(:,:,1) > 0.8) & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;
bdot = imgHSV(:,:,1) > 0.5 & imgHSV(:,:,1) < 0.8 & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;
gdot = imgHSV(:,:,1) < 0.4 & imgHSV(:,:,1) > 0.2 & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;



distR = bwdistgeodesic(maze, rdot);
distB = bwdistgeodesic(maze, bdot);
distG = bwdistgeodesic(maze, gdot);

RB = distR + distB;
RG = distR + distG;

RB(isnan(RB)) = inf; %substituim les distancies no numeriques per infinit pq no falli el regionalmin
pathsB = imregionalmin(RB);
solution_pathB = bwmorph(pathsB, 'thin', inf);
solrb = imoverlay(img, solution_pathB, [0 0 1]);

RG(isnan(RG)) = inf;
pathsG = imregionalmin(RG);
solution_pathG = bwmorph(pathsG, 'thin', inf);
solrg = imoverlay(img, solution_pathG, [0 1 0]);

solution_path = solution_pathB | solution_pathG;
sol = imoverlay(img, solution_path, [1 1 0]);
montage({solrb, solrg, sol})


