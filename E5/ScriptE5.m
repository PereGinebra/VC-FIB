clear
close all

img = imread('Laberint.png');

imgHSV = rgb2hsv(img);
maze = imgHSV(:,:,3) > 0.6;
rdot = (imgHSV(:,:,1) < 0.1 | imgHSV(:,:,1) > 0.8) & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;
bdot = imgHSV(:,:,1) > 0.5 & imgHSV(:,:,1) < 0.8 & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;
gdot = imgHSV(:,:,1) < 0.4 & imgHSV(:,:,1) > 0.2 & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;

% EXERCICI 1

trailbr = bdot;
trailgr = gdot;

ccrb = bwconncomp(trailbr|rdot);
ccrg = bwconncomp(trailgr|rdot);
trailRBsteps = 0;
trailRGsteps = 0;
SE1 = strel('sphere', 1);
while ccrb.NumObjects > 1 | ccrg.NumObjects > 1
    if ccrb.NumObjects > 1
        trailbr = imdilate(trailbr, SE1)& maze;
        trailRBsteps = trailRBsteps + 1;
        ccrb = bwconncomp(trailbr|rdot);
    end
    if ccrg.NumObjects > 1
        trailgr = imdilate(trailgr, SE1)& maze;
        trailRGsteps = trailRGsteps + 1;
        ccrg = bwconncomp(trailgr|rdot);
    end
end
montage({img, maze, trailbr, trailgr});


% EXERCICI 2

distR = bwdistgeodesic(maze, rdot);
distB = bwdistgeodesic(maze, bdot);
distG = bwdistgeodesic(maze, gdot);

RB = distR + distB;
RG = distR + distG;

%substituim les distancies no numeriques per infinit pq no falli el regionalmin
RB(isnan(RB)) = inf; 
pathsB = imregionalmin(RB);
solution_pathB = bwmorph(pathsB, 'thin', inf);
solrb = imoverlay(img, solution_pathB, [0 0 1]);

RG(isnan(RG)) = inf;
pathsG = imregionalmin(RG);
solution_pathG = bwmorph(pathsG, 'thin', inf);
solrg = imoverlay(img, solution_pathG, [0 1 0]);

solution_path = solution_pathB | solution_pathG;
sol = imoverlay(img, solution_path, [1 1 0]);
figure
montage({solrb, solrg, sol})
figure 
imshow(sol)
