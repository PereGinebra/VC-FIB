clear
close all

% Point cloud creation
x = rand(1,100) + rand();   % 100 punts aleatoris amb un offset aleatori
y = rand().*x  + rand(1,100)/10; % pendent i offset aleatoris

scatter(x,y,'.');
grid on;
axis('equal');

% Cloud point centering
xp = x - mean(x);
yp = y - mean(y);

% Covariance and eigen values
c = cov(xp, yp);
[evectors, evalues] = eig(c);

% Determine which dimension has the major variance  
[val,ind] = max(diag(evalues));

% Extract the angle of the ‘major axis’
% obtenim l'angle a partir de l'arctangent dels components de
% l'eigenvector adequat
theta = -pi/2-atan2(evectors(ind,1),evectors(ind,2));

% Create clockwise rotation matrix
R = [cos(theta) sin(theta); -sin(theta) cos(theta)];

% Rotate the points 
rp = R * [xp;yp];

% Draw the points
figure
scatter(rp(1,:),rp(2,:),'.');
axis('equal');
xline(0);
yline(0);
grid on