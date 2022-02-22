% image is of size 150*130. Image is divided into 7 by 7 block. each block
% is of size 21 * 18
% LBP_u2_8_2 is used: u2 means use uniform pattern only; 8 sampling point,
% radius 2.

function LBP_map = generate_LBP_map(img,T)
% clear all;
% img = imread('C:\Documents and Settings\jfren\My Documents\MATLAB\ordinal LBP\fa\00001fa010_930831.tif');

imgSize = size(img);
LBP_map = zeros(imgSize(1),imgSize(2));

% maxI = max(img(:));
% minI = min(img(:));
% T = (maxI-minI)/256*T;

% generate LBP mapping;
P = 8;
R = 1;
% T = 5;

for i = 1:P
    x(i) = R*cos((i-1)*2*pi/P);
    y(i) = -R*sin((i-1)*2*pi/P);
end


hb = 1+R;

dy = imgSize(1)-1;
dx = imgSize(2)-1;

C = zeros(imgSize(1)+R*2,imgSize(2)+R*2);
C(R+1:R+imgSize(1),R+1:R+imgSize(2)) = img;
LBP_pixel = zeros(imgSize(1),imgSize(2),P);

for k = 1:P
    xx = x(k) + hb;
    yy = y(k) + hb;

    rx = round(xx);
    ry = round(yy);

    %             if rx > 130 | ry > 150
    %                 pause;
    %             end

    if (abs(xx - rx) < 1e-6) && (abs(yy - ry) < 1e-6)
        LBP_pixel(:,:,k) = (C(ry:ry+dy,rx:rx+dx)>img-T) + (C(ry:ry+dy,rx:rx+dx)>=img+T);
    else
        fx = floor(xx);
        fy = floor(yy);

        cx = ceil(xx);
        cy = ceil(yy);

        tx = xx-fx;
        ty = yy-fy;

        % Calculate the interpolation weights.
        w1 = (1 - tx) * (1 - ty);
        w2 =      tx  * (1 - ty);
        w3 = (1 - tx) *      ty ;
        w4 =      tx  *      ty ;

        % Compute interpolated pixel values
        N = w1*C(fy:fy+dy,fx:fx+dx) + w2*C(fy:fy+dy,cx:cx+dx) + w3*C(cy:cy+dy,fx:fx+dx) + w4*C(cy:cy+dy,cx:cx+dx);
        
%        tt = (abs(N-double(C))<1e-6);
        LBP_pixel(:,:,k) = (N >img-T)+(N >=img+T);
%        LBP_pixel(:,:,k) = LBP_pixel(:,:,k) | tt;
        
    end
    LBP_map = LBP_map + LBP_pixel(:,:,k).*3^(k-1);
end

% figure;
% imshow(uint8(LBP_map));
% 
% 123;

% save LBP_map2 LBP_map;

