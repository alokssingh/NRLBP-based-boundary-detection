clc
clear all
%% Preprocessing
video_name  = 'D3.mpg';
video = VideoReader(video_name);
frame = video.NumberOfFrames ;
load LUT;
Thres = 10;
I = read(video,1);
I = rgb2gray(I);
I = imresize(I,[60,60]);
his1 =  get_NRLBP_hist_per_img(double(I),LUT,Thres);  
a = [];
dis=[];tic
%% NRLBP histogram extraction and dissimilarity computation
for k = 2:frame
    I2 = read(video,k);
    I2 = rgb2gray(I2);
    I2 = imresize(I2,[60,60]);
    his2= get_NRLBP_hist_per_img(double(I2),LUT,Thres);
    p = sqrt(sum((his1 - his2).^2));
    a = [a;p];
    his1 = his2;
end  
%% Boundary declaraition 
x = a(:,1)/max(a(:,1));
cut = [];
Th = mean(x)+(1.9*std(x));     
for i= 2:length(x)-1
    if  x(i) >= Th &&((x(i)-x(i-1))>Th+(Th/2)&&(x(i)-x(i+1))>Th+(Th/2))
        cut = [cut;i+1];
    end   
end 
%% Output visualization
toc

for j= 1:length(cut)   
    subplot(1,2,2);imshow(read(video,cut(j))); xlabel(cut(j));
    subplot(1,2,1);imshow(read(video,cut(j)-1)); xlabel(cut(j)-1);
    pause(1)
end
