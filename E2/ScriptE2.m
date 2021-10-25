clear 
close all

A = double(imread('A:\UNI\Optatives\VC\Informes Lab\E2\_MG_7735.JPG'));
B = double(imread('A:\UNI\Optatives\VC\Informes Lab\E2\_MG_7737.jpg'));

% DIF = abs(A-B); % imatge diferencia
% maxim = max(DIF(:));
% DIF = DIF/maxim; % dividim pel seu valor màxim
% imshow(DIF);

% figure
Bd = imtranslate(B, [20, -20]);
% DIF = abs(A-Bd);
% maxim = max(DIF(:));
% DIF = DIF/maxim;
% imshow(DIF);

figure
Am = (A+Bd)/2; %mitjana entre les dos imatges
%edició de l'imatge resultant: 
Am = arrayfun(@(x) x+max(0,-(x/18-6.8)^2+30), Am); %iluminacio parts mitjanament fosques (quadrat invertit)
%augmenta el contrast de les parts més fosques (log pels valors molt baixos i exp pels altres)
Am = arrayfun(@(x) x*(1.+min(max(0,log(x/10)) ,exp(-x/50))), Am); 
Am = uint8(Am);
Am2 = imlocalbrighten(Am, 0.40); %una mica més d'iluminació
Am2 = imadjust(Am2, [.14 .14 .14; 1 1 1], []); %augmenta el contrast i saturació
%netejar una mica el soroll fent la mitjana dels pixels veins (finestra 6x6):
Am3(:,:,1) = medfilt2(Am2(:,:,1), [8 8]);
Am3(:,:,2) = medfilt2(Am2(:,:,2), [8 8]);
Am3(:,:,3) = medfilt2(Am2(:,:,3), [8 8]); 

Ar = uint8(A);

%1-original, 2-amb les arrayfun, 3-amb imlocalbrighten, 4-amb reducció de soroll
montage ({Ar, Am, Am2, Am3});
figure
histogram(Am);
figure
histogram(Am3);
