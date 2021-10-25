clear
close all

img = imread('Laberint.png');

imgHSV = rgb2hsv(img);
maze = imgHSV(:,:,3) > 0.5;
rdot = (imgHSV(:,:,1) < 0.1 | imgHSV(:,:,1) > 0.8) & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;
bdot = imgHSV(:,:,1) > 0.5 & imgHSV(:,:,1) < 0.8 & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;
gdot = imgHSV(:,:,1) < 0.4 & imgHSV(:,:,1) > 0.2 & imgHSV(:,:,2) > 0.6 & imgHSV(:,:,3) > 0.6;
mazeGray = uint16(1*maze);

trailbr = bdot;
trailgr = gdot;

tBR = uint16(1*trailbr);
tGT = uint16(1*trailgr);

ccrb = bwconncomp(trailbr|rdot);
ccrg = bwconncomp(trailgr|rdot);
trailRBsteps = 0;
trailRGsteps = 0;
SE1 = strel('sphere', 1);
while ccrb.NumObjects > 1 | ccrg.NumObjects > 1
    if ccrb.NumObjects > 1
        trailbr = trailbr+imdilate(trailbr, SE1)& maze;
        trailRBsteps = trailRBsteps + 1;
        ccrb = bwconncomp(trailbr|rdot);
    end
    if ccrg.NumObjects > 1
        trailgr = trailbr+imdilate(trailgr, SE1)& maze;
        trailRGsteps = trailRGsteps + 1;
        ccrg = bwconncomp(trailgr|rdot);
    end
end

dist = max(trailbr);

imshow(mazeGray)