% HW2 Ex 3:
 
StopSigns_Images_Path = [cd,'\Stop Images\'];
addpath([cd,'/sift']);
 
%% 1. For each image from “Stop images” directory, extract its SIFT descriptor using the function sift.m
%  
%  and:
%
%  2. Find matching key-points: use the function siftmatch which gets two sets of SIFT descriptors
%      (corresponding to two images) and return matching key points. Show all matching key-points using
%      the function plotmatches, for the following image pairs:
%      StopSign1-StopSign2, StopSign1-StopSign3, StopSign1-StopSign4.
 
close all;
for ImgInd = 1:4
    
    StopSign{ImgInd} = imread([StopSigns_Images_Path,'StopSign',num2str(ImgInd),'.jpg']);
    StopSignForSift{ImgInd} = double(rgb2gray(StopSign{ImgInd}));
    
    % Normalize the image for the sift.m function:
    StopSignForSift{ImgInd} = StopSignForSift{ImgInd} ./ max(StopSignForSift{ImgInd}(:));
 
    StopSignNormalized{ImgInd} = double(StopSign{ImgInd});
    StopSignNormalized{ImgInd} = StopSignNormalized{ImgInd} ./ max(StopSignNormalized{ImgInd}(:));
           
    [frames{ImgInd},descriptors{ImgInd},~,~] = sift(StopSignForSift{ImgInd});
    
    figure;
    imshow(StopSignForSift{ImgInd});
    hold on;
    plotsiftframe(frames{ImgInd},'style','arrow');
    
 
end
 
% Find SIFT matches for all 3 examples:
Matches{1} = siftmatch(descriptors{1},descriptors{2});
Matches{2} = siftmatch(descriptors{1},descriptors{3});
Matches{3} = siftmatch(descriptors{1},descriptors{4});
 
figure;
plotmatches(StopSignNormalized{1},StopSignNormalized{2},frames{1},frames{2},Matches{1});
figure;
plotmatches(StopSignNormalized{1},StopSignNormalized{3},frames{1},frames{3},Matches{2});
figure;
plotmatches(StopSignNormalized{1},StopSignNormalized{4},frames{1},frames{4},Matches{3});
 
% 3. Implement a function that gets a set of matching points between two images and calculates the affine
%    transformation between them. The transformation should be 3x3 H homogenous matrix such that
%    each key-point in the first image, p , will map to its corresponding key-points in the second image, p_gal
%    , according to p = H * p_gal . How many points are needed?
 
IsUseMatchForTransCalc = ones(size(Matches{1},2),1);
[AffineMatchingTrans{1}, IsMatchAnInLayer] = CalculateAffineMatching(frames{1},frames{2},Matches{1},IsUseMatchForTransCalc);
 
%% 4.
 
% a. + b. + c.
 
[RANSAC_Matches ,AffineMatchingTrans{1}] = CalcOptimalMatches(frames{1},frames{2},Matches{1});
figure;
plotmatches(StopSignNormalized{1},StopSignNormalized{2},frames{1},frames{2},RANSAC_Matches);
 
[RANSAC_Matches,AffineMatchingTrans{2}] = CalcOptimalMatches(frames{1},frames{3},Matches{2});
figure;
plotmatches(StopSignNormalized{1},StopSignNormalized{3},frames{1},frames{3},RANSAC_Matches);
 
[RANSAC_Matches,AffineMatchingTrans{3}] = CalcOptimalMatches(frames{1},frames{4},Matches{3});
figure;
plotmatches(StopSignNormalized{1},StopSignNormalized{4},frames{1},frames{4},RANSAC_Matches);
 
%% 5. Image warping: Implement a function that gets an input image and an affine transformation and
%     returns the projected image. Please note that after the projection there will be coordinates which
%     won’t be integers (e.g sub-pixels), therefor you will need to interpolate between neighboring pixels.
%     For color images, project each color channel separately.
%     Note: imwarp() is not allowed. You need to write your own
 
for image_ind = 1:3
    xGrid = 1:1:(size(StopSignNormalized{image_ind+1},2));
    yGrid = 1:1:(size(StopSignNormalized{image_ind+1},1));
    WarpedImage{image_ind} = WarpImage(StopSignNormalized{1}, AffineMatchingTrans{image_ind},xGrid , yGrid);
    figure;
    f1 = subplot(2,1,1);
    imshow(StopSignNormalized{image_ind+1});
    f2 = subplot(2,1,2);
    imshow(WarpedImage{image_ind});
    linkaxes([f1 f2],'xy');
end
 
 
%% 6. Stitching: Implement a function that gets two images after alignment and returns a union of the two.
%     The union should be simple overlay of one image on the other. Leave empty pixels painted black.
for image_ind = 1:3    
    OutputImage{image_ind} = StitchImages(WarpedImage{image_ind}, StopSignNormalized{image_ind+1});   
    figure;
    imshow(OutputImage{image_ind});
end
